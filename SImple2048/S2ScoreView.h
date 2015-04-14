//
//  S2ScoreView.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S2ScoreView : UIView

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *score;

//Load the appearance of score boards
- (void)loadAppearance;

@end
