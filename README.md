<br /><br />

CoreRefresh（关注[信息公告牌](https://github.com/CharlinFeng/Show)）
=======
核心上拉下拉刷新控件，专业、高性能、个性化，与众不同！创意灵感来自iPad版本的土豆和淘宝！
#### .Xcode 6.0
#### .Objective-C

<br /><br /><br />


框架特性
=======
>1.完全重写了头部刷新控件，头部刷新控件个性化，你再也不用因为看到其他应用使用的是和你一样的顶部刷新控件而尴尬。<br />
>2.底部刷新控件由滑动自动触发，不需要你使劲拉，不需要点击。<br />
>3.高度优化了头部刷新的性能，底部刷新控件的性能，我在iphone4测试十分流畅，很多大公司刷新控件一拉卡卡的，就是没处理好性能的问题。<br />
>4.删除了所有复杂的调用，本框架一键安装，支持自动刷新，你只需在业务中给控件对应的state即可，其他全部由控件完成！<br />
>5.本框架支持ios6及以上，横竖屏，支持TableView及CollectionView。<br />
>6.高性能、易使用、人性化。<br />
>7.本框架是大型框架`列表终结者`的核心组成部分之一！<br />
>8.本框架基于MJRefresh。向原作者致敬。


<br /><br /><br />
效果演示
=======

#### 1. 自动触发顶部刷新
![image](https://github.com/CharlinFeng/Resource/blob/master/CoreRefresh/1.gif)<br/><br/>

#### 2. 手动拖拽触发顶部刷新
![image](https://github.com/CharlinFeng/Resource/blob/master/CoreRefresh/2.gif)<br/><br/>

#### 3. 用户过度拖拽触发顶部APP广告
![image](https://github.com/CharlinFeng/Resource/blob/master/CoreRefresh/3.gif)<br/>

#### 注：请在CoreHeaderView.xib中的adView自定义您的广告内容，因为广告可能是文字，也可能是图片，还可能是其他复杂内容，所以预留Xib给您自定义。
#### adView会在scrollView的ContentOffset改变中实时隐藏和显示，请一定要加在adView里面，不然可能会穿透导航栏显得不好看。

<br/><br/>

#### 4. 全自动的底部刷新，再也不需要手动拖拽！
![image](https://github.com/CharlinFeng/Resource/blob/master/CoreRefresh/4.gif)<br/><br/>


<br /><br /><br />
使用说明
=======
<br />
#### 1.请拖拽CoreRefresh文件夹到您的项目<br />

注：请注意CoreRefresh的核心思想是基于状态的控件，想要功能，请指定对应状态。


#### 2. 安装控件

    //添加顶部刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    //添加底部刷新
    [self.tableView addFooterWithTarget:self action:@selector(foorterRefresh)];

#### 3. 自动触发顶部刷新

    [self.tableView headerSetState:CoreHeaderViewRefreshStateRefreshing];

#### 4.各种状态指定

    //顶部刷新失败
    [self.tableView headerSetState:CoreHeaderViewRefreshStateRefreshingFailed];
    //底部无数据
    [self.tableView footerSetState:CoreFooterViewRefreshStateSuccessedResultNoMoreData];
    
注： 更多状态请参考以下枚举值

    //顶部刷新控件状态
    typedef enum{
        
        CoreHeaderViewRefreshStateNorMal=0,                                                 //普通状态
        
        CoreHeaderViewRefreshStateReleaseForRefreshing,                                     //松手立即刷新
        
        CoreHeaderViewRefreshStateRefreshing,                                               //刷新中
        
        CoreHeaderViewRefreshStateRefreshingFailed,                                         //刷新失败
        
        CoreHeaderViewRefreshStateSuccessedResultNoMoreData,                                //刷新成功，无更多数据
        
        CoreHeaderViewRefreshStateSuccessedResultDataShowing,                               //刷新成功，数据展示中
        
    }CoreHeaderViewRefreshState;


    //底部刷新控件状态
    typedef enum{
        
        //这就是最普通的状态，并且普通状态是请继续拉动
        CoreFooterViewRefreshStateNormalForContinueDragUp=0,
        
        //请求中
        CoreFooterViewRefreshStateRequesting,
        
        //刷新中
        CoreFooterViewRefreshStateRefreshing,
    
        //刷新失败
        CoreFooterViewRefreshStateFailed,
    
        //刷新成功->无更多数据
        CoreFooterViewRefreshStateSuccessedResultNoMoreData,
    
        //刷新成功->本次的新数据正在展示中（此状态会延时变更为0）
        CoreFooterViewRefreshStateSuccessedResultDataShowing,
        
    }CoreFooterViewRefreshState;
