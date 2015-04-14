//
//  S2Scene.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2Scene.h"
#import "S2GameManager.h"
#import "S2GridView.h"
#import "ViewController.h"

@implementation S2Scene

- (void)loadBoardWithGrid:(S2Grid *)grid
{
    UIImage *image = [S2GridView gridImageWithGrid:grid];
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:image.CGImage];
    SKSpriteNode *board = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    [board setScale:0.5];
    board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:board];
}

//Capture swipe gesture
- (void)didMoveToView:(SKView *)view
{
    if (view == self.view) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(forwardSwipe:)];
        [self.view addGestureRecognizer:recognizer];
    }
    else {
        for (UIPanGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}

- (void)forwardSwipe:(UIPanGestureRecognizer *)swipe
{
    [self.delegate handleSwipe:swipe];
}


@end
