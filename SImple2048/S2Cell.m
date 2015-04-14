//
//  S2Cell.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2Cell.h"
#import "S2Tile.h"
#import "S2Appearance.h"

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

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    S2Position cellPosition = self.position;
    NSData *positionData = [NSData dataWithBytes:&cellPosition length:sizeof(S2Position)];
    [aCoder encodeInteger:self.tile.power forKey:@"power"];
    [aCoder encodeCGPoint:self.tile.position forKey:@"tilePosition"];
    [aCoder encodeObject:positionData forKey:@"cellPosition"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.tile = [[S2Tile alloc] init];
        
        //Initiate position
        self.tile.position = [aDecoder decodeCGPointForKey:@"tilePosition"];
        
        //Initiate value label with archived value
        self.tile.power = [aDecoder decodeIntegerForKey:@"power"];
        [self.tile refreshValue];
        
        NSData *positionData = [aDecoder decodeObjectForKey:@"cellPosition"];
        S2Position cellPosition;
        [positionData getBytes:&cellPosition length:sizeof(cellPosition)];
        
        self.position = cellPosition;
    }
    return self;
}

@end
