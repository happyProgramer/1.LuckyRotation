//
//  YPRotaryView.m
//  1.幸运转盘
//
//  Created by 宠爱 on 16/5/9.
//  Copyright © 2016年 iscast. All rights reserved.
//

#import "YPRotaryView.h"
#import "YPButton.h"
@interface YPRotaryView ()

//@property (nonatomic, strong) NSMutableArray *btnsArr;

@property (nonatomic, weak) IBOutlet UIImageView *rotateWheel;


@property (nonatomic, weak) YPButton *selectBtn;

@property (nonatomic, strong) CADisplayLink *link;


@end

@implementation YPRotaryView

+(instancetype)rotary{

    return [[[NSBundle mainBundle] loadNibNamed:@"YPRotaryView" owner:nil options:nil] lastObject];
}


-(IBAction)startBtnCLick{

//停止原定时器刷新
    [self.link invalidate];
    self.link = nil;
    
//    创建基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    设置属性
    
//    设置代理
    anim.delegate = self;
//1.获取按钮偏移的角度
    CGFloat angle = self.selectBtn.tag * M_PI * 2 / 12 ;
    
    anim.toValue = @(M_PI * 2 * 7 - angle);
    anim.duration = 4;
//    因为layer加在按钮身上了，不是单纯的layer，要在动画结束时设置按钮的位置
//    anim.removedOnCompletion = NO;
//    anim.fillMode = kCAFillModeForwards;
    
//    添加动画节奏的属性
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//   添加
    [self.rotateWheel.layer addAnimation:anim forKey:nil];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
//    设置角度
    CGFloat angle =self.selectBtn.tag * M_PI * 2 / 12 ;
//    使被选中的按钮在最上方
    self.rotateWheel.transform = CGAffineTransformMakeRotation(-angle);
    
    
//    给用户提示
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"8,8,8,8" preferredStyle:UIAlertControllerStyleAlert];
    
//    添加按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"接着转");
        
        self.selectBtn.selected = NO;
        
        [self startRotate];
        
    }];
    
//    添加按钮
    [alert addAction:action];
    
//    赋值
    self.alert = alert;
//    展示
    if ([self.delegate respondsToSelector:@selector(goingRotateWithRotatyView:)]) {
        [self.delegate goingRotateWithRotatyView:self];
    }
    
}





//开始转动
-(void)startRotate{
    //创建定时器
    CADisplayLink *start = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotate)];
    
    //添加到运行循环中
    [start addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    //  赋值
    self.link = start;
}

//实现方法
-(void)rotate{
    
    self.rotateWheel.transform = CGAffineTransformRotate(self.rotateWheel.transform, M_PI_4 * 0.01);
    
}

#pragma mark - 添加按钮
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self settingUI];
//    }
//    return self;
//}


-(void)awakeFromNib{

    [self settingUI];
}


//搭建界面
-(void)settingUI{

//for循环创建按钮
    for (NSInteger i = 0; i < 12; i++) {
        //1. 创建按钮
        YPButton *btn = [YPButton buttonWithType:UIButtonTypeCustom];
        
                btn.adjustsImageWhenHighlighted = NO;
        
        //2. 设置按钮在选中状态的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        //2.1 给按钮添加星座图片
        
        [btn setImage:[self creatImageWithOriginalImg:@"LuckyAstrology" AndIdx:i] forState:UIControlStateNormal];
        
        [btn setImage:[self creatImageWithOriginalImg:@"LuckyAstrologyPressed" AndIdx:i] forState:UIControlStateSelected];
        
        //3.添加
        [self.rotateWheel addSubview:btn];
        
        //4.添加点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }


}

-(void)layoutSubviews{
[self.rotateWheel.subviews enumerateObjectsUsingBlock:^(__kindof YPButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //1.1 设置大小
    obj.bounds = CGRectMake(0, 0, 68, 143);
    // 设置中心点
//    obj.center = self.center;找的是view的中心点，中心点在主视图上获取的值是
    obj.center = self.rotateWheel.center;
    // 设置锚点
    obj.layer.anchorPoint = CGPointMake(0.5, 1);
    
    //设置按钮标识
    obj.tag = idx;
    
    // 设置transform
    CGFloat angle = M_PI * 2 / 12;
    //散开
    obj.transform = CGAffineTransformMakeRotation( angle * idx);

}];










}

//实现监听方法
-(void)btnClick:(YPButton *)sender{
    
    self.selectBtn.selected = NO;
    
    sender.selected = YES;
    
    self.selectBtn = sender;
    
}
-(UIImage *)creatImageWithOriginalImg:(NSString *)image AndIdx:(NSInteger) idx{
    //2.1.1 获取图片
    UIImage *originalImg = [UIImage imageNamed:image];
    
    //2.1.2 计算剪切区域
    CGFloat width = originalImg.size.width / 12;
    CGFloat height = originalImg.size.height;
    CGFloat X = width * idx;
    CGFloat Y = 0;
    
    //获取当前屏幕的缩放因子，实现像素转换，将点坐标转换为像素
    CGFloat scale = [UIScreen mainScreen].scale;
    
    width *= scale;
    height *= scale;
    X *= scale;
    Y *=scale;
    
    CGRect rect =  CGRectMake(X, Y, width, height);
    
    //2.1.3 获取剪切后的图片
    CGImageRef img = CGImageCreateWithImageInRect(originalImg.CGImage, rect);
    
    //2.2 添加图片
    UIImage *clipImg = [UIImage imageWithCGImage:img];
     // 2.3释放资源
    CGImageRelease(img);
    
    return clipImg;

}
@end
