//
//  CoreHeaderView.m
//  CoreRefresh
//
//  Created by muxi on 15/1/19.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreHeaderView.h"
#import "UIScrollView+MJExtension.h"
#import "UIView+MJExtension.h"
#import "CoreRefreshConst.h"
#import "CoreHeaderShowView.h"
#import "CAAnimation+CoreRefresh.h"
#import <objc/message.h>

CGFloat const deltaValue=40.0f;



@interface CoreHeaderView ()



@property (strong, nonatomic) IBOutlet CoreHeaderShowView *showView;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageV;


@property (strong, nonatomic) IBOutlet UILabel *messageLabel;                                           //messageLabel


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *showVWConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconImageVMarginConstraint;


/**
 *  主要修复ScrollView的contentSize重复调用的问题。
 */
@property (nonatomic,assign) CGSize scrollViewContentSize;

@end






@implementation CoreHeaderView


+(instancetype)header{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}



-(void)awakeFromNib{
    
    [super awakeFromNib];
    

    
    //子控件处理
    [self subViewHandle];
}


#pragma mark  子控件处理
-(void)subViewHandle{
    
    CGFloat showVR=self.showVWConstraint.constant *.5f;
    CGFloat iconImageVR=showVR-self.iconImageVMarginConstraint.constant;
    
    //圆角处理
    //showView
    self.showView.layer.cornerRadius=showVR;
    //iconImageV
    self.iconImageV.layer.cornerRadius=iconImageVR;
}


-(void)didMoveToSuperview{
    
    [super didMoveToSuperview];

    [self adjustFrameWithContentSize];
}




#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互就直接返回
    if (self.alpha <= 0.01 || self.hidden) return;
    
    // 如果正在刷新，直接返回
    if (self.state == CoreHeaderViewRefreshStateRefreshing ) return;
    
    if ([CoreRefreshContentOffset isEqualToString:keyPath]) {
        
        // 如果正在刷新，直接返回
        if (self.state == CoreHeaderViewRefreshStateRefreshing) return;
        
        // 调整状态
        [self adjustStateWithContentOffset];
    }else if([CoreRefreshContentSize isEqualToString:keyPath]){
        
        self.scrollViewContentSize=self.scrollView.contentSize;
    }
}


-(void)adjustFrameWithContentSize{
    if(self.superview){
        //设置状态
        self.state=CoreHeaderViewRefreshStateNorMal;

        CGFloat h=120;
        CGFloat y=-120;
        CGFloat w=self.scrollView.mj_contentSizeWidth;
        CGRect frame=CGRectMake(0,y,w,h);
        self.frame=frame;
    }
}



/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    
    // 当前的contentOffset
    CGFloat offsetY=self.scrollView.mj_contentOffsetY+self.scrollView.contentInset.top;

    //向上滚动直接返回
    if(offsetY>0) return;
    
    CGFloat currentOffsetY = ABS(offsetY);
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = CoreRefreshHeaderViewH;

    //进度条处理
    [self progressSetWithCurrentOffsetY:currentOffsetY happenOffsetY:happenOffsetY];
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        if (self.state == CoreHeaderViewRefreshStateNorMal && currentOffsetY >= happenOffsetY) {
            
            // 转为即将刷新状态
            self.state = CoreHeaderViewRefreshStateReleaseForRefreshing;
        } else if (self.state == CoreHeaderViewRefreshStateReleaseForRefreshing && currentOffsetY < happenOffsetY) {
            
            // 转为普通状态
            self.state = CoreHeaderViewRefreshStateNorMal;
        }
    } else if (self.state == CoreHeaderViewRefreshStateReleaseForRefreshing) {// 即将刷新 && 手松开
       
        // 开始刷新
        self.state = CoreHeaderViewRefreshStateRefreshing;
    }
}


#pragma mark  进度条处理
-(void)progressSetWithCurrentOffsetY:(CGFloat)currentOffsetY happenOffsetY:(CGFloat)happenOffsetY{
    if(currentOffsetY<=happenOffsetY){
        CGFloat deltaY=deltaValue;
        CGFloat nowY=currentOffsetY-deltaY;
        self.showView.progress=.00001f;
        if(nowY<=0) return;
        
        //计算进度
        CGFloat progress=nowY/(happenOffsetY-deltaY);
        
        //异常处理
        if(progress<=0) progress=0.f;
        if(progress>=1) progress=1.f;
        
        
        self.showView.progress=progress;
    }else{
        self.showView.progress=1.0f;
    }

    
}





