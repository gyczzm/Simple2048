//
//  ViewController.h
//  SImple2048
//
//  Created by zhuxi on 15/4/10.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>

- (void)updateScore:(NSInteger)score;

- (void)endGame:(BOOL)won;

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe;

- (void)commitTranslation:(CGPoint)translation;

@end

