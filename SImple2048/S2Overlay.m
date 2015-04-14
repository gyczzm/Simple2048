//
//  S2Overlay.m
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "S2Overlay.h"
#import "S2Appearance.h"

@implementation S2Overlay

- (void)loadAppearance
{
    self.message.font = [UIFont fontWithName:BOLD_FONT_NAME size:40];
    self.message.textColor = [S2Appearance buttonColor];
    
    self.keepPlaying.layer.cornerRadius = CORNER_RADIUS;
    self.keepPlaying.layer.masksToBounds = YES;
    self.keepPlaying.backgroundColor = [S2Appearance buttonColor];
    self.keepPlaying.titleLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:18];
    
    self.restartGame.layer.cornerRadius = CORNER_RADIUS;
    self.restartGame.layer.masksToBounds = YES;
    self.restartGame.backgroundColor = [S2Appearance buttonColor];
    self.restartGame.titleLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:18];
}

@end
