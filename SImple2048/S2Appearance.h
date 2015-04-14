//
//  S2Appearance.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface S2Appearance : NSObject

//Some constants that will be used to set up the appearance
#define DIMENSION 4
#define TILE_SIZE 66
#define BOARDER_WIDTH 5
#define CORNER_RADIUS 4
#define ANIMATION_DURATOIN 0.1
#define BOLD_FONT_NAME @"AvenirNext-DemiBold"
#define REGULAR_FONT_NAME @"AvenirNext-Regular"

//Class methods to dertermine location of the grid
+ (NSInteger)horizontalOffset;
+ (NSInteger)verticalOffset;

//Class methods to dertermine the appearance of tiles
+ (UIColor *)colorForPower:(NSInteger)power;
+ (UIColor *)textColorForPower:(NSInteger)power;
+ (CGFloat)textSizeForValue:(NSInteger)value;

+ (UIColor *)backgroundColor;
+ (UIColor *)boardColor;
+ (UIColor *)scoreBoardColor;
+ (UIColor *)buttonColor;

@end
