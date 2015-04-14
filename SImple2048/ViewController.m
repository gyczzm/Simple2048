//
//  ViewController.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "ViewController.h"
#import "S2Scene.h"

#import "S2GridView.h"
#import "S2ScoreView.h"
#import "S2Overlay.h"

#import "S2GameManager.h"
#import "S2Appearance.h"

#define Settings [NSUserDefaults standardUserDefaults]
#define bestScore @"Best Score"
#define currentScore @"Current Score"

@interface ViewController ()

@end

// The min distance in one direction for an effective swipe.
#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f

// The max ratio between the translation in x and y directions
// to make a swipe valid. i.e. diagonal swipes are invalid.
#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

@implementation ViewController
{
    __weak IBOutlet UIButton *_restartButton;
    __weak IBOutlet UILabel *_targetScore;
    __weak IBOutlet UILabel *_subtitle;
    __weak IBOutlet S2ScoreView *_scoreView;
    __weak IBOutlet S2ScoreView *_bestView;
    __weak IBOutlet S2Overlay *_overlay;
    __weak IBOutlet UIImageView *_overlayBackground;
    
    S2GameManager *_gameManager;
    S2Scene *_scene;
    
//    Each swipe triggers at most one action, and we don't wait the swipe to complete
//    before triggering the action (otherwise the user may swipe a long way but nothing
//    happens). So after a swipe is done, we turn this flag to NO to prevent further
//    moves by the same swipe.
    BOOL _hasPendingSwipe;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAppearance];

    _gameManager = [[S2GameManager alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:_gameManager selector:@selector(saveStatus) name:@"applicationDidEnterBackground" object:nil];
    
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:bestScore]];
    _overlay.hidden = YES;
    _overlayBackground.hidden = YES;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    S2Scene * scene = [S2Scene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self updateScore:0];
    
    _scene = scene;
    _scene.delegate = self;
    
    [_gameManager startNewSessionWithScene:_scene];
//    [self updateAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance Setup

//Load the contents whose appearance won't change
- (void)loadAppearance
{
    [_scoreView loadAppearance];
    [_bestView loadAppearance];
    [_overlay loadAppearance];
    
    _targetScore.textColor = [S2Appearance buttonColor];
    _targetScore.font = [UIFont fontWithName:BOLD_FONT_NAME size:42];
    
    _subtitle.textColor = [S2Appearance buttonColor];
//    _subtitle.font = [UIFont fontWithName:REGULAR_FONT_NAME size:14];
    
    _restartButton.layer.cornerRadius = CORNER_RADIUS;
    _restartButton.layer.masksToBounds = YES;
    _restartButton.backgroundColor = [S2Appearance buttonColor];
    _restartButton.titleLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:16];
}


//Update appearance according to loaded data by gameManager
- (void)updateAppearance
{
    NSMutableArray *currentTiles = [[NSMutableArray alloc] init];
    NSString *path = [_gameManager archivePath];
    
    currentTiles = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (!currentTiles) {
        [_gameManager startNewSessionWithScene:_scene];
    } else {
        _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:currentScore]];
        [_gameManager loadStatus:currentTiles onScene:_scene];
    }
}

#pragma mark - Public methods

- (void)updateScore:(NSInteger)score
{
    _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    if ([Settings integerForKey:bestScore] < score) {
        [Settings setInteger:score forKey:bestScore];
        _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
}

- (void)endGame:(BOOL)won
{
    _overlay.hidden = NO;
    _overlay.alpha = 0;
    _overlayBackground.hidden = NO;
    _overlayBackground.alpha = 0;
}

#pragma mark - Swipe gesture handler

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe
{
    if (swipe.state == UIGestureRecognizerStateBegan) {
        _hasPendingSwipe = YES;
    } else if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:_scene.view]];
    }
}

- (void)commitTranslation:(CGPoint)translation
{
    if (!_hasPendingSwipe) return;
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    //If swipe is too short,do nothing
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD) return;
    
    if (absX > absY * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.x < 0 ? [_gameManager moveToDirection:S2DirectionLeft] :
                            [_gameManager moveToDirection:S2DirectionRight];
    } else if (absY > absX * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.y < 0 ? [_gameManager moveToDirection:S2DirectionUp] :
                            [_gameManager moveToDirection:S2DirectionDown];
    }
    
    _hasPendingSwipe = NO;
//    //for test
//    NSLog(@"commited translation ################################");
}
#pragma mark - Action handlers

- (IBAction)keepPlaying:(id)sender
{
    [self hideOverlay];
}

- (IBAction)restartGame:(id)sender
{
    [self hideOverlay];
    [self updateScore:0];
    [_gameManager startNewSessionWithScene:_scene];
}

- (void)hideOverlay
{
    ((SKView *)self.view).paused = NO;
    if (!_overlay.hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            _overlay.alpha = 0;
            _overlayBackground.alpha = 0;
        }completion:^(BOOL finished) {
            _overlay.hidden = YES;
            _overlayBackground.hidden = YES;
        }];
    }
}

@end
