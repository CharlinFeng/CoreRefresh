//
//  UIScrollView+Refresh.h
//  CoreRefresh
//
//  Created by 沐汐 on 15-1-18.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CoreFooterView.h"
#import "CoreHeaderView.h"

@interface UIScrollView (Refresh)




/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action;


/**
 *  header的状态更新
 */
-(void)headerSetState:(CoreHeaderViewRefreshState)state;


/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;







/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action;


/**
 *  footer的状态更新
 */
-(void)footerSetState:(CoreFooterViewRefreshState)state;



/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter;







@end
