//
//  S2Appearance.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2Appearance.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation S2Appearance

+ (NSInteger)horizontalOffset
{
    CGFloat width = DIMENSION * (TILE_SIZE + BOARDER_WIDTH) + BOARDER_WIDTH;
    return ([[UIScreen mainScreen] bounds].size.width - width
            ) / 2;
}

+ (NSInteger)verticalOffset
{
    CGFloat height = DIMENSION * (TILE_SIZE + BOARDER_WIDTH) + BOARDER_WIDTH;
    return ([[UIScreen mainScreen] bounds].size.height - height) / 2 - 60;
}

+ (UIColor *)colorForPower:(NSInteger)power
{
    switch (power) {
        case 1:
            return RGB(238, 228, 218);
        case 2:
            return RGB(237, 224, 200);
        case 3:
            return RGB(242, 177, 121);
        case 4:
            return RGB(245, 149, 99);
        case 5:
            return RGB(246, 124, 95);
        case 6:
            return RGB(246, 94, 59);
        case 7:
            return RGB(237, 207, 114);
        case 8:
            return RGB(237, 204, 97);
        case 9:
            return RGB(237, 200, 80);
        case 10:
            return RGB(237, 197, 63);
        case 11:
            return RGB(237, 194, 46);
        case 12:
            return RGB(173, 183, 119);
        case 13:
            return RGB(170, 183, 102);
        case 14:
            return RGB(164, 183, 79);
        case 15:
        default:
            return RGB(161, 183, 63);
    }
}

+ (UIColor *)textColorForPower:(NSInteger)power
{
    switch (power) {
        case 1:
        case 2:
            return RGB(118, 109, 100);
        default:
            return [UIColor whiteColor];
    }
}

+ (CGFloat)textSizeForValue:(NSInteger)value
{
    if (value < 100) {
        return 32;
    } else if (value < 1000) {
        return 28;
    } else if (value < 10000) {
        return 24;
    } else {
        return 20;
    }
}

+ (UIColor *)backgroundColor
{
    return RGB(250, 248, 239);
}


+ (UIColor *)boardColor
{
    return RGB(204, 192, 179);
}


+ (UIColor *)scoreBoardColor
{
    return RGB(187, 173, 160);
}


+ (UIColor *)buttonColor
{
    return RGB(119, 110, 101);
}

@end