-(void)setState:(CoreHeaderViewRefreshState)state{
    
    // 1.一样的就直接返回
    if (_state == state) return;

    CoreHeaderViewRefreshState oldState=_state;
    
    //记录
    _state=state;
    
    switch (state) {
            
        case CoreHeaderViewRefreshStateNorMal://非刷新中状态->普通状态
            if(oldState!=CoreHeaderViewRefreshStateRefreshing) [self stateNorMal];
            break;
            
        case CoreHeaderViewRefreshStateReleaseForRefreshing://普通状态->松手立即刷新
            if(oldState==CoreHeaderViewRefreshStateNorMal) [self stateReleaseForRefreshing];
            break;
            
        case CoreHeaderViewRefreshStateRefreshing://松手立即刷新->刷新中,特别的在业务中直接从普通状态->刷新中
            if(oldState==CoreHeaderViewRefreshStateReleaseForRefreshing || oldState==CoreHeaderViewRefreshStateNorMal) [self stateRefreshing];
            break;
            
        case CoreHeaderViewRefreshStateRefreshingFailed://刷新中->刷新失败
            if(oldState==CoreHeaderViewRefreshStateRefreshing) [self stateRefreshingFailed];
            break;
            
        case CoreHeaderViewRefreshStateSuccessedResultNoMoreData://刷新中->刷新成功，无更多数据
            if(oldState==CoreHeaderViewRefreshStateRefreshing) [self stateSuccessedResultNoMoreData];
            break;
            
        case CoreHeaderViewRefreshStateSuccessedResultDataShowing://刷新中->刷新成功，数据展示中
            if(oldState==CoreHeaderViewRefreshStateRefreshing) [self stateSuccessedResultDataShowing];
            break;
            
        default:
            break;
    }
}


/**
 *  刷新过程
 */
#pragma mark  普通状态
-(void)stateNorMal{
    
    //更新界面
    [self updateInterFaceForStatusWithMessage:@"继续向下拉动"];
    
    //通知showView开始刷新
    self.showView.refreshing=NO;
}

#pragma mark  松手立即刷新
-(void)stateReleaseForRefreshing{
    
    [self updateInterFaceForStatusWithMessage:@"松手立即刷新"];
    
    //通知showView开始刷新
//    self.showView.refreshing=NO;
}

#pragma mark  刷新中
-(void)stateRefreshing{

    // 执行动画
    [UIView animateWithDuration:.25f animations:^{
        
        //动画曲线
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        // 1.增加滚动区域
        CGFloat top = self.scrollView.contentInset.top + CoreRefreshHeaderViewH;
        self.scrollView.mj_contentInsetTop = top;
        
        // 2.设置滚动位置
        self.scrollView.mj_contentOffsetY = - top;
    } completion:^(BOOL finished) {
        //更新界面
        [self updateInterFaceForStatusWithMessage:@"正在刷新中"];
        
        //通知showView开始刷新
        self.showView.refreshing=YES;
        
        //回调方法
        [self beginRefreshing];
    }];


}




/**
 *  刷新结果
 */
#pragma mark  刷新失败
-(void)stateRefreshingFailed{
    
    [self updateInterFaceForStatusWithMessage:@"刷新失败"];
    
    //添加动画
    [self.iconImageV.layer addAnimation:[CAAnimation shakeAnim] forKey:@"shakeAnim"];
    
    //回调方法
    [self endRefreshing:NO];

}

#pragma mark  刷新成功，无更多数据
-(void)stateSuccessedResultNoMoreData{
    
    [self updateInterFaceForStatusWithMessage:@"没有新数据"];
    
    //添加动画
    [self.iconImageV.layer addAnimation:[CAAnimation shakeAnim] forKey:@"shakeAnim"];
    
    //回调方法
    [self endRefreshing:NO];

}

#pragma mark  刷新成功，数据展示中
-(void)stateSuccessedResultDataShowing{
    
    [self updateInterFaceForStatusWithMessage:@"刷新成功"];
    
    [self.iconImageV.layer addAnimation:[CAAnimation rotationAnim] forKey:@"rotationAnim"];

    //回调方法
    [self endRefreshing:NO];

}

#pragma mark  不同的状态更新界面
-(void)updateInterFaceForStatusWithMessage:(NSString *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.messageLabel.text=message;
    });
}





#pragma mark 开始刷新
- (void)beginRefreshing
{
    if (self.state == CoreHeaderViewRefreshStateRefreshing) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
            }
        });

    } else {
        
        if (self.window) {
            
            self.state = CoreHeaderViewRefreshStateRefreshing;
            
        } else {
            
            _state = CoreHeaderViewRefreshStateReleaseForRefreshing;
            
            [self setNeedsDisplay];
        }
        
    }
    
}

- (void)endRefreshing:(BOOL)now{

    //通知showView刷新结束
    self.showView.refreshing=NO;
    
    self.showView.progress=1.0f;
    
    CGFloat timeInterVal=now?.01:1.f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterVal * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //执行动画
        [UIView animateWithDuration:.2f animations:^{
            
            //动画曲线
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            
            if (self.scrollViewOriginalInset.top == 0) {
                self.scrollView.mj_contentInsetTop = 0;
            } else if (self.scrollViewOriginalInset.top == self.scrollView.mj_contentInsetTop) {
                self.scrollView.mj_contentInsetTop -= self.mj_height;
            } else {
                self.scrollView.mj_contentInsetTop = self.scrollViewOriginalInset.top;
            }
            
        } completion:^(BOOL finished) {
            
            self.state=CoreHeaderViewRefreshStateNorMal;
 
        }];

    });

}



- (void)removeHeader{
    
    [self endRefreshing:YES];
    
    [self removeFromSuperview];
}


-(void)setScrollViewContentSize:(CGSize)scrollViewContentSize{
    
    if(CGSizeEqualToSize(_scrollViewContentSize, scrollViewContentSize)) return;
    
    _scrollViewContentSize=scrollViewContentSize;
    
    //在这里再调整frame
    [self adjustFrameWithContentSize];
}


@end
