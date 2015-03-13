//
//  CoreFooterView.m
//  CoreRefresh
//
//  Created by 沐汐 on 15-1-18.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//



#import "CoreFooterView.h"
#import "UIScrollView+MJExtension.h"
#import "UIView+MJExtension.h"
#import "CoreRefreshConst.h"
#import <objc/message.h>





@interface CoreFooterView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiView;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginHConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end



@implementation CoreFooterView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //添加阴影
    [self shadowAdd];
    
}

#pragma mark 添加阴影
-(void)shadowAdd{
    
    //取出layer
    CALayer *layer=self.contentView.layer;
    
    //边框线宽
    layer.borderWidth=0.5f;
    //颜色
    layer.borderColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f].CGColor;
    //圆角
    layer.cornerRadius=10.0f;
    
}



+(instancetype)footer{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}



-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    if(self.superview){
        //设置初始状态
        self.state=CoreFooterViewRefreshStateNormalForContinueDragUp;
        
        //调整scrollView的contentInset，给底部刷新控件留下位置
        [self adjustScrollViewContentInset];
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }
}



#pragma mark 调整scrollView的contentInset，给底部刷新控件留下位置
-(void)adjustScrollViewContentInset{
    
    //原本的bottom值
    CGFloat bottom=self.scrollViewOriginalInset.bottom;
    
    self.scrollView.mj_contentInsetBottom=bottom+CoreRefreshFooterViewH;
}


#pragma mark 重写调整frame
- (void)adjustFrameWithContentSize
{
    //原本的bottom值
    CGFloat bottom=self.scrollViewOriginalInset.bottom;
    // 内容的高度
    CGFloat contentHeight = self.scrollView.mj_contentSizeHeight;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.mj_height - self.scrollViewOriginalInset.top - bottom;
    // 设置位置和尺寸
    CGFloat y = MAX(contentHeight, scrollHeight)+bottom;
    CGFloat h=CoreRefreshFooterViewH;
    CGFloat w=self.scrollView.mj_width;
    CGRect frame=CGRectMake(0, y, w, h);
    self.frame=frame;
}



-(void)setState:(CoreFooterViewRefreshState)state{
    
    if(_state==state) return;
    
    //记录
    _state=state;
    
    switch (state) {
            
        case CoreFooterViewRefreshStateNormalForContinueDragUp://正常
            [self stateNormalForContinueDragUp];
            break;
            
        case CoreFooterViewRefreshStateRefreshing://刷新中
            [self stateRefreshing];
            break;
            
        case CoreFooterViewRefreshStateFailed://刷新失败
            [self stateFailed];
            break;
            
        case CoreFooterViewRefreshStateSuccessedResultNoMoreData://刷新正常结束：无更多数据
            [self stateSuccessedResultNoMoreData];
            break;
            
        case CoreFooterViewRefreshStateSuccessedResultDataShowing://刷新正常结束，数据正在展示中
            [self stateSuccessedResultDataShowing];
            break;
            
        default:
            break;
    }
    
}




#pragma mark 这就是最普通的状态，并且普通状态是请继续拉动
-(void)stateNormalForContinueDragUp{
    [self configINterfaceWithShowAIView:NO constant:0.0f text:@"请继续向上滑动"];
}

#pragma mark 刷新中
-(void)stateRefreshing{
    [self configINterfaceWithShowAIView:YES constant:-10.0f text:@"正在载入数据"];
}

#pragma mark 刷新失败
-(void)stateFailed{
    [self configINterfaceWithShowAIView:NO constant:0 text:@"网络连接失败"];
}

#pragma mark 刷新成功->无更多数据:数据量小于pagesize的都进入这个状态
-(void)stateSuccessedResultNoMoreData{
    [self configINterfaceWithShowAIView:NO constant:0 text:@"数据已全部加载"];
}

#pragma mark 数据正在展示中
-(void)stateSuccessedResultDataShowing{
    [self configINterfaceWithShowAIView:NO constant:0 text:@"数据正在展示中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state=CoreFooterViewRefreshStateNormalForContinueDragUp;
    });
}


-(void)configINterfaceWithShowAIView:(BOOL)showAIView constant:(CGFloat)constant text:(NSString *)text{
    
    //旋转
    if(showAIView){
        [self.aiView startAnimating];
    }else{
        [self.aiView stopAnimating];
    }
    
    //约束
    self.marginHConstraint.constant=constant;
    
    //提示类文字
    self.messageLabel.text=text;
}


#pragma mark 监听scrollView
#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不可见，直接返回
    if (self.alpha <= 0.01 || self.hidden) return;
    
    if ([CoreRefreshContentSize isEqualToString:keyPath]) {
        // 调整frame
        [self adjustFrameWithContentSize];
    } else if ([CoreRefreshContentOffset isEqualToString:keyPath]) {
        
        // 如果正在刷新，直接返回
        if (self.state == CoreFooterViewRefreshStateRefreshing) return;
        
        // 调整状态
        [self adjustStateWithContentOffset];
    }
}


/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    //如果明确知道加载出错或已经没有更多数据，直接返回
    //此代码放在这里性能更好，避免无效计算
    if(self.state==CoreFooterViewRefreshStateSuccessedResultNoMoreData) return;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mj_contentOffsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    
    // 如果是向下滚动到看不见尾部控件，设置状态并直接返回
    if (currentOffsetY <= happenOffsetY){
        if(self.state==CoreFooterViewRefreshStateFailed && currentOffsetY + CoreRefreshFooterViewH <= happenOffsetY){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.state=CoreFooterViewRefreshStateNormalForContinueDragUp;
            });
        }
        return;
    }
    
    //给一个机会让上面失败的状态转为普通状态
    if(self.state==CoreFooterViewRefreshStateFailed) return;
    
    if(!self.scrollView.isDragging){//用户没有正在拖拽scrollView
        if(self.scrollView.isDecelerating){//必须要求在减速
            if(self.state!=CoreFooterViewRefreshStateRefreshing){//此时没有正在刷新
                [self beginRefreshing];
            }
        }
    }
}

#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark - 在父类中用得上
/**
 *  刚好看到上拉刷新控件时的contentOffset.y
 */
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    CGFloat happenOffsetY=0.0f;
    if (deltaH > 0) {
        happenOffsetY= deltaH - self.scrollViewOriginalInset.top;
    } else {
        happenOffsetY =  - self.scrollViewOriginalInset.top;
    }
    
    happenOffsetY+=30.0f;
    
    return happenOffsetY;
}




#pragma mark 刷新方法
#pragma mark 开始刷新
- (void)beginRefreshing
{
    //界面立即显示
    self.state=CoreFooterViewRefreshStateRefreshing;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 回调
        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
            msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
        }
    });
    
    
    
}


#pragma mark  移除
-(void)removeFooter{
    [UIView animateWithDuration:.25f animations:^{
        self.scrollView.mj_contentInsetBottom=self.scrollViewOriginalInset.bottom;
    }];
    [self removeFromSuperview];
}




@end
