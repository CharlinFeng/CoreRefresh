//
//  RefreshConst.h
//  CoreRefresh
//
//  Created by 沐汐 on 15-1-18.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreRefreshConst : NSObject


// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)


UIKIT_EXTERN  NSString *const CoreRefreshContentOffset;                                                //contentOffset

UIKIT_EXTERN  NSString *const CoreRefreshContentSize;                                                  //contentSize

UIKIT_EXTERN CGFloat const CoreRefreshHeaderViewH;                                                     //头部刷新控件的高度

UIKIT_EXTERN CGFloat const CoreRefreshFooterViewH;                                                     //底部刷新控件的高度





@end
