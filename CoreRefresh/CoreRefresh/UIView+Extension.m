//
//  UIView+Extension.m
//
//  Created by 冯成林 on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (void)setEx_x:(CGFloat)ex_x
{
    CGRect frame = self.frame;
    frame.origin.x = ex_x;
    self.frame = frame;
}

- (CGFloat)ex_x
{
    return self.frame.origin.x;
}

- (void)setEx_y:(CGFloat)ex_y
{
    CGRect frame = self.frame;
    frame.origin.y = ex_y;
    self.frame = frame;
}

- (CGFloat)ex_y
{
    return self.frame.origin.y;
}

- (void)setEx_width:(CGFloat)ex_width
{
    CGRect frame = self.frame;
    frame.size.width = ex_width;
    self.frame = frame;
}

- (CGFloat)ex_width
{
    return self.frame.size.width;
}

- (void)setEx_height:(CGFloat)ex_height
{
    CGRect frame = self.frame;
    frame.size.height = ex_height;
    self.frame = frame;
}

- (CGFloat)ex_height
{
    return self.frame.size.height;
}

- (void)setEx_size:(CGSize)ex_size
{
    CGRect frame = self.frame;
    frame.size = ex_size;
    self.frame = frame;
}

- (CGSize)ex_size
{
    return self.frame.size;
}

- (void)setEx_origin:(CGPoint)ex_origin
{
    CGRect frame = self.frame;
    frame.origin = ex_origin;
    self.frame = frame;
}

- (CGPoint)ex_origin
{
    return self.frame.origin;
}
@end
