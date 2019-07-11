//
//  StoreDetailCommentViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreDetailCommentViewController.h"

#import "StoreDetailCommentCell.h"
#import "CailiaoViewCell.h"

#import "CmtDataModel.h"
#import "GoodsSkuModel.h"

@interface StoreDetailCommentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *youtuBtn;
@property (weak, nonatomic) IBOutlet UIButton *haopingBtn;
@property (weak, nonatomic) IBOutlet UIButton *chapingBtn;
///已选材料
@property (strong, nonatomic) IBOutlet UIView *yixuanCailiaoView;
///数字显示label
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
///材料单tableview
@property (weak, nonatomic) IBOutlet UITableView *cailiaodanTableview;

@property (strong, nonatomic) UIButton *selectBtn;
///类型
@property(nonatomic,strong)NSString *typeStr;

@property (nonatomic) NSInteger page;

@property (strong, nonatomic) NSMutableArray *dataArray;
//已选材料
@property(nonatomic,strong)NSArray *selectedCailiao;
///number数量
@property (nonatomic, assign) NSInteger number;


@end

@implementation StoreDetailCommentViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    //    注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"newCartViewShow1" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.typeStr=@"1";
    self.number = 0;
    self.selectBtn = self.allBtn;
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.selectedCailiao=[NSArray array];
    
    self.cailiaodanTableview.rowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreDetailCommentCell" bundle:nil] forCellReuseIdentifier:@"StoreDetailCommentCell"];
    [self.tableView.mj_header beginRefreshing];
    [self.cailiaodanTableview registerNib:[UINib nibWithNibName:@"CailiaoViewCell" bundle:nil] forCellReuseIdentifier:@"CailiaoViewCell"];
    self.cailiaodanTableview.separatorStyle = UITableViewCellSeparatorStyleNone;

}
#pragma mark – Network

