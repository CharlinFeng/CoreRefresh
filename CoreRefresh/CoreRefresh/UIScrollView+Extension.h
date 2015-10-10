//
//  UIScrollView+Extension.h
//
//  Created by 冯成林 on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extension)
@property (assign, nonatomic) CGFloat ex_contentInsetTop;
@property (assign, nonatomic) CGFloat ex_contentInsetBottom;
@property (assign, nonatomic) CGFloat ex_contentInsetLeft;
@property (assign, nonatomic) CGFloat ex_contentInsetRight;

@property (assign, nonatomic) CGFloat ex_contentOffsetX;
@property (assign, nonatomic) CGFloat ex_contentOffsetY;

@property (assign, nonatomic) CGFloat ex_contentSizeWidth;
@property (assign, nonatomic) CGFloat ex_contentSizeHeight;
@end
