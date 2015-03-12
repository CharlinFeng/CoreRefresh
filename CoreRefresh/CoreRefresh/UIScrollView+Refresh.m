//
//  UIScrollView+Refresh.m
//  CoreRefresh
//
//  Created by 沐汐 on 15-1-18.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "UIScrollView+Refresh.h"

#import <objc/runtime.h>

@interface UIScrollView ()

@property (weak, nonatomic) CoreHeaderView *header;

@property (weak, nonatomic) CoreFooterView *footer;

@end

#pragma mark - 运行时相关
static char CoreHeaderViewKey;
static char CoreFooterViewKey;

@implementation UIScrollView (Refresh)




/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 1.创建新的header
        if (!self.header) {
            CoreHeaderView *header = [CoreHeaderView header];
            [self addSubview:header];
            self.header = header;
        }
        
        // 2.设置目标和回调方法
        self.header.beginRefreshingTaget = target;
        self.header.beginRefreshingAction = action;
    });
}

/**
 *  header的状态更新
 */
-(void)headerSetState:(CoreHeaderViewRefreshState)state{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.header.state=state;
    });
    
}


/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.header removeHeader];
    });
    
    self.header = nil;
}









/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 1.创建新的footer
        if (!self.footer) {
            CoreFooterView *footer = [CoreFooterView footer];
            [self addSubview:footer];
            self.footer = footer;
        }
        
        // 2.设置目标和回调方法
        self.footer.beginRefreshingTaget = target;
        self.footer.beginRefreshingAction = action;
    });
}


/**
 *  footer的状态更新
 */
-(void)footerSetState:(CoreFooterViewRefreshState)state{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.footer.state=state;
    });
    
}



/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.footer removeFooter];
        self.footer = nil;
    });
}






#pragma mark 使用运行时模拟成员变量：header
- (void)setHeader:(CoreHeaderView *)header {
    [self willChangeValueForKey:@"CoreHeaderViewKey"];
    objc_setAssociatedObject(self, &CoreHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"CoreHeaderViewKey"];
}

- (CoreHeaderView *)header {
    return objc_getAssociatedObject(self, &CoreHeaderViewKey);
}



#pragma mark 使用运行时模拟成员变量：footer
- (void)setFooter:(CoreFooterView *)footer {
    [self willChangeValueForKey:@"CoreFooterViewKey"];
    objc_setAssociatedObject(self, &CoreFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"CoreFooterViewKey"];
}

- (CoreFooterView *)footer {
    return objc_getAssociatedObject(self, &CoreFooterViewKey);
}


@end
