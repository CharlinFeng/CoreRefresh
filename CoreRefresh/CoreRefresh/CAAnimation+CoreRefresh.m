//
//  CAAnimation+CoreRefresh.m
//  CoreListMVC
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CAAnimation+CoreRefresh.h"

@implementation CAAnimation (CoreRefresh)

#define kDegreeToRadian(x) (M_PI/180.0 * (x))

/**
 *  生成一个翻转动画
 */
+(CABasicAnimation *)rotationAnim{
    
    CABasicAnimation *anim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //起点
    anim.fromValue = @(0);
    
    //终点
    anim.toValue=@(kDegreeToRadian(-360));
    
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



/**
 *  旋转动画
 */
+(CABasicAnimation *)rotaAnim{
    
        
    CABasicAnimation *anim=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    //设置起点
    anim.fromValue=0;
    
    //设置终点
    anim.toValue=@(kDegreeToRadian(360.0f));
    
    //设置动画执行一次的时长
    anim.duration=.8f;
    
    //设置速度函数
    anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //完成动画不删除：
    anim.removedOnCompletion=NO;
    
    //向前填充
    anim.fillMode=kCAFillModeForwards;
    
    //设置重复次数
    anim.repeatCount=MAXFLOAT;


    return anim;
}


/**
 *  抖动
 */
+(CAKeyframeAnimation *)shakeAnim{
    
    CAKeyframeAnimation *kfa=[CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    //值
    kfa.values=@[@0.1f,@(0),@(-0.1f),@(0),@0.1f,@(0),@(-0.1f)];
    
    //设置时间
    kfa.duration=0.15f;
    
    //是否重复
    kfa.repeatCount=6.0f;
    
    //是否反转
    kfa.autoreverses=YES;
    
    //完成移除
    kfa.removedOnCompletion=YES;
    
    return kfa;
}

@end
