//
//  S2Cell.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2Cell.h"
#import "S2Tile.h"

@implementation S2Cell

- (instancetype)initWithPosition:(S2Position)position
{
    if (self = [super init]) {
        self.position = position;
        self.tile = nil;
    }
    
    return self;
}

- (void)setTile:(S2Tile *)tile
{
    _tile = tile;
    if (tile) {
        tile.cell = self;
    }
}

@end
