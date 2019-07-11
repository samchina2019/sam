//
//  UnusualViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "UnusualViewController.h"

#import "YichangchuliViewController.h"
#import "ZidingyiYCViewController.h"
#import "ChatViewController.h"

#import "UnusualSectionView.h"

#import "JinduTableViewCell.h"
#import "UnusualDataCell.h"
#import "UnusualCell.h"

#import "AbnormalModel.h"
#import "HandModel.h"
#import "UnusualOrderModel.h"

@interface UnusualViewController ()
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIView *basicView;

//宜家居家装设计装修官方旗舰店
@property (weak, nonatomic) IBOutlet UILabel *shangjiaNameLabel;
//订单编号：20180230230656000236
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
//下单时间：2018-11-12 12:12
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//收件人：张三
@property (weak, nonatomic) IBOutlet UILabel *shoujianrenNameLabel;
//河南省郑州市管城回族区南曹乡美景鸿城七里河小区
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

///商家名称
@property (nonatomic, strong) NSString *sellerName;
///商家id
@property (nonatomic, strong) NSString *sellerId;
///商家头像
@property (nonatomic, strong) NSString *sellerImages;
///电话号码
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;

@property (nonatomic, strong) UnusualSectionView *sectionView;

@property (nonatomic, strong) NSMutableArray *abnormalArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *handArray;
///商家电话
@property (nonatomic, strong) NSString *sellerphone;

@property (nonatomic) NSInteger page;
///是否隐藏
@property (assign, nonatomic) BOOL iSHide;

@end

@implementation UnusualViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 11.0, *)) {
        self.detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.iSHide = YES;
    [self initBasicView];
    [self initDetailTableView];
}
#pragma mark – UI
- (void)initDetailTableView {
    self.headView.frame = CGRectMake(0, 0, ViewWidth, 240);
    self.detailTableView.tableHeaderView = self.headView;
    //    self.footView.frame = CGRectMake(0, 0, ViewWidth, 76);
    //
    //    self.detailTableView.tableFooterView = self.footView;

    [self.detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.detailTableView registerNib:[UINib nibWithNibName:@"UnusualCell" bundle:nil] forCellReuseIdentifier:@"UnusualCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"JinduTableViewCell" bundle:nil] forCellReuseIdentifier:@"JinduTableViewCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"UnusualDataCell" bundle:nil] forCellReuseIdentifier:@"UnusualDataCell"];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.abnormalArray = [NSMutableArray array];
    self.handArray = [NSMutableArray array];

    self.detailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    [self.detailTableView.mj_header beginRefreshing];
}
- (void)initBasicView {
    //阴影的颜色
    self.basicView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.basicView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.basicView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.basicView.layer.shadowOffset = CGSizeMake(0, 0);
    self.basicView.layer.cornerRadius = 5;
}

