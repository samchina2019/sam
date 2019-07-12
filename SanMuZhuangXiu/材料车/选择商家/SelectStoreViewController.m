//
//  SelectStoreViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SelectStoreViewController.h"
#import "SelectStoreListCell.h"
#import "ReLayoutButton.h"
#import "SelectStoreModel.h"
#import "BaojiadanDetailViewController.h"
#import "YBPopupMenu.h"
@interface SelectStoreViewController () <YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *quanbuBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *haopingBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *xiaoliangBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *juliBtn;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *juliArray;

@property (nonatomic, assign) int type;
@property (nonatomic) NSInteger page;

@end

@implementation SelectStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"选择商家";

    self.type = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.juliArray = [NSMutableArray arrayWithObjects:@{@"dis":@"当前城市",@"type":@(4)}, @{@"dis":@"5公里",@"type":@(5)}, @{@"dis":@"10公里",@"type":@(6)}, nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectStoreListCell" bundle:nil] forCellReuseIdentifier:@"SelectStoreListCell"];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark – Delegate

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *dict = @{
        @"page": @(_page),
        @"lng": @(longitude),
        @"lat": @(latitude),
        @"type": @(self.type),
        @"limit": @(8),
        @"stuff_cart_id": self.stuff_cart_id
    };
    NSLog(@"%@*********",dict);
    [DZNetworkingTool postWithUrl:kReceiptList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                NSArray *array = dict[@"data"];
                for (NSDictionary *dictData in array) {
                    SelectStoreModel *model = [SelectStoreModel mj_objectWithKeyValues:dictData];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark--tableview deleteGate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.tableView.backgroundView = backgroundImageView;
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.tableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectStoreListCell" forIndexPath:indexPath];
    SelectStoreModel *model = self.dataArray[indexPath.row];
    if (model.ad == 0) {
        cell.adLabel.hidden = YES;
    } else {
        cell.adLabel.hidden = NO;
    }
    //    if (model.taxes==0 ) {
    //        if (model.taxes_increment==0) {
    //            cell.fapiaoLabel.text=@"不开发票";
    //        }else{
    //            cell.fapiaoLabel.text=[NSString stringWithFormat:@"%.2f%%增值税发票",model.taxes_increment*100];
    //        }
    //    }else{
    //         cell.fapiaoLabel.text=[NSString stringWithFormat:@"%.2f%%普通发票",model.taxes*100];
    //    }

    //    cell.fapiaoLabel.text=[NSString stringWithFormat:@"%d",model.invoice];
    cell.storeNameLabel.text = model.seller[@"seller_name"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", model.distance];
    cell.starView.actualScore = [model.seller[@"level"] doubleValue];
    cell.fenLabel.text = [NSString stringWithFormat:@"%.1f", model.level];
    NSDictionary *dict = model.seller;
    NSArray *tempArray = dict[@"sales"];
    NSString *name = @"";
    NSString *tempName = @"";
    for (NSDictionary *temp in tempArray) {
        if ([temp[@"type"] intValue] == 1) {
            cell.huodaofuLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
        }
        if ([temp[@"type"] intValue] == 2) {
            cell.tongchengLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
        }
        if ([temp[@"type"] intValue] == 3) {
            cell.manjianLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
        }
        if ([temp[@"type"] intValue] == 4) {
           
//            if ([temp[@"content"] containsString:@"普通发票" ]) {
//                name = [NSString stringWithFormat:@"%@", temp[@"content"]];
//            }else{
//                tempName = [NSString stringWithFormat:@"%@", temp[@"content"]];
//            }
             cell.fapiaoLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
        }
    }
   
    cell.pipeiLabel.text = [NSString stringWithFormat:@"%d%%", model.match];
    cell.block = ^{
        BaojiadanDetailViewController *viewController = [BaojiadanDetailViewController new];
        viewController.receipt_id = [self.stuff_cart_id intValue];
        viewController.seller_id = [model.seller[@"seller_id"] intValue];
        viewController.nameStr = self.cartName;

        [self.navigationController pushViewController:viewController animated:YES];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Function

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (ybPopupMenu.tag == 200) { //附近回调
        for (NSDictionary *dict in self.juliArray) {
            if ([dict[@"dis"] isEqualToString:ybPopupMenu.titles[index]]) {
                self.type=[dict[@"type"] intValue];
            }
        }
        [self refresh];
    }
}
#pragma mark - XibFunction
//排序
- (IBAction)panxuBtnclicked:(UIButton *)sender {
    [sender setTitleColor:UIColorFromRGB(0x3FAEE9) forState:UIControlStateNormal];
    switch (sender.tag) {
            
    case 1: {
        NSMutableArray *temp=[NSMutableArray array];
        if (self.juliArray.count > 0) {
            for (NSDictionary *dict in self.juliArray) {
                [temp addObject:dict[@"dis"]];
            }
            [YBPopupMenu showRelyOnView:sender
                                 titles:temp
                                  icons:nil
                              menuWidth:140
                          otherSettings:^(YBPopupMenu *popupMenu) {
                              popupMenu.dismissOnSelected = YES;
                              popupMenu.isShowShadow = YES;
                              popupMenu.delegate = self;
                              popupMenu.type = YBPopupMenuTypeDefault;
                              popupMenu.cornerRadius = 8;
                              popupMenu.tag = 200;
                              //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
                              popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                          }];
        } else {
            [DZTools showNOHud:@"正在请求列表，请稍后重试！" delay:2.0];
            //            [self loadData];
        }
        
        self.juliBtn.selected = NO;
        self.haopingBtn.selected = NO;
        self.xiaoliangBtn.selected = NO;
        [self.juliBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.haopingBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.xiaoliangBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        
        //        self.juliBtn.selected=NO;

    } break;
    case 2: {
        self.type=1;

        self.quanbuBtn.selected = NO;
        self.haopingBtn.selected = NO;
        self.xiaoliangBtn.selected = NO;
        [self.quanbuBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.haopingBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.xiaoliangBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    } break;
    case 3: {
        self.type=2;
        self.quanbuBtn.selected = NO;
        self.juliBtn.selected = NO;
        self.xiaoliangBtn.selected = NO;
        [self.quanbuBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.juliBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.xiaoliangBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    } break;
    case 4: {
        self.type=3;
        self.quanbuBtn.selected = NO;
        self.haopingBtn.selected = NO;
        self.juliBtn.selected = NO;
        [self.quanbuBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.juliBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.haopingBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    } break;

    default:
        break;
    }
        [self refresh];
   
}


@end
