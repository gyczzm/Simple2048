//
//  Position.m
//  SImple2048
//
//  Created by zhuxi on 15/4/14.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "Position.h"
#import "S2Appearance.h"

@implementation Position

+ (CGPoint)locationOfPosition:(S2Position)position
{
    return CGPointMake([self xLocationOfPosition:position] + [S2Appearance horizontalOffset],
                       [self yLocationOfPosition:position] + [S2Appearance verticalOffset]);
}


+ (CGFloat)xLocationOfPosition:(S2Position)position
{
    return position.x * (TILE_SIZE + BOARDER_WIDTH) + BOARDER_WIDTH;
}


+ (CGFloat)yLocationOfPosition:(S2Position)position
{
    return position.y * (TILE_SIZE + BOARDER_WIDTH) + BOARDER_WIDTH;
}


+ (CGVector)distanceFromPosition:(S2Position)oldPosition toPosition:(S2Position)newPosition
{
    CGFloat unitDistance = TILE_SIZE + BOARDER_WIDTH;
    return CGVectorMake((newPosition.x - oldPosition.x) * unitDistance,
                        (newPosition.y - oldPosition.y) * unitDistance);
}

@end
