//
//  CoreFooterView.h
//  CoreRefresh
//
//  Created by 沐汐 on 15-1-18.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreRefreshView.h"

typedef enum{
    
    CoreFooterViewRefreshStateNormalForContinueDragUp=0,                                                    //这就是最普通的状态，并且普通状态是请继续拉动
    
    CoreFooterViewRefreshStateRefreshing,                                                                   //刷新中
    
    CoreFooterViewRefreshStateFailed,                                                                       //刷新失败
    
    CoreFooterViewRefreshStateSuccessedResultNoMoreData,                                                    //刷新成功->无更多数据
    
    CoreFooterViewRefreshStateSuccessedResultDataShowing,                                                   //刷新成功->本次的新数据正在展示中（此状态会延时变更为0）
    
}CoreFooterViewRefreshState;


@interface CoreFooterView : CoreRefreshView


@property (nonatomic,assign) CoreFooterViewRefreshState state;                                              //底部控件的状态

+ (instancetype)footer;

-(void)removeFooter;

@end
