//
//  S2GameManager.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2GameManager.h"
#import "S2Grid.h"
#import "S2Scene.h"
#import "S2Tile.h"
#import "ViewController.h"
#import "S2Appearance.h"

#define WINNING_POWER 11
#define Settings [NSUserDefaults standardUserDefaults]
#define currentScore @"Current Score"

BOOL iterate(NSInteger value, BOOL countUp, NSInteger upper, NSInteger lower) {
    return countUp ? value < upper : value > lower;
}

@implementation S2GameManager
{
    //True if game over
    BOOL _over;
    
    //True if won game
    BOOL _won;
    
    //True if user chooses to keep playing after winning
    BOOL _keepPlaying;
    
    //The current score
    NSInteger _score;
    
    //The points earned by the user in the current round
    NSInteger _pendingScore;
    
    //The grid on which everything happens
    S2Grid *_maingrid;
}

- (void)startNewSessionWithScene:(S2Scene *)scene
{
    if (_maingrid) {
        [_maingrid removeAllTilesAnimated:YES];
    }else {
        _maingrid = [[S2Grid alloc] init];
        _maingrid.scene = scene;
    }

    [scene loadBoardWithGrid:_maingrid];
    
    // Set the initial state for the game.
    _score = 0; _over = NO; _won = NO; _keepPlaying = NO;
    
    // Add two tiles to the grid to start with.
    [_maingrid insertTileAtRandomAvailableCell:NO];
    [_maingrid insertTileAtRandomAvailableCell:NO];
}

- (void)moveToDirection:(NSInteger)direction
{
    __block S2Tile *tile = nil;
    
    // Remember that the coordinate system of SpriteKit is the reverse of that of UIKit.
    BOOL reverse = direction == S2DirectionUp || direction == S2DirectionRight;
    NSInteger unit = reverse ? 1 : -1;
    
    if (direction == S2DirectionUp || direction == S2DirectionDown) {
        [_maingrid forEach:^(S2Position position) {
            if ((tile = [_maingrid tileAtPosition:position])) {
                // Find farthest position to move to.
                NSInteger target = position.y;
                for (NSInteger i = position.y + unit; iterate(i, reverse, DIMENSION, -1); i += unit) {
                    S2Tile *t = [_maingrid tileAtPosition:S2PositionMake(position.x, i)];
                    
                    // Empty cell; we can move at least to here.
                    if (!t) target = i;
                    
                    // Try to merge to the tile in the cell.
                    else {
                        NSInteger power = 0;
                        
                        power = [tile mergeWithTile:t];
                        
                        if (power) {
                            target = position.y;
                            _pendingScore = [tile valueForPower:power];
                        }
                        
                        break;
                    }
                }
                
                // The current tile is movable.
                if (target != position.y) {
                    [tile moveToCell:[_maingrid cellAtPosition:S2PositionMake(position.x, target)]];
                    _pendingScore++;
                }
            }
        } inReverseOrder:reverse];
    }
    
    else {
        [_maingrid forEach:^(S2Position position) {
            if ((tile = [_maingrid tileAtPosition:position])) {
                NSInteger target = position.x;
                for (NSInteger i = position.x + unit; iterate(i, reverse, DIMENSION, -1); i += unit) {
                    S2Tile *t = [_maingrid tileAtPosition:S2PositionMake(i, position.y)];
                    
                    // Empty cell; we can move at least to here.
                    if (!t) target = i;
                    
                    // Try to merge to the tile in the cell.
                    else {
                        NSInteger power = 0;
                        
                        power = [tile mergeWithTile:t];
                        
                        if (power) {
                            target = position.x;
                            _pendingScore = [tile valueForPower:power];
                        }
                        
                        break;
                    }
                }
                
                // The current tile is movable.
                if (target != position.x) {
                    [tile moveToCell:[_maingrid cellAtPosition:S2PositionMake(target, position.y)]];
                    _pendingScore++;
                }
            }
        } inReverseOrder:reverse];
    }
    
    // Cannot move to the given direction. Abort.
    if (!_pendingScore) return;
    
    // Commit tile movements.
    [_maingrid forEach:^(S2Position position) {
        S2Tile *tile = [_maingrid tileAtPosition:position];
        if (tile) {
            [tile commitPendingAcitons];
            if (tile.power >= WINNING_POWER) _won = YES;
        }
    } inReverseOrder:reverse];
    
    // Increment score.
    [self addPendingScore];
    
    // Check post-move status.
    if (!_keepPlaying && _won) {
        // We set `keepPlaying` to YES. If the user decides not to keep playing,
        // we will be starting a new game, so the current state is no longer relevant.
        _keepPlaying = YES;
        [_maingrid.scene.delegate endGame:YES];
    }
    
    // Add one more tile to the grid.
    [_maingrid insertTileAtRandomAvailableCell:YES];
    if (![self movesAvailable]) {
        [_maingrid.scene.delegate endGame:NO];
    }
}

#pragma mark - Score

- (void)addPendingScore
{
    _score += _pendingScore;
    _pendingScore = 0;
    [_maingrid.scene.delegate updateScore:_score];
}

#pragma mark - Status checkers

- (BOOL)movesAvailable
{
    //Checking for adjacent matches is more expensive,so we should first check if there are available cells
    return [_maingrid hasAvailableCells] || [self adjacentMatchesAvailable];
}

- (BOOL)adjacentMatchesAvailable
{
    for (NSInteger i = 0; i < DIMENSION; i++)
    {
        for (NSInteger j = 0; j < DIMENSION; j++)
        {
            S2Tile *tile = [_maingrid tileAtPosition:S2PositionMake(i, j)];
            S2Tile *lowerTile = [_maingrid tileAtPosition:S2PositionMake(i, j + 1)];
            S2Tile *rightTile = [_maingrid tileAtPosition:S2PositionMake(i + 1, j)];
            
            if (tile.power == lowerTile.power || tile.power == rightTile.power)
            return YES;
        }
    }
    return NO;
}

#pragma mark - Archiving

- (NSMutableArray *)cellsWithTile
{
    NSMutableArray *cellsWithTile = [[NSMutableArray alloc] init];
    
    if (_over) {
        //If user quits when game over,clear status
        cellsWithTile = nil;
    } else {
        [_maingrid forEach:^(S2Position position) {
            S2Cell *cell = [_maingrid cellAtPosition:position];
            
            if (cell.tile) {
                [cellsWithTile addObject:cell];
            }
        } inReverseOrder:NO];
    }
    
    return cellsWithTile;
}

- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"cellsWithTile.archive"];
}

- (BOOL)saveStatus
{
    NSString *path = [self archivePath];
    
    [Settings setInteger:_score forKey:currentScore];
    
    return [NSKeyedArchiver archiveRootObject:[self cellsWithTile] toFile:path];
}

- (void)loadStatus:(NSMutableArray *)keyedUnarchiver onScene:(S2Scene *)scene
{
    _maingrid = [[S2Grid alloc] init];
    _maingrid.scene = scene;

    [scene loadBoardWithGrid:_maingrid];
    
    for (S2Cell *cellWithTile in keyedUnarchiver) {
        [_maingrid cellAtPosition:S2PositionMake(cellWithTile.position.x, cellWithTile.position.y)].tile = cellWithTile.tile;
        [scene addChild:[_maingrid cellAtPosition:S2PositionMake(cellWithTile.position.x, cellWithTile.position.y)].tile];
    }
    
    [_maingrid forEach:^(S2Position position) {
        if ([_maingrid cellAtPosition:position]) {
        }
    } inReverseOrder:NO];
}


@end
