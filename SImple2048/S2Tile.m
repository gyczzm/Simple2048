//
//  S2Tile.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2Tile.h"
#import "S2Cell.h"
#import "Position.h"
#import "S2Appearance.h"

@implementation S2Tile
{
    SKLabelNode *_value;
    NSMutableArray *_pendingActions;
}

# pragma mark - Tile creation

+ (S2Tile *)insertNewTileToCell:(S2Cell *)cell
{
    S2Tile *tile = [[S2Tile alloc] init];
    
    CGPoint origin =[Position locationOfPosition:cell.position];
    //SpriteKit scale the tile from the origin, not the center.
    //So we have to scale the tile from the center of its cell while moving it
    //back to its normal position to achieve the "pop out" effect.
    tile.position = CGPointMake(origin.x + TILE_SIZE / 2, origin.y + TILE_SIZE / 2);
    [tile setScale:0];
    
    cell.tile = tile;
    return tile;
}

- (instancetype)init
{
    if (self = [super init]) {
        //Layout of the tile
        CGRect rect = CGRectMake(0, 0, TILE_SIZE, TILE_SIZE);
        CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, CORNER_RADIUS, CORNER_RADIUS, NULL);
        self.path = rectPath;
        CFRelease(rectPath);
        self.lineWidth = 0;
        
        //Initiate pending action queue
        _pendingActions = [[NSMutableArray alloc] init];
        
        //Setup value lable
        _value = [SKLabelNode labelNodeWithFontNamed:BOLD_FONT_NAME];
        _value.position = CGPointMake(TILE_SIZE / 2, TILE_SIZE / 2);
        _value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:_value];
        
        //Initiate value label with 2 or,in a low probability,4. Then update value lable
        self.power = arc4random_uniform(100) < 95 ? 1 : 2;
        [self refreshValue];
    }
    return self;
}


# pragma mark - Private methods

//Set up the value label for newly initiated tile
- (void)refreshValue
{
    NSInteger value = [self valueForPower:self.power];
    
    _value.text = [NSString stringWithFormat:@"%d", (int)value];
    _value.fontColor = [S2Appearance textColorForPower:self.power];
    _value.fontSize = [S2Appearance textSizeForValue:value];
    
    self.fillColor = [S2Appearance colorForPower:self.power];
}

//Check if the tile is still registered with its parent cell, and if so, remove it.
- (void)removeFromParentCell
{
    if (self.cell.tile == self) {
        self.cell.tile = nil;
    }
}

//Remove specific tile with delay
- (void)removeWithDelay
{
    [self removeFromParentCell];
    SKAction *wait = [SKAction waitForDuration:ANIMATION_DURATOIN];
    SKAction *remove = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[wait, remove]]];
}

//Check if there are more than one pending actions,which indicates there are pending merge
- (BOOL)hasPendingMerge
{
//    //for test
//    NSLog(@"has pending merge: %d", _pendingActions.count > 1);
    return _pendingActions.count > 1;
}

# pragma mark - Public methods

- (NSInteger)mergeWithTile:(S2Tile *)tile
{
    if (!tile || [tile hasPendingMerge]) return 0;
    
    BOOL canMergeWithTile = self.power == tile.power;
    
    if (canMergeWithTile) {
        NSInteger upgradedPower = self.power + 1;
        
        //Move self to destination cell
        [self moveToCell:tile.cell];
        
        //Remove the tile in destination cell
        [tile removeWithDelay];
        
        //Update value label and pop
        self.power = upgradedPower;
        [_pendingActions addObject:[SKAction runBlock:^{
            [self refreshValue];
        }]];
         [_pendingActions addObject:[self pop]];
//        //for test
//        NSLog(@"merge");
        
        return self.power + 1;
    }
    return 0;
}

- (NSInteger)valueForPower:(NSInteger)power
{
    NSInteger value = 1;
    for (NSInteger i = 0; i < self.power; i++) {
        value *= 2;
    }
    return value;
}

- (void)commitPendingAcitons
{
    [self runAction:[SKAction sequence:_pendingActions]];
    [_pendingActions removeAllObjects];
//    //for test
//    NSLog(@"%ld: removed all actions", (long)[self valueForPower:self.power]);
}

- (void)moveToCell:(S2Cell *)cell
{
    [_pendingActions addObject:[SKAction moveBy:
                                [Position distanceFromPosition:self.cell.position
                                                    toPosition:cell.position] duration:ANIMATION_DURATOIN]];
//    //for test
//    NSLog(@"%ld: add move", (long)[self valueForPower:self.power]);
    self.cell.tile = nil;
    cell.tile = self;
}

- (void)removeAnimated:(BOOL)animated
{
    [self removeFromParentCell];
    if (animated) {
        [_pendingActions addObject:[SKAction scaleTo:0 duration:ANIMATION_DURATOIN]];
    }
    [_pendingActions addObject:[SKAction removeFromParent]];
    [self commitPendingAcitons];
//    //for test
//    NSLog(@"commit remove and cleared all actions");
}

#pragma mark - SKAction helper

- (SKAction *)pop
{
    CGFloat d = 0.15 * TILE_SIZE;
    
    SKAction *wait = [SKAction waitForDuration:ANIMATION_DURATOIN];
    SKAction *enlarge = [SKAction scaleTo:1.3 duration:ANIMATION_DURATOIN / 1.5];
    SKAction *move = [SKAction moveBy:CGVectorMake(- d, - d) duration:ANIMATION_DURATOIN / 1.5];
    SKAction *restore = [SKAction scaleTo:1 duration:ANIMATION_DURATOIN / 1.5];
    SKAction *moveBack = [SKAction moveBy:CGVectorMake(d, d) duration:ANIMATION_DURATOIN / 1.5];
    
    return [SKAction sequence:@[wait, [SKAction group:@[enlarge, move]],
                                      [SKAction group:@[restore, moveBack]]]];
}

#pragma mark - Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.power forKey:@"power"];
    [aCoder encodeCGPoint:self.position forKey:@"position"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        //Initiate the tile,which follows the same steps as designated init method
        CGRect rect = CGRectMake(0, 0, TILE_SIZE, TILE_SIZE);
        CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, CORNER_RADIUS, CORNER_RADIUS, NULL);
        self.path = rectPath;
        CFRelease(rectPath);
        self.lineWidth = 0;
        
        _pendingActions = [[NSMutableArray alloc] init];
        
        _value = [SKLabelNode labelNodeWithFontNamed:BOLD_FONT_NAME];
        _value.position = CGPointMake(TILE_SIZE / 2, TILE_SIZE / 2);
        _value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:_value];
        
        //Initiate value label with archived value
        self.power = [aDecoder decodeIntegerForKey:@"power"];
        [self refreshValue];
        
        //Initiate position
        self.position = [aDecoder decodeCGPointForKey:@"position"];
    }
    return self;
}

@end
