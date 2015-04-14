//
//  S2Overlay.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S2Overlay : UIView

@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UIButton *keepPlaying;
@property (nonatomic, weak) IBOutlet UIButton *restartGame;

//Load the appearance of score boards
- (void)loadAppearance;

@end
