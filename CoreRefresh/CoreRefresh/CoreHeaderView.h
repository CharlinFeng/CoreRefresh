//
//  CoreHeaderView.h
//  CoreRefresh
//
//  Created by muxi on 15/1/19.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreRefreshView.h"

typedef enum{
    
    CoreHeaderViewRefreshStateNorMal=0,                                                 //普通状态
    
    CoreHeaderViewRefreshStateReleaseForRefreshing,                                     //松手立即刷新
    
    CoreHeaderViewRefreshStateRefreshing,                                               //刷新中
    
    CoreHeaderViewRefreshStateRefreshingFailed,                                         //刷新失败
    
    CoreHeaderViewRefreshStateSuccessedResultNoMoreData,                                //刷新成功，无更多数据
    
    CoreHeaderViewRefreshStateSuccessedResultDataShowing,                               //刷新成功，数据展示中
    
}CoreHeaderViewRefreshState;





@interface CoreHeaderView : CoreRefreshView

@property (nonatomic,assign) CoreHeaderViewRefreshState state;                          //状态


+ (instancetype)header;

- (void)removeHeader;

@end
