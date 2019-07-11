//
//  GoodsDetailInfoViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GoodsDetailInfoViewController.h"
#import "StoreDetailCommentCell.h"
#import "PPNumberButton.h"
#import "SDCycleScrollView.h"
#import "GoodsDetailModel.h"
#import "SpecGoodsModel.h"
#import "ReLayoutButton.h"
#import "CmtDataModel.h"
#import "CartJiesuanViewController.h"
#import "ZhiFuSelectTypeView.h"
#import "StoreDetailViewController.h"
#import "ChatViewController.h"
#import <UShareUI/UShareUI.h>

@interface GoodsDetailInfoViewController () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *lunboBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *shuiPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuNumLabel;
@property (weak, nonatomic) IBOutlet PPNumberButton *ppNumButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *youtuBtn;
@property (weak, nonatomic) IBOutlet UIButton *haopingBtn;
@property (weak, nonatomic) IBOutlet UIButton *chapingBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *pinpaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *hanshuiLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *guigeBtn;

@property (weak, nonatomic) UIButton *selectBtn;

@property (nonatomic, strong) NSMutableArray *specArray;
@property (nonatomic, strong) NSMutableArray *specDataArray;
@property (nonatomic, strong) NSMutableArray *bandDataArray;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *addressArray;

@property (nonatomic, assign) NSString *selectSpecId;
@property (nonatomic, assign) NSString *selectBandId;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, assign) NSInteger stock_num;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *goods_sku_id;
@property (nonatomic, strong) NSString *goods_num;

@property (nonatomic, assign) NSInteger follow;

@property (nonatomic) NSInteger page;
@property (nonatomic, assign) BOOL isFollew;

@end

