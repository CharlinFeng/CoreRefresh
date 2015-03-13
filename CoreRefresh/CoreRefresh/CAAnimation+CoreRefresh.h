//
//  CAAnimation+CoreRefresh.h
//  CoreListMVC
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//  动画生成分类

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CoreRefresh)



/**
 *  生成一个翻转动画
 */
+(CABasicAnimation *)rotationAnim;



/**
 *  旋转动画
 */
+(CABasicAnimation *)rotaAnim;



/**
 *  抖动
 */
+(CAKeyframeAnimation *)shakeAnim;


@end
