//
//  S2GridView.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class S2Grid;

@interface S2GridView : UIView

//Create the entire background of the view with the grid at the correct position.
+ (UIImage *)gridImageWithGrid:(S2Grid *)grid;

//Create the entire background of the view with a translucent overlay on the grid.
+ (UIImage *)gridImageWithOverlay;

@end