@implementation GoodsDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.specArray = [NSMutableArray array];
    self.specDataArray = [NSMutableArray array];
    self.selectBtn = self.allBtn;
    self.typeStr = @"1";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.bandDataArray = [NSMutableArray array];
    self.addressArray = [NSArray array];
    [self setHeaderFooterView];
    [self refreshWithDict:self.dataDict];
    self.ppNumButton.currentNumber = 1;
    self.isFollew = NO;
    self.goods_num = @"1";
    self.ppNumButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        self.goods_num = [NSString stringWithFormat:@"%d", (int) number];
        self.Block(self.goods_num, YES);
    };

    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth) delegate:self placeholderImage:[UIImage imageNamed:@"defaultImg"]];

    self.cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    [SDCycleScrollView clearImagesCache]; // 清除缓存。
    [self.lunboBgView addSubview:self.cycleScrollView];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreDetailCommentCell" bundle:nil] forCellReuseIdentifier:@"StoreDetailCommentCell"];
    [self.tableView.mj_header beginRefreshing];
}
- (void)refreshGoodsInfoWithDict:(NSDictionary *)dict {
    self.ppNumButton.currentNumber = [dict[@"num"] floatValue];
    for (NSDictionary *pingPai in self.dataDict[@"specData"][@"brand_list"]) {
        if ([dict[@"pingPaiID"] integerValue] == [pingPai[@"brand_id"] integerValue]) {
            [self.pinpaiBtn setTitle:pingPai[@"brand_name"] forState:UIControlStateNormal];
        }
    }
    [self.guigeBtn setTitle:dict[@"goods_sku_name"] forState:UIControlStateNormal];
    
    if ([dict[@"goods_spec_id"] length] == 0) {
        self.pricelabel.text = self.priceStr;
        return;
    }
    for (NSDictionary *tempdict in self.dataDict[@"specData"][@"spec_list"]) {
        if ([dict[@"goods_spec_id"] intValue] == [tempdict[@"goods_spec_id"] intValue]) {
            self.pricelabel.text = tempdict[@"form"][@"goods_price"];
            self.yuNumLabel.text = [NSString stringWithFormat:@"剩余%@件", tempdict[@"form"][@"stock_num"]];
        }
    }
}
- (void)refreshWithDict:(NSDictionary *)dict {
    if ([[dict allKeys] count] == 0) {
        return;
    }
    GoodsDetailModel *model = [GoodsDetailModel mj_objectWithKeyValues:dict[@"detail"]];
    NSArray *array = model.imgs_url;

    NSString *name = model.goods_name;
    NSString *goodsinfo = model.goods_introduce;
    CGFloat nameHeight = [DZTools sizeForString:name withSize:CGSizeMake(ViewWidth - 32, 1000) withFontSize:17].height;
    self.nameLabelHeight.constant = nameHeight;
    CGFloat goodsInfoHeight = [DZTools sizeForString:goodsinfo withSize:CGSizeMake(ViewWidth - 32, 1000) withFontSize:14].height;
    self.priceStr = model.goods_price;
    self.stock_num = model.stock_num;
    self.pricelabel.text = self.priceStr;
    self.hanshuiLabel.textColor = [UIColor clearColor];
    self.shuiPriceLabel.textColor = [UIColor clearColor];
    self.yuNumLabel.text = [NSString stringWithFormat:@"剩余%ld件", (long)self.stock_num];
    self.nameLabel.text = name;

//    NSArray *imageArray = model.contentimages;
//                                  NSString *imgStr = @"";
//                                  for (int i = 0; i < imageArray.count; i++) {
//                                      imgStr = [NSString stringWithFormat:@"%@<img src=\"%@\" width=\"100%%\">",imgStr,imageArray[i]];
//                                  }
//                                  NSString *content = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title></title></head><body><div>%@</div></body></html>",imgStr];
//
//                                  [self.webView loadHTMLString:content baseURL:nil];

    self.goodsInfoLabel.text = goodsinfo;
    NSArray *temp = [NSArray array];
    temp = model.spec;
    [self.specArray removeAllObjects];
    for (NSDictionary *dict in temp) {
        SpecGoodsModel *model = [SpecGoodsModel mj_objectWithKeyValues:dict];
        [self.specArray addObject:model];
    }
    [self.specDataArray removeAllObjects];
    NSArray *spArray = [NSArray array];
    spArray = model.spec_data;
    for (NSDictionary *dict in spArray) {
        [self.specDataArray addObject:dict];
    }

    [self.bandDataArray removeAllObjects];
    NSArray *bandArray = model.brand_data;
    for (NSDictionary *dict in bandArray) {
        [self.bandDataArray addObject:dict];
    }

    self.tableHeaderView.frame = CGRectMake(0, 0, ViewWidth, 255 + ViewWidth + nameHeight + goodsInfoHeight);
    self.cycleScrollView.imageURLStringsGroup = array;
}
- (void)setHeaderFooterView {
    NSString *name = @"商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称";
    NSString *goodsinfo = @"商品介绍商品介绍商品介绍商品介绍商品介绍商介绍商品介绍商介绍商品介绍商品介绍商品介绍商品介绍商品介绍商品介绍商品介绍商品商品介绍商品介绍商品介绍商品介绍商品介绍商品介绍商品介绍商品介绍商品介绍商品介1绍商品介绍商品23445";
    CGFloat nameHeight = [DZTools sizeForString:name withSize:CGSizeMake(ViewWidth - 32, 1000) withFontSize:17].height;
    self.nameLabelHeight.constant = nameHeight;
    CGFloat goodsInfoHeight = [DZTools sizeForString:goodsinfo withSize:CGSizeMake(ViewWidth - 32, 1000) withFontSize:14].height;
    //    self.goods_num=[NSString stringWithFormat:@"%f",self.ppNumButton.currentNumber];

    self.tableHeaderView.frame = CGRectMake(0, 0, ViewWidth, 315 + ViewWidth + nameHeight + goodsInfoHeight);
    self.tableView.tableHeaderView = self.tableHeaderView;
    //    self.tableFooterView.frame = CGRectMake(0, 0, ViewWidth, 65);
    //    self.tableView.tableFooterView = self.tableFooterView;
}
- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {

    NSDictionary *dict = @{
        @"goods_id": @(self.goodsId),
        @"page": @(_page),
        @"type": self.typeStr
    };
    NSLog(@"%@", dict);
    [DZNetworkingTool postWithUrl:kEvaluSelect
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.commentNumLabel.text = [NSString stringWithFormat:@"评价(%@)", dict[@"num"]];
                //                                  [self.dataArray removeAllObjects];
                NSArray *temp = dict[@"list"];
                for (NSDictionary *dict in temp) {
                    CmtDataModel *model = [CmtDataModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        IsNeedHub:NO];
}
#pragma mark - <UITableViewDelegate和DataSource>
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreDetailCommentCell" forIndexPath:indexPath];
    CmtDataModel *model = self.dataArray[indexPath.row];

    cell.contentLabel.text = model.cmt_content;

    cell.array = model.cmt_images;

    cell.starView.actualScore = [model.star intValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    ShenghuoquanModel *model = self.dataArray[indexPath.row];
    //    self.hidesBottomBarWhenPushed = YES;
    //    LifeCycleDetailViewController *viewController = [LifeCycleDetailViewController new];
    //    viewController.zone_id = model.zone_id;
    //    [self.navigationController pushViewController:viewController animated:YES];
    //    self.hidesBottomBarWhenPushed = YES;
}
#pragma mark - webView delegate方法

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 获取webView的高度
    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    self.webViewHeight.constant = webViewHeight;

    self.tableHeaderView.frame = CGRectMake(0, 0, ViewWidth, self.tableHeaderView.frame.size.height + webViewHeight);

    [self.tableView reloadData];
}
#pragma mark - XibFunction
//筛选button
- (IBAction)shaixuanBtnClicked:(UIButton *)sender {
    sender.selected = YES;
    self.selectBtn = sender;
    switch (sender.tag) {

    case 1: {
        self.typeStr = @"1";
        sender.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];
        self.youtuBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.chapingBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.haopingBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.youtuBtn.selected = NO;
        self.chapingBtn.selected = NO;
        self.haopingBtn.selected = NO;

    } break;
    case 2: {
        self.typeStr = @"2";

        sender.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];

        self.allBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.chapingBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.haopingBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.allBtn.selected = NO;
        self.chapingBtn.selected = NO;
        self.haopingBtn.selected = NO;
    } break;
    case 3: {
        self.typeStr = @"3";
        sender.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];
        self.allBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.chapingBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.youtuBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.youtuBtn.selected = NO;
        self.allBtn.selected = NO;
        self.chapingBtn.selected = NO;
    } break;
    case 4: {
        self.typeStr = @"4";
        sender.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];
        self.allBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.youtuBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.haopingBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:0.1];
        self.haopingBtn.selected = NO;
        self.youtuBtn.selected = NO;
        self.allBtn.selected = NO;
    } break;
    default:
        break;
    }

    [self refresh];
}
//选择规格
- (IBAction)selectGuigeBtnClicked:(UIButton *)sender {
    self.Block(@"", NO);
}
//选择品牌
- (IBAction)selectBandClick:(id)sender {
    self.Block(@"", NO);
}
//分享的点击
- (IBAction)shareBtnClick:(id)sender {

    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSString *token = [User getToken];

        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"商品详情" thumImage:[UIImage imageNamed:@"AppIcon"]];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@?id=%ld&token=%@",kShareGoods,(long)self.goodsId,token];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObject
                                    currentViewController:self
                                               completion:^(id data, NSError *error) {
                                                   if (error) {
                                                       NSLog(@"************Share fail with error %@*********", error);
                                                   } else {
                                                       [DZTools showOKHud:@"分享成功" delay:2];
                                                   }
                                               }];
    }];
}
//关注
- (IBAction)guanzhuBtnClick:(UIButton *)sender {
    //    kDianpuFollow
    sender.selected = !sender.selected;

    if (self.follow == 0 ) {
        NSDictionary *params = @{
            @"type": @"10",
            @"seller_id": @(self.mallId),
            @"seller_name": self.nameLabel.text,
            @"name": self.nameLabel.text,
            @"img": self.image,
            @"price": self.pricelabel.text,
            @"goods_id": @(self.goodsId)

        };
        [DZNetworkingTool postWithUrl:kDianpuFollow
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {

                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSDictionary *dict = responseObject[@"data"];
                    self.follow = [dict[@"follow_id"] intValue];
                    
                     [DZTools showOKHud:responseObject[@"msg"] delay:2];

                } else {
                    NSDictionary *dict = responseObject[@"data"];
                    self.follow = [dict[@"follow_id"] intValue];
                    [DZTools showText:responseObject[@"msg"] delay:2];
                    
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                
                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];

    } else {
        //取消关注
        NSDictionary *params = @{
            @"follow_id": @(self.follow)
        };
        [DZNetworkingTool postWithUrl:kCancelFollow params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.follow = 0;
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                
            }else
            {
                 self.follow = 0;
                [DZTools showText:responseObject[@"msg"] delay:2];
               
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
           
            [DZTools showNOHud:RequestServerError delay:2.0];
        } IsNeedHub:NO];
    }
    
   
    
}

@end
