//
//  YPButton.m
//  1.幸运转盘
//
//  Created by 宠爱 on 16/5/9.
//  Copyright © 2016年 iscast. All rights reserved.
//

#import "YPButton.h"

@implementation YPButton


/**
 *  作用:调整按钮身上图片的尺寸信息
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat btnW = 40;
    CGFloat btnH = 46;
    CGFloat btnX = (contentRect.size.width - btnW)/2;
    CGFloat btnY = 20;
   

    return CGRectMake(btnX, btnY, btnW, btnH);
}

@end
