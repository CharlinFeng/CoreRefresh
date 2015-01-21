//
//  CoreHeaderShowView.m
//  CoreRefresh
//
//  Created by muxi on 15/1/19.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreHeaderShowView.h"
#import "UIView+MJExtension.h"
#define kDegreeToRadian(x) (M_PI/180.0 * (x))

@interface CoreHeaderShowView ()

@property (nonatomic,strong) CABasicAnimation *rotaAnim;

@property (nonatomic,assign) CGFloat centerX,centerY,radius,startAngle;

@end

@implementation CoreHeaderShowView




-(void)drawRect:(CGRect)rect{
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //绘制一个进度
    [self drawProgressArc:context rect:rect];
    
    if(!self.refreshing) return;
    
    [self drawWhiteCircle:context rect:rect];
}


#pragma mark  绘制一个进度
-(void)drawProgressArc:(CGContextRef)context rect:(CGRect)rect{
    
    //新建路径
    CGMutablePathRef progressArcPath=CGPathCreateMutable();
    
    CGFloat endAngle=kDegreeToRadian(_progress * 359.99f)+ kDegreeToRadian(-90);

    //添加一个环形路径
    CGPathAddArc(progressArcPath, NULL, self.centerX, self.centerY, self.radius, self.startAngle, endAngle, NO);
    
    //设置路径属性
    //1.设置颜色
    [[UIColor colorWithRed:.5f green:.5f blue:.5f alpha:.5f] setStroke];
    //2.设置线宽
    CGContextSetLineWidth(context, 2.0f);
    
    //将路径添加到上下文中
    CGContextAddPath(context, progressArcPath);
    
    //渲染路径
    CGContextStrokePath(context);
    
    //释放路径
    CGPathRelease(progressArcPath);
}



#pragma mark  绘制一个白色的圆环
-(void)drawWhiteCircle:(CGContextRef)context rect:(CGRect)rect{
    
    //新建路径
    CGMutablePathRef grayCirclePath=CGPathCreateMutable();
    
    CGFloat startAngle=kDegreeToRadian(-40);
    CGFloat endAngle=kDegreeToRadian(200);
    
    CGPathAddArc(grayCirclePath, NULL,self.centerX, self.centerY, self.radius, startAngle,endAngle,YES);
    
    //将路径添加到上下文
    CGContextAddPath(context, grayCirclePath);
    
    //路径设置
    //1.颜色
    [[UIColor whiteColor] setStroke];
    //2.线宽
    CGContextSetLineWidth(context, 2.0f);
    
    
    //渲染路径
    CGContextStrokePath(context);
    
    //释放路径
    CGPathRelease(grayCirclePath);
}





-(void)setProgress:(CGFloat)progress{
    
    if(_progress==progress) return;
    
    //异常处理
    if(progress<=0) progress=0;
    if(progress>=1.0f) progress=1.0f;

    //记录
    _progress=progress;
    
    //重绘
    [self setNeedsDisplay];
}


-(void)setRefreshing:(BOOL)refreshing{
    
    //记录
    _refreshing=refreshing;
    
    
    
    //响应是否刷新中这个状态
    if(refreshing){
        [self refreshWithYes];
    }else{
        [self refreshWithNO];
    }
    
    //重绘
    [self setNeedsDisplay];
}






#pragma mark  正在刷新中
-(void)refreshWithYes{

    //强制进度
    self.progress=1.0f;
    
    //在iconImageV添加动画
    [self.layer addAnimation:self.rotaAnim forKey:@"rotaAnim"];
    
}



#pragma mark  没有在刷新
-(void)refreshWithNO{
    
    //强制进度
    self.progress=.001f;
    
    [self.layer removeAllAnimations];
}


-(CABasicAnimation *)rotaAnim{
    
    if(!_rotaAnim){
        
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

        _rotaAnim=anim;
    }
    
    
    return _rotaAnim;
}


#pragma mark  get方法区
-(CGFloat)centerX{
    
    if(!_centerX){
        _centerX=self.mj_width *.5f;
    }
    
    return _centerX;
}

-(CGFloat)centerY{
    
    if(!_centerY){
        
        _centerY=self.mj_height *.5f;
    }
    
    return _centerY;
}

-(CGFloat)radius{
    
    if(!_radius){
        _radius=MIN(self.centerX, self.centerY);
    }
    
    return _radius;
}

-(CGFloat)startAngle{
    
    if(!_startAngle){
        _startAngle=kDegreeToRadian(270.0f);
    }
    
    return _startAngle;
}


@end
