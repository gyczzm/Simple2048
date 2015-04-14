//
//  S2GamaManeger.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class S2Scene;
@class S2Grid;

typedef NS_ENUM(NSInteger, S2Direction){
    S2DirectionUp,
    S2DirectionLeft,
    S2DirectionDown,
    S2DirectionRight
};

@interface S2GameManager : NSObject

- (void)startNewSessionWithScene:(S2Scene *)scene;

- (void)moveToDirection:(NSInteger)direction;

- (NSMutableArray *)cellsWithTile;

- (NSString *)archivePath;

- (BOOL)saveStatus;

- (void)loadStatus:(NSMutableArray *)keyedUnarchiver onScene:(S2Scene *)scene;


@end
