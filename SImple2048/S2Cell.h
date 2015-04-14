//
//  S2Cell.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"

@class S2Tile;

@interface S2Cell : NSObject

@property (nonatomic) S2Position position;

@property (nonatomic, strong) S2Tile *tile;

- (instancetype)initWithPosition:(S2Position)position;

//Save current status when user quits game
- (void)encodeWithCoder:(NSCoder *)aCoder;

//Load tile status when game starts
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
