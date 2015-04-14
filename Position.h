//
//  Position.h
//  SImple2048
//
//  Created by zhuxi on 15/4/14.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef m2048_M2Position_h
#define m2048_M2Position_h

typedef struct Position {
    NSInteger x;
    NSInteger y;
} S2Position;

CG_INLINE S2Position S2PositionMake(NSInteger x, NSInteger y)
{
    S2Position position;
    position.x = x; position.y = y;
    return position;
}

#endif

@interface Position : NSObject

+ (CGPoint)locationOfPosition:(S2Position)position;

+ (CGFloat)xLocationOfPosition:(S2Position)position;

+ (CGFloat)yLocationOfPosition:(S2Position)position;


+ (CGVector)distanceFromPosition:(S2Position)oldPosition toPosition:(S2Position)newPosition;

@end
