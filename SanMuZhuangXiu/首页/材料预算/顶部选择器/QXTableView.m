//
//  QXTableView.m
//  YoungDrill
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 czg. All rights reserved.
//

#import "QXTableView.h"
#import <MJRefresh.h>
@implementation QXTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([self.refreshDelegate respondsToSelector:@selector(QXBaseTableViewDidPullDownRefreshed:)]) {
                [self.refreshDelegate QXBaseTableViewDidPullDownRefreshed:self ];
            }
        }];
        
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([self.refreshDelegate respondsToSelector:@selector(QXBaseTableViewDidPullUpRefreshed:)]) {
                [self.refreshDelegate QXBaseTableViewDidPullUpRefreshed:self];
            }
        }];
    }
    return self;
}


- (void)beginRefreshing{
    [self.mj_header beginRefreshing];
}

-(void)reloadDeals{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