- (void)refresh
{
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
-(void)loadMore{
    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    NSDictionary *dict=@{
                         @"seller_id":@(self.storeId),
                         @"page":@(_page),
                         @"type":self.typeStr
                         };
    NSLog(@"%@",dict);
    [DZNetworkingTool postWithUrl:kEvaluSelect
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                          [self.tableView.mj_header endRefreshing];
                          [self.tableView.mj_footer endRefreshing];
                          if ([responseObject[@"code"] intValue] == SUCCESS) {
                              if(isRefresh){
                                  [self.dataArray removeAllObjects];
                              }
                              NSDictionary *dict = responseObject[@"data"];
                              self.commentNumLabel.text=[NSString stringWithFormat:@"评价(%@)",dict[@"num"]];
                              [self.dataArray removeAllObjects];
                              NSArray *temp=dict[@"list"];
                              for (NSDictionary *dict in temp) {
                                  CmtDataModel *model=[CmtDataModel mj_objectWithKeyValues:dict];
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
  if (tableView == self.cailiaodanTableview) {
        if (self.selectedCailiao.count == 0) {
            UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.cailiaodanTableview.backgroundView = backgroundImageView;
            self.cailiaodanTableview.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.cailiaodanTableview.backgroundView = nil;
        }
        return self.selectedCailiao.count;
  }else{
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.tableView.backgroundView = backgroundImageView;
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.tableView.backgroundView = nil;
    }
    return self.dataArray.count;
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.cailiaodanTableview) {
        CailiaoViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CailiaoViewCell" forIndexPath:indexPath];
        GoodsSkuModel* cailiaomodel = self.selectedCailiao[indexPath.row];
        NSDictionary *dict=cailiaomodel.selectsGoodsDict;
        cell.nameLabel.text = dict[@"goods_name"];
        cell.pinpaiLabel.text = dict[@"pingPaiName"];
        cell.guigeLabel.text = dict[@"guigeName"];
        cell.ppnumBtn.currentNumber = cailiaomodel.number;
        cell.numBlock = ^(CGFloat num) {
            cailiaomodel.number = num;
        };
        return cell;
        
    }else{
    
    StoreDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreDetailCommentCell" forIndexPath:indexPath];
    CmtDataModel *model=self.dataArray[indexPath.row];

     cell.contentLabel.text = model.cmt_content;
        cell.timeLabel.text = model.createtime_text;
    
    cell.array=model.cmt_images;
   
    cell.starView.actualScore = [model.star intValue];
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ShenghuoquanModel *model = self.dataArray[indexPath.row];
//    self.hidesBottomBarWhenPushed = YES;
//    LifeCycleDetailViewController *viewController = [LifeCycleDetailViewController new];
//    viewController.zone_id = model.zone_id;
//    [self.navigationController pushViewController:viewController animated:YES];
//    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - Function

//实现方法
- (void)notification1:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.selectedCailiao = dic[@"data"];
 
    self.number = [dic[@"number"] integerValue];
    
     [self.cailiaodanTableview reloadData];
     [self.tableView reloadData];

}
#pragma mark - XibFunction

- (IBAction)shaixuanBtnClicked:(UIButton *)sender {
    
    sender.selected=YES;
  
    switch (sender.tag) {
            
        case 1: {
            self.typeStr=@"1";
          sender.backgroundColor= [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0];
            self.youtuBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
             self.chapingBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
              self.haopingBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.youtuBtn.selected = NO;
            self.chapingBtn.selected = NO;
            self.haopingBtn.selected=NO;
            
        } break;
        case 2: {
            self.typeStr=@"2";
            sender.backgroundColor= [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0];
            self.allBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.chapingBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.haopingBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.allBtn.selected = NO;
            self.chapingBtn.selected = NO;
            self.haopingBtn.selected=NO;
        } break;
        case 3: {
            self.typeStr=@"3";
            sender.backgroundColor= [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0];
            self.allBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.chapingBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.youtuBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.youtuBtn.selected = NO;
            self.allBtn.selected = NO;
            self.chapingBtn.selected=NO;
        } break;
        case 4: {
            self.typeStr=@"4";
            sender.backgroundColor= [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0];
            self.allBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.youtuBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.haopingBtn.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:0.1];
            self.haopingBtn.selected = NO;
            self.youtuBtn.selected = NO;
            self.allBtn.selected=NO;
        } break;
        default:
            break;
    }
     [self refresh];
}
- (IBAction)gouwucheBtnClick:(id)sender {
    self.yixuanCailiaoView.frame = [DZTools getAppWindow].bounds;
    
    [[DZTools getAppWindow] addSubview:self.yixuanCailiaoView];
    
}
- (IBAction)shengchengOrderClick:(id)sender {
    
    GoodsSkuModel *model=self.selectedCailiao[0];
    NSDictionary *dict = model.selectsGoodsDict;
    NSDictionary *params = @{
                             @"goods_id": dict[@"goods_id"],
                             @"goods_num": @(model.number),
                             @"goods_sku_id":dict[@"goods_sku_id"]
                             };
    
    [DZNetworkingTool postWithUrl:kAddCart
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
//
                                  self.selectedCailiao = nil;
                                  self.numberLabel.text = 0;
                                  [self.view layoutIfNeeded];
                                  [self.cailiaodanTableview reloadData];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"cartXiaoxi" object:nil userInfo:dict];
                                  self.tabBarController.selectedIndex = 2;
                                  [self.navigationController popToRootViewControllerAnimated:NO];
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                  
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                               
                           }
                        IsNeedHub:NO];
//    [self.specArray removeAllObjects];
    [self.yixuanCailiaoView removeFromSuperview];
}
- (IBAction)cancelCailiaocheClick:(id)sender {
    [self.yixuanCailiaoView removeFromSuperview];
    
}
#pragma mark – 懒加载
- (void)setNumber:(NSInteger)number
{
    _number = number;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_number];
    if (number == 0) {
        self.numberLabel.hidden = YES;
    } else {
        self.numberLabel.hidden = NO;
    }
}
@end
