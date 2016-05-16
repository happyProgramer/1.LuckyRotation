//
//  YPRotaryView.h
//  1.幸运转盘
//
//  Created by 宠爱 on 16/5/9.
//  Copyright © 2016年 iscast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPRotaryView;
@protocol YPRotaryViewDelegate <NSObject>

@optional

-(void)goingRotateWithRotatyView:(YPRotaryView *)rotateView;


@end

@interface YPRotaryView : UIView


@property (nonatomic, weak) id<YPRotaryViewDelegate> delegate;

@property (nonatomic, weak) UIAlertController *alert;


+(instancetype)rotary;

-(void)startRotate;
@end
