//
//  JiFenStoreViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JiFenStoreViewController.h"
#import "ReLayoutButton.h"
#import "JiFenGoodsCell.h"
//#import "UITableView+JHNoData.h"
#import "JiFenHistoryPageViewController.h"
#import "WebViewViewController.h"
#import "MyJifenOrderListViewController.h"
#import "JiFenGoodsDetailViewController.h"
#import "JifenGoodsModel.h"

@interface JiFenStoreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *classTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *tuiJianBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jifenBtn;
@property (weak, nonatomic) IBOutlet UIButton *myOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *getJifenBtn;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *duihuanBtn;

@property (strong, nonatomic) NSMutableArray *classDataArray;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic) NSInteger selectIndex;
@property (nonatomic) NSInteger page;

@property(assign,nonatomic)int category_id;


@end

@implementation JiFenStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"积分商城";
    self.selectIndex=0;
    User *user=[User getUser];
    self.jifenLabel.text=[NSString stringWithFormat:@"%ld",user.score];
    

    UIImage *image1 = [UIImage imageNamed:@"jilu"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithImage:image1  style:UIBarButtonItemStyleDone target:self action:@selector(hostoryItemClicked)];
    UIImage *image2 = [UIImage imageNamed:@"wenhao"];
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *guize = [[UIBarButtonItem alloc] initWithImage:image2  style:UIBarButtonItemStyleDone target:self action:@selector(guizeItemClicked)];
    self.navigationItem.rightBarButtonItems = @[guize, history];
    
    self.myOrderBtn.layer.cornerRadius = 5;
    self.myOrderBtn.layer.borderColor = TabbarColor.CGColor;
    self.myOrderBtn.layer.borderWidth = 1;
    
    self.getJifenBtn.layer.cornerRadius = 5;
    self.getJifenBtn.layer.borderColor = TabbarColor.CGColor;
    self.getJifenBtn.layer.borderWidth = 1;
    
    self.classDataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self getClassDataArrayFromServer];
    
//    self.classTableView.jh_showNoDataEmptyView = YES;
//    self.classTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
//        NSLog(@"下拉刷新");
//        [self getClassDataArrayFromServer];
//    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        NSLog(@"上拉加载更多");
//        [self loadMore];
//    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"JiFenGoodsCell" bundle:nil] forCellReuseIdentifier:@"JiFenGoodsCell"];
    [self.tableView.mj_header beginRefreshing];
}
- (void)getClassDataArrayFromServer
{
//    kCategoryList
    
        [DZNetworkingTool postWithUrl:kCategoryList params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"];
//                if (isRefresh) {
                    [self.classDataArray removeAllObjects];
//                }
                for (NSDictionary *dict in array) {
                    [self.classDataArray addObject:dict];
                }
                [self.classTableView reloadData];
                if (self.classDataArray.count > 0) {
                    NSDictionary *dict=self.classDataArray[0];
                    self.category_id = [dict[@"category_id"] intValue];
                    [self refresh];
                }
               
            }else
            {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
           
            [DZTools showNOHud:RequestServerError delay:2.0];
        } IsNeedHub:NO];
 
}
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
//    kGoodsList
        NSDictionary *params = @{
                                 @"category_id":@(self.category_id),
                                 @"page":@(_page),
                                 @"limit":@(20)
                                 };
        [DZNetworkingTool postWithUrl:kGoodsList params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"];
                if(isRefresh){
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dict in array) {
                    JifenGoodsModel *model=[JifenGoodsModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                
                [self.tableView reloadData];
               
            }else
            {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
                  [self.dataArray removeAllObjects];
                  [self.tableView reloadData];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        } IsNeedHub:NO];
 
}

