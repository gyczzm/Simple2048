//
//  S2ScoreView.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2ScoreView.h"
#import "S2Appearance.h"

@implementation S2ScoreView

- (void)loadAppearance
{
    self.layer.cornerRadius = CORNER_RADIUS;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [S2Appearance scoreBoardColor];
    
    self.title.font = [UIFont fontWithName:BOLD_FONT_NAME size:15];
    self.score.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
}

@end
