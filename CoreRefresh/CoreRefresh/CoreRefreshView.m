//
//  CoreRefreshView.m
//  CoreRefresh
//
//  Created by 沐汐 on 15-1-18.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CoreRefreshView.h"
#import "CoreRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"

@interface CoreRefreshView ()

@property (nonatomic,assign) BOOL isCalInset;

@end

@implementation CoreRefreshView


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:CoreRefreshContentOffset context:nil];
    [self.superview removeObserver:self forKeyPath:CoreRefreshContentSize context:nil];
    
    if (newSuperview) { // 新的父控件
        
        // 监听
        [newSuperview addObserver:self forKeyPath:CoreRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:CoreRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];

        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
    
}


-(void)didMoveToSuperview{
    
    // 记录UIScrollView
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    // 记录UIScrollView最开始的contentInset
    _scrollViewOriginalInset = scrollView.contentInset;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(UIEdgeInsetsEqualToEdgeInsets(_scrollViewOriginalInset, UIEdgeInsetsZero) && !_isCalInset){
        _scrollViewOriginalInset = self.scrollView.contentInset;
        _isCalInset = YES;
    }
    
}



/**
 *  开始刷新
 */
- (void)beginRefreshing{
    
}


/**
 *  结束刷新
 */
- (void)endRefreshing{
    
    
}














@end
