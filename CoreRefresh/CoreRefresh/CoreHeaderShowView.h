//
//  CoreHeaderShowView.h
//  CoreRefresh
//
//  Created by muxi on 15/1/19.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreHeaderShowView : UIView

@property (nonatomic,assign) CGFloat progress;                          //进度

@property (nonatomic,assign,getter=isRefreshing) BOOL refreshing;                            //是否刷新中

@end
