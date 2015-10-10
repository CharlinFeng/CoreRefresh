//
//  UIScrollView+Extension.m
//
//  Created by 冯成林 on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)
- (void)setEx_contentInsetTop:(CGFloat)ex_contentInsetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = ex_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)ex_contentInsetTop
{
    return self.contentInset.top;
}

- (void)setEx_contentInsetBottom:(CGFloat)ex_contentInsetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = ex_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)ex_contentInsetBottom
{
    return self.contentInset.bottom;
}

- (void)setEx_contentInsetLeft:(CGFloat)ex_contentInsetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = ex_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)ex_contentInsetLeft
{
    return self.contentInset.left;
}

- (void)setEx_contentInsetRight:(CGFloat)ex_contentInsetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = ex_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)ex_contentInsetRight
{
    return self.contentInset.right;
}

- (void)setEx_contentOffsetX:(CGFloat)ex_contentOffsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = ex_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)ex_contentOffsetX
{
    return self.contentOffset.x;
}

- (void)setEx_contentOffsetY:(CGFloat)ex_contentOffsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = ex_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)ex_contentOffsetY
{
    return self.contentOffset.y;
}

- (void)setEx_contentSizeWidth:(CGFloat)ex_contentSizeWidth
{
    CGSize size = self.contentSize;
    size.width = ex_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)ex_contentSizeWidth
{
    return self.contentSize.width;
}

- (void)setEx_contentSizeHeight:(CGFloat)ex_contentSizeHeight
{
    CGSize size = self.contentSize;
    size.height = ex_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)ex_contentSizeHeight
{
    return self.contentSize.height;
}
@end
