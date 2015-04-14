//
//  S2GridView.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2GridView.h"
#import "S2Appearance.h"
#import "S2Grid.h"
#import "Position.h"

@implementation S2GridView

#pragma mark - Initiation

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [S2Appearance scoreBoardColor];
        self.layer.cornerRadius = CORNER_RADIUS;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)init
{
    NSInteger sideLength = DIMENSION * (TILE_SIZE + BOARDER_WIDTH) + BOARDER_WIDTH;
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - [S2Appearance verticalOffset] - sideLength;
    return [self initWithFrame:CGRectMake([S2Appearance horizontalOffset], verticalOffset, sideLength, sideLength)];
}

#pragma mark - Background creation

+ (UIImage *)gridImageWithGrid:(S2Grid *)grid
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [S2Appearance backgroundColor];
    
    S2GridView *view = [[S2GridView alloc] init];
    [backgroundView addSubview:view];
    
    [grid forEach:^(S2Position position) {
        CALayer *layer = [CALayer layer];
        CGPoint location = [Position locationOfPosition:position];
        [view.layer addSublayer:layer];
        
        [layer setBounds:CGRectMake(0, 0, TILE_SIZE, TILE_SIZE)];
        [layer setPosition:CGPointMake(location.x + TILE_SIZE / 2 - [S2Appearance horizontalOffset], location.y + TILE_SIZE / 2 - [S2Appearance verticalOffset])];
        layer.backgroundColor = [S2Appearance boardColor].CGColor;
        layer.cornerRadius = CORNER_RADIUS;
        layer.masksToBounds = YES;
        
    } inReverseOrder:NO];
    
    return [S2GridView snapshotWithView:backgroundView];
}

+ (UIImage *)gridImageWithOverlay
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.opaque = NO;
    
    S2GridView *view = [[S2GridView alloc] init];
    view.backgroundColor = [[S2Appearance backgroundColor] colorWithAlphaComponent:0.8];
    [backgroundView addSubview:view];
    
    return [S2GridView snapshotWithView:backgroundView];
}

//Take a snapshot of current back ground view
+ (UIImage *)snapshotWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
