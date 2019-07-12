//
//  QXTableView.h
//  YoungDrill
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 czg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXTableView;
@protocol QXBaseTableViewDelegate <NSObject>

@optional
/**
 下拉刷新

 @param tableView tableview
 */
- (void)QXBaseTableViewDidPullDownRefreshed:(QXTableView *)tableView;

/**
 上拉加载

 @param tableView tableview
 */
- (void)QXBaseTableViewDidPullUpRefreshed:(QXTableView *)tableView;


@end

@interface QXTableView : UITableView
@property (nonatomic,assign) id<QXBaseTableViewDelegate> refreshDelegate;

//结束刷新状态，请求结束时调用
- (void)reloadDeals;

// 开始刷新
- (void)beginRefreshing;





@end