#pragma mark – Network

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    NSDictionary *params = @{
        @"id": @(self.orderId)
    };
    [DZNetworkingTool postWithUrl:kAbnormalOrder
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.detailTableView.mj_footer.isRefreshing) {
                [self.detailTableView.mj_footer endRefreshing];
            }
            if (self.detailTableView.mj_header.isRefreshing) {
                [self.detailTableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                NSDictionary *temp = responseObject[@"data"][@"order"];
                NSDictionary *seller = temp[@"seller"];
                self.shangjiaNameLabel.text = [NSString stringWithFormat:@"%@", seller[@"seller_name"]];
                self.sellerName = seller[@"seller_name"];
                self.sellerId = temp[@"seller_id"];
                self.sellerImages = seller[@"images"];

                if ([seller[@"seller_phone"] length] == 0) {
                    self.sellerphone = @"10086";
                }else{
                self.sellerphone = [NSString stringWithFormat:@"%@", seller[@"seller_phone"]];
                }
                self.bianhaoLabel.text = [NSString stringWithFormat:@"订单编号：%@", temp[@"order_no"]];
                // 时间戳 -> NSDate *
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"createtime"] intValue]];
                //设置时间格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                //将时间转换为字符串
                NSString *timeStr = [formatter stringFromDate:date];
                self.timeLabel.text = [NSString stringWithFormat:@"下单时间：%@", timeStr];
                NSDictionary *address = temp[@"address"];
                self.shoujianrenNameLabel.text = [NSString stringWithFormat:@"收件人：%@", address[@"name"]];
                self.phoneLabel.text = [NSString stringWithFormat:@"%@", address[@"phone"]];
                self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", address[@"province_id"], address[@"city_id"], address[@"region_id"], address[@"detail"]];
                [self.view layoutIfNeeded];

                [self.dataArray removeAllObjects];
                NSArray *array = temp[@"order_data"];
                for (NSDictionary *list in array) {
                    UnusualOrderModel *model = [UnusualOrderModel mj_objectWithKeyValues:list];
                    [self.dataArray addObject:model];
                }

                [self.abnormalArray removeAllObjects];
                NSArray *abnormal = temp[@"abnormal"];
                for (NSDictionary *abnormalList in abnormal) {
                    AbnormalModel *model = [AbnormalModel mj_objectWithKeyValues:abnormalList];
                    [self.abnormalArray addObject:model];
                }
                [self.handArray removeAllObjects];
                NSArray *in_hand = temp[@"in_hand"];
                for (NSDictionary *dict in in_hand) {
                    HandModel *model = [HandModel mj_objectWithKeyValues:dict];
                    [self.handArray addObject:model];
                }
                [self.detailTableView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.detailTableView.mj_footer.isRefreshing) {
                [self.detailTableView.mj_footer endRefreshing];
            }
            if (self.detailTableView.mj_header.isRefreshing) {
                [self.detailTableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

#pragma mark--tableview deleteGate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.iSHide) {
            return 0;
        }
        if (self.dataArray.count == 0) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.detailTableView.backgroundView = backgroundImageView;
            self.detailTableView.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.detailTableView.backgroundView = nil;
        }
        return self.dataArray.count;
    } else if (section == 1) {
        if (self.abnormalArray.count == 0) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.detailTableView.backgroundView = backgroundImageView;
            self.detailTableView.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.detailTableView.backgroundView = nil;
        }
        return self.abnormalArray.count;
    } else {
        return self.handArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 115;
    } else if (indexPath.section == 1) {
        return 175;
    } else {
        return 60;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        self.sectionView = [[UnusualSectionView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
        self.sectionView.sectionNameLabel.text = @"异常货物区域";
        self.sectionView.zankaiBtn.hidden = YES;
        return self.sectionView;

    } else if (section == 0) {
        self.sectionView = [[UnusualSectionView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
        self.sectionView.sectionNameLabel.text = @"已收货商品";
        self.sectionView.zankaiBtn.hidden = NO;
        __weak typeof(UnusualViewController *) weakself = self;

        self.sectionView.zankaiBlock = ^{

            weakself.iSHide = !weakself.iSHide;
            [weakself.detailTableView reloadData];
        };

        return self.sectionView;
    } else {
        UIView *view = [[UIView alloc] init];

        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] init];
        return view;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
        return view;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UnusualCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnusualCell" forIndexPath:indexPath];
        AbnormalModel *model = self.abnormalArray[indexPath.row];
        if (model.goods_name.length == 0) {
            cell.cailiaoNameLabel.text = @"无名称";
        } else {
            cell.cailiaoNameLabel.text = model.goods_name;
        }
        if (model.brand_name.length == 0 ) {
            cell.pinpaiNameLabel.text = @"暂无名称";
        } else {
            cell.pinpaiNameLabel.text = [NSString stringWithFormat:@"品牌：%@", model.brand_name];
        }
        NSString *name = @"";
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in model.spec_name) {
            [array addObject:dict[@"name"]];
        }
        name = [array componentsJoinedByString:@","];
        cell.guigeLabel.text = [NSString stringWithFormat:@"规格：%@", name];
        cell.shijiNumberLabel.text = [NSString stringWithFormat:@"实到：%d", model.true_to];
        cell.posunLabel.text = [NSString stringWithFormat:@"破损：%d", model.damaged];
        cell.buhuoLabel.text = [NSString stringWithFormat:@"补货:%d 换货:%d退货:0", model.damaged, model.mistake];
        //        cell.totalPriceLabel.text=[NSString stringWithFormat:@"¥%.2f",([model.goods_price floatValue]*model.true_to)];
        //        cell.onePriceLabel.text=[NSString stringWithFormat:@"¥%@",model.goods_price];

        return cell;
    } else if (indexPath.section == 2) {

        JinduTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JinduTableViewCell" forIndexPath:indexPath];
        HandModel *model = self.handArray[indexPath.row];
        cell.shangjiaMessageLabel.text = [NSString stringWithFormat:@"%@", model.text];
        if (model.status == 0) {
            cell.jinDuBtn.selected = YES;
        } else {
            cell.jinDuBtn.selected = NO;
        }
        if (model.time.length == 0) {
            cell.timeLabel.text = @"暂无时间";
        } else {
            cell.timeLabel.text = model.time;
        }
        return cell;
    } else {
        UnusualDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnusualDataCell" forIndexPath:indexPath];
        UnusualOrderModel *model = self.dataArray[indexPath.row];
        if (model.goods_name.length == 0) {
            cell.nameLabel.text = @"";
        } else {
            cell.nameLabel.text = [NSString stringWithFormat:@"品牌：%@", model.goods_name];
        }

        if (model.stuff_brand_name.length == 0) {
            cell.pinpaiLabel.text = @"";
        } else {
            cell.pinpaiLabel.text = model.stuff_brand_name;
        }
        NSString *name = @"";
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in model.stuff_spec_name) {
            [array addObject:dict[@"name"]];
        }
        name = [array componentsJoinedByString:@","];
        cell.guigeLabel.text = [NSString stringWithFormat:@"规格：%@", name];
        cell.numberLabel.text = [NSString stringWithFormat:@"数量：%d", model.total_num];
        cell.totalLabel.text = [NSString stringWithFormat:@"¥%.2f", ([model.goods_price floatValue] * model.total_num)];
        cell.onePriceLabel.text = [NSString stringWithFormat:@"¥%@", model.goods_price];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark--XibFunction

//自定义点击事件
- (IBAction)zidingyiBtnClick:(id)sender {
    self.parentViewController.hidesBottomBarWhenPushed = YES;

    ZidingyiYCViewController *zidingyiVC = [[ZidingyiYCViewController alloc] init];
    [self.navigationController pushViewController:zidingyiVC animated:YES];
    self.parentViewController.hidesBottomBarWhenPushed = YES;
}
//一键处理点击事件
- (IBAction)yijianchuliBtnClick:(id)sender {

    self.parentViewController.hidesBottomBarWhenPushed = YES;
    YichangchuliViewController *yichangVC = [[YichangchuliViewController alloc] init];

    [self.navigationController pushViewController:yichangVC animated:YES];
    self.parentViewController.hidesBottomBarWhenPushed = YES;
}
//打电话
- (IBAction)phonebtnClick:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.sellerphone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:
                     [NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
//返回
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//聊天
- (IBAction)chattingBtnClick:(id)sender {
    NSDictionary *dict = @{
        @"user_id": self.sellerId
    };
    [DZNetworkingTool postWithUrl:kFriendDetails
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                NSString *headImg = dict[@"avatar"];
                NSString *title = dict[@"nickname"];
              
                //会话列表
                ChatViewController *conversationVC = [[ChatViewController alloc] init];
                conversationVC.hidesBottomBarWhenPushed = YES;
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = [NSString stringWithFormat:@"%@", self.sellerId];
                conversationVC.title = title;

                RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                rcduserinfo_.name = title;
                rcduserinfo_.userId = [NSString stringWithFormat:@"%@", self.sellerId];
                rcduserinfo_.portraitUri = headImg;

                [self.navigationController pushViewController:conversationVC animated:YES];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
@end
