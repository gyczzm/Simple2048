//
//  S2Tile.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class S2Cell;

@interface S2Tile : SKShapeNode<NSCoding>

//Power of 2 of the tile
@property (nonatomic) NSInteger power;

//The cell to which the tile belong
@property (nonatomic, weak) S2Cell *cell;

//Insert the tile to specific cell
+ (S2Tile *)insertNewTileToCell:(S2Cell *)cell;

//Commit the merge action
- (NSInteger)mergeWithTile:(S2Tile *)tile;

//Value of the tile with specific power of 2
- (NSInteger)valueForPower:(NSInteger)power;

//Run and then remove pending actions
- (void)commitPendingAcitons;

//Move specific tile ro destination cell
- (void)moveToCell:(S2Cell *)cell;

//Remove current tile from cell with optional animation
- (void)removeAnimated:(BOOL)animated;

//Save current status when user quits game
- (void)encodeWithCoder:(NSCoder *)aCoder;

//Load tile status when game starts
- (instancetype)initWithCoder:(NSCoder *)aDecoder;


@end
