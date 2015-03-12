//
//  CAAnimation+CoreRefresh.m
//  CoreListMVC
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CAAnimation+CoreRefresh.h"

@implementation CAAnimation (CoreRefresh)



/**
 *  生成一个翻转动画
 */
+(CABasicAnimation *)rotationAnim{
    
    CABasicAnimation *anim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //起点
    anim.fromValue = @(0);
    
    //终点
    anim.toValue=@(M_PI * 2);
    
    //动画时长
    anim.duration=1.f;
    
    //是否反转
    anim.autoreverses=NO;
    
    //是否重复
    anim.repeatCount=.0f;
    
    //动画完成移除
    anim.removedOnCompletion=YES;
    
    return anim;

    
    
}






@end
