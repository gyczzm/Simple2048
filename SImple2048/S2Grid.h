//
//  S2Grid.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S2Cell.h"

@class S2Scene;

typedef void (^IteratorBlock)(S2Position);

@interface S2Grid : NSObject

//The scene to which the grid beongs
@property (nonatomic, weak) S2Scene *scene;

//Iterate through all posotions,optionally by reversed order
- (void)forEach:(IteratorBlock)block inReverseOrder:(BOOL)reverse;

//Cell at specific position
- (S2Cell *)cellAtPosition:(S2Position)position;

//Tile at specific position
- (S2Tile *)tileAtPosition:(S2Position)position;

//Whether or not the grid has empty cell
- (BOOL)hasAvailableCells;

//Insert a tile to random empty cell with optional delay
- (void)insertTileAtRandomAvailableCell:(BOOL)delay;

//Remove specific tile with optional animation
- (void)removeAllTilesAnimated:(BOOL)animated;

@end
