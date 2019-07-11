//
//  StoreFocusListViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/29.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "StoreFocusListViewController.h"
#import "StoreFocusListCell.h"
#import "GuanzhuListModel.h"

@interface StoreFocusListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editingViewHeight;
@property (weak, nonatomic) IBOutlet UIView *editingView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property(nonatomic,strong)NSString *type;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation StoreFocusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"店铺关注";
    self.type=@"20";
    self.editingViewHeight.constant =  0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreFocusListCell" bundle:nil] forCellReuseIdentifier:@"StoreFocusListCell"];
    [self.tableView.mj_header beginRefreshing];
    
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteClick:) name:@"guanzhushanchu" object:nil];
}
- (void)deleteClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    
    if ([dic[@"item"] isEqualToString:@"批量删除"] ) {
        if (self.dataArray.count == 0) {
            return;
        }
        [self.tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
    }else{
        //        item.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
        
        [self showEitingView:NO];
    }
    
}
- (void)showEitingView:(BOOL)isShow{
    
    self.editingViewHeight.constant = isShow ? 45 : 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)refresh
{
//    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
-(void)loadMore{
//    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    NSDictionary *params = @{@"type":self.type,
                             @"lat":@([DZTools getAppDelegate].longitude),
                             @"lng":@([DZTools getAppDelegate].longitude)};
    [DZNetworkingTool postWithUrl:kFollowList params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
//            NSArray *array = dict[@"list"];
            
            for (NSDictionary *dict in array) {
                GuanzhuListModel *model = [GuanzhuListModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
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
    return 130;
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
    StoreFocusListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreFocusListCell" forIndexPath:indexPath];
    GuanzhuListModel *model = self.dataArray[indexPath.row];
    cell.starView.actualScore = model.star_class;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.seller_img] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.storeNameLabel.text = model.seller_name;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",model.distance/1000];
    cell.yimaiLabel.text = [NSString stringWithFormat:@"%d人已买",model.purchase];
    cell.goodsLabel.text = [NSString stringWithFormat:@"主营商品：%@",model.notice];
    cell.huodongLabel.text = model.sales;
    cell.peisongLabel.text = [NSString stringWithFormat:@"配送费:%@",model.express_price];
    
    cell.block = ^{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action){
                                                 }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     //删除
                                                     [self deleteDataWithId:[NSString stringWithFormat:@"%d",model.follow_id]];             }]];
        [self presentViewController:alertC animated:YES completion:nil];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - XibFunction


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
        }];
        
        //        NSString *zujiId=[self.dataArray componentsJoinedByString:@","];
        NSMutableArray *array=[NSMutableArray array];
        
        for (GuanzhuListModel *model  in self.dataArray) {
            [array addObject:@(model.follow_id)];
        }
        NSString *zujiId = [array componentsJoinedByString:@","];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action){
                                                 }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     [self deleteDataWithId:zujiId];
                                                     [self.dataArray removeObjectsAtIndexes:insets];
                                                     [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
                                                     
                                                 }]];
        [self presentViewController:alertC animated:YES completion:nil];
        

        /** 数据清空情况下取消编辑状态*/
        if (self.dataArray.count == 0) {
            NSDictionary *dict=@{@"title":@"批量删除"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refeashData" object:nil userInfo:dict];
            
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
            /** 带MJ刷新控件重置状态
             [self.tableView.footer resetNoMoreData];
             [self.tableView reloadData];
             */
        }
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        sender.selected=!sender.selected;
        if (sender.selected) {
            
            [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }];
            //            [sender setImage:[UIImage imageNamed:@"icon_Radio_pre"] forState:UIControlStateNormal];
            //            [sender setTitle:@"全选" forState:UIControlStateNormal];
        }else{
            [self.tableView reloadData];
            /** 遍历反选
             [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [self.tableView deselectRowAtIndexPath:obj animated:NO];
             }];
             */
            //            [sender setImage:[UIImage imageNamed:@"icon_Radio"] forState:UIControlStateNormal];
            //            [sender setTitle:@"全选" forState:UIControlStateNormal];
        }
        
        
    }
    
    
}

-(void)deleteDataWithId:(NSString *) zujiId{
    
    NSDictionary *dict=@{
                         @"follow_ids":zujiId,
                         @"type":self.type
                         };
    
    [DZNetworkingTool postWithUrl:kDeleteFollowMore params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            [self refresh];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}

@end
