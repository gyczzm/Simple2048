//
//  S2Grid.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2Grid.h"
#import "S2Tile.h"
#import "S2Scene.h"
#import "S2Cell.h"
#import "Position.h"
#import "S2Appearance.h"

#define DIMENSION 4

@implementation S2Grid
{
    //Use a mutableArray to store the grid
    NSMutableArray *_grid;
}

- (instancetype)init
{
    if (self = [super init]) {
        //Setup the grid with empty cells
        _grid = [[NSMutableArray alloc] initWithCapacity:DIMENSION];
        
        for (NSInteger i = 0; i < DIMENSION; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:DIMENSION];
            for (NSInteger j = 0; j < DIMENSION; j++) {
                [array addObject:[[S2Cell alloc] initWithPosition:S2PositionMake(i, j)]];
            }
            [_grid addObject:array];
        }
    }
    
    return self;
}

//Go through each position and execute the block
- (void)forEach:(IteratorBlock)block inReverseOrder:(BOOL)reverse
{
    if (!reverse) {
        for (NSInteger i = 0; i < DIMENSION; i++) {
            for (NSInteger j = 0; j < DIMENSION; j++) {
                block(S2PositionMake(i, j));
            }
        }
    }else {
        for (NSInteger i = DIMENSION - 1; i >= 0; i--) {
            for (NSInteger j = DIMENSION - 1; j >= 0; j--) {
                block(S2PositionMake(i, j));
            }
        }
    }
}

#pragma mark - Position helpers

//Returns the cell at specific position
- (S2Cell *)cellAtPosition:(S2Position)position
{
    if (position.x >= DIMENSION || position.y >= DIMENSION || position.x < 0 || position.y < 0) {
        return nil;
    }
    return [[_grid objectAtIndex:position.x] objectAtIndex:position.y];
}

//Returns the tile at specific position
- (S2Tile *)tileAtPosition:(S2Position)position
{
    S2Cell *cell = [self cellAtPosition:position];
    return cell ? cell.tile : nil;
}

#pragma mark- Cell availability

//Return all available cells
- (NSMutableArray *)availableCells
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:DIMENSION*DIMENSION];
    [self forEach:^(S2Position position){
        S2Cell *cell = [self cellAtPosition:position];
        if (!cell.tile) {
            [array addObject:cell];
        }
    }inReverseOrder:NO];
    
    return array;
}

- (BOOL)hasAvailableCells

{
    return [[self availableCells] count] != 0;
}

- (S2Cell *)randomAvailableCell
{
    NSArray *array = [self availableCells];
    if ([self hasAvailableCells]) {
        return [array objectAtIndex:arc4random_uniform((int)array.count)];
    }
    return nil;
}

#pragma mark - Cell manipulation

- (void)insertTileAtRandomAvailableCell:(BOOL)delay
{
    S2Cell *cell = [self randomAvailableCell];
    
    if (cell) {
        S2Tile *tile = [S2Tile insertNewTileToCell:cell];
        [self.scene addChild:tile];
        
        SKAction *delayAction = delay ? [SKAction waitForDuration:ANIMATION_DURATOIN * 3] : [SKAction waitForDuration:0];
        SKAction *moveAction = [SKAction moveBy:CGVectorMake(- TILE_SIZE / 2, - TILE_SIZE / 2) duration:ANIMATION_DURATOIN];
        SKAction *scaleAction = [SKAction scaleTo:1 duration:ANIMATION_DURATOIN];
        
        [tile runAction:[SKAction sequence: @[delayAction, [SKAction group:@[moveAction, scaleAction]]]]];
    }
}

- (void)removeAllTilesAnimated:(BOOL)animated
{
    [self forEach:^(S2Position position){
        S2Tile *tile = [self tileAtPosition:position];
        if (tile) {
            [tile removeAnimated:animated];
        }
    } inReverseOrder:NO];
}

@end