#pragma mark--tableview deleteGate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.classTableView) {
        return self.classDataArray.count;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        return 44;
    }else{
        return 105;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.classTableView) {
        return 0.01;
    }else{
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
//区头的字体颜色设置
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = UIColorFromRGB(0x333333);
    header.textLabel.font = [UIFont systemFontOfSize:16];
    header.contentView.backgroundColor = ViewBackgroundColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        static NSString *cellIdentifier = @"classCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSDictionary *dict=self.classDataArray[indexPath.row];
        NSString *name=dict[@"name"];
        cell.textLabel.text = name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (self.selectIndex == indexPath.row) {
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }else
        {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        }
        
        return cell;
    }else{
        JiFenGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JiFenGoodsCell" forIndexPath:indexPath];
        JifenGoodsModel *model=self.dataArray[indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        cell.nameLabel.text=model.goods_name;
        cell.priceLabel.text=[NSString stringWithFormat:@"市场价：%@元",model.line_price];
        if ([model.goods_price doubleValue] > 0) {
            cell.fujiaPriceLabel.text = [NSString stringWithFormat:@"+%@元",model.goods_price];
        }
        cell.jifenNumLabel.text=model.goods_score;
        cell.block = ^{
            
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.classTableView) {
        if (self.selectIndex != indexPath.row) {
            UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
            selectCell.textLabel.textColor = UIColorFromRGB(0x666666);
            selectCell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            self.selectIndex = indexPath.row;
            if (self.classDataArray.count>0) {
                NSDictionary *dict=self.classDataArray[indexPath.row];
                self.category_id=[dict[@"category_id"] intValue];
                [self refresh];
            }else{
                self.category_id=0;
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            }
            
            
        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.hidesBottomBarWhenPushed = YES;
         JifenGoodsModel *model=self.dataArray[indexPath.row];
        JiFenGoodsDetailViewController *viewController = [JiFenGoodsDetailViewController new];
        viewController.goodsId=model.goods_id;
        viewController.title=model.goods_name;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}
#pragma mark - XibFunction
//排序
- (IBAction)panxuBtnclicked:(UIButton *)sender {
    NSDictionary *dict=@{};
    sender.selected=!sender.selected;
    switch (sender.tag) {
        case 1://推荐排序
        {
            if (sender.selected) {
                dict=@{
                       @"category_id":@(self.category_id),
                       @"weigh":@(1),
                       @"page":@(_page),
                       @"limit":@(20)
                       
                       };
            }else{
                dict=@{
                       @"category_id":@(self.category_id),
                       @"weigh":@(0),
                       @"page":@(_page),
                       @"limit":@(20)
                       };
            }
            self.jifenBtn.selected = NO;
            self.duihuanBtn.selected=NO;
           
        }
            break;
        case 2://积分排序
        {
            if (sender.selected) {
                dict=@{
                       @"category_id":@(self.category_id),
                       @"score":@(1),
                       @"page":@(_page),
                       @"limit":@(20)
                       };
            }else{
                dict=@{
                       @"category_id":@(self.category_id),
                       @"score":@(0),
                       @"page":@(_page),
                       @"limit":@(20)
                       };
            }
            
            self.tuiJianBtn.selected=NO;
            self.duihuanBtn.selected=NO;
        }
            break;
        case 3://可兑换
        {
            if (sender.selected) {
                dict=@{
                       @"category_id":@(self.category_id),
                       @"score":@(1),
                       @"page":@(_page),
                       @"limit":@(20)
                       };
            }else{
                dict=@{
                       @"category_id":@(self.category_id),
                       @"score":@(0),
                       @"page":@(_page),
                       @"limit":@(20)
                       };
            }
            
            self.jifenBtn.selected=NO;
            self.tuiJianBtn.selected=NO;
        }
            break;
            
        default:
            break;
    }
    [DZNetworkingTool postWithUrl:kGoodsList params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
      
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in array) {
                JifenGoodsModel *model=[JifenGoodsModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
            
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
       
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
    
}
//我的订单
- (IBAction)myOrderBtnClicked:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MyJifenOrderListViewController *viewController = [MyJifenOrderListViewController new];
    
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//赚取积分
- (IBAction)getJiFenBtnClicked:(id)sender {
    
}
//历史交易记录
- (void)hostoryItemClicked {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    JiFenHistoryPageViewController *viewController = [JiFenHistoryPageViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//积分规则
- (void)guizeItemClicked {
    
    
        NSDictionary *dict=@{
                             @"keywords":@"Integral_rule"
                             };
        [DZNetworkingTool postWithUrl:kArticleInfo params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *temp=responseObject[@"data"];
                NSString *urlStr=[NSString stringWithFormat:@"%@",temp[@"url"]];
               
                self.hidesBottomBarWhenPushed = YES;
                WebViewViewController *viewController = [WebViewViewController new];
               
                viewController.urlStr = urlStr;
                viewController.titleStr = @"积分规则";
                [self.navigationController pushViewController:viewController animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            }else
            {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        } IsNeedHub:NO];

}


@end
