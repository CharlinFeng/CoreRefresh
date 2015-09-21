//
//  NewsListTVC.m
//  CoreRefresh
//
//  Created by 沐汐 on 15-1-18.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NewsListTVC.h"
#import "CoreRefreshEntry.h"
#import "UIScrollView+MJExtension.h"

@interface NewsListTVC ()

@property (nonatomic,strong) NSArray *dataList;


@end

@implementation NewsListTVC

-(void)viewDidLoad{
    
    [super viewDidLoad];

    NSMutableArray *dataListM=[NSMutableArray array];
    
    for (NSInteger i=0; i<20; i++) {
        NSString *str=[NSString stringWithFormat:@"初始数据：%i",i];
        [dataListM addObject:str];
    }
    
    self.dataList=dataListM;
    
    [self.tableView reloadData];
    
    [self refreshWidgetPrepare];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerSetState:CoreHeaderViewRefreshStateRefreshing];
    });
    
}





#pragma mark  刷新控件准备
-(void)refreshWidgetPrepare{
    
    //添加顶部刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];

    
    //添加底部刷新
    [self.tableView addFooterWithTarget:self action:@selector(foorterRefresh)];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *rid=NSStringFromClass([self class]);
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
        cell.backgroundColor=[UIColor clearColor];
    }
    //取出数据
    NSString *str=self.dataList[indexPath.row];
    
    //设置数据
    cell.textLabel.text=str;
    
    return cell;
}





#pragma mark 刷新专区

#pragma mark  顶部刷新
-(void)headerRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerSetState:CoreHeaderViewRefreshStateRefreshingFailed];
    });
}


#pragma mark  底部刷新
-(void)foorterRefresh{
    NSLog(@"底部刷新");
    //保存旧数据
    NSMutableArray *oldArrayM=[NSMutableArray arrayWithArray:self.dataList];
    NSInteger count=oldArrayM.count;
    
    if(count<=66){
        for (NSInteger i=count; i<count+20; i++) {
            NSString *str=[NSString stringWithFormat:@"上拉刷新的新数据：%i",i];
            [oldArrayM addObject:str];
        }
        
        self.dataList=oldArrayM;
        
        [self.tableView reloadData];
        [self.tableView footerSetState:CoreFooterViewRefreshStateSuccessedResultDataShowing];
    }else{
        [self.tableView footerSetState:CoreFooterViewRefreshStateSuccessedResultNoMoreData];
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc=[[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}



@end
