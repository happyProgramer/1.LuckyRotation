//
//  ViewController.m
//  1.幸运转盘
//
//  Created by 宠爱 on 16/5/9.
//  Copyright © 2016年 iscast. All rights reserved.
//

#import "ViewController.h"
#import "YPRotaryView.h"

@interface ViewController ()<YPRotaryViewDelegate>

//转盘
@property (nonatomic, weak) YPRotaryView *rotateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //想添加图片为背景
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"LuckyBackground"].CGImage);
    
    //创建轮盘
    YPRotaryView *rotary = [YPRotaryView rotary];
//    //设置中心
//    rotary.center = self.view.center;
//    //设置大小
//    rotary.bounds = CGRectMake(0, 0, 286, 286);
    //添加
    [self.view addSubview:rotary];
    //赋值
    self.rotateView = rotary;
    
    //设置代理
    self.rotateView.delegate = self;
    //转动
    [self.rotateView startRotate];
    
}



#pragma mark - 实现代理方法
-(void)goingRotateWithRotatyView:(YPRotaryView *)rotateView{

    [self presentViewController:self.rotateView.alert animated:YES completion:nil];
    
    

}


-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    //设置中心
    self.rotateView.center = self.view.center;
    //设置大小
    self.rotateView.bounds = CGRectMake(0, 0, 286, 286);
}

//设置状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;


}

@end
