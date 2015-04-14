//
//  S2Scene.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class S2Grid;
@class ViewController;

@interface S2Scene : SKScene

//Delegate of the scene
@property (nonatomic, weak) ViewController *delegate;

//Generate the board on which grid is placed
- (void)loadBoardWithGrid:(S2Grid *)grid;

@end
