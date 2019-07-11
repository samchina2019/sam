//
//  ShenheManagerViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ShenheManagerViewController.h"
#import "ShenheManagerCell.h"
#import "ShenheModel.h"
#import "ReLayoutButton.h"

@interface ShenheManagerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *shenheLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIView *shensuView;
@property (weak, nonatomic) IBOutlet UIButton *tongyiBtn;
@property (weak, nonatomic) IBOutlet UIButton *bohuiBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *liyouBtn;

@property (nonatomic, strong) NSArray *liyouArray;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic) int typeId;
@property (nonatomic, assign) int list_id;

@property (nonatomic) NSInteger page;
@end

@implementation ShenheManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.liyouArray = [NSArray arrayWithObjects:@"正常日工", @"上午计工", @"下午计工", @"不计工", @"按时计工", nil];
    self.typeId = 2;

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    [self.tableView registerNib:[UINib nibWithNibName:@"ShenheManagerCell" bundle:nil] forCellReuseIdentifier:@"ShenheManagerCell"];

    [self.tableView.mj_header beginRefreshing];
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
    NSDictionary *params = @{ @"group_id": @(self.group_id) };
    [DZNetworkingTool postWithUrl:kAbnormalAppealList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [self.dataArray removeAllObjects];
                NSArray *array = responseObject[@"data"];
                for (NSDictionary *dict in array) {
                    ShenheModel *model = [ShenheModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            } else {
//                [DZTools showNOHud:responseObject[@"msg"] delay:2];
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
    ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    return 165;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ShenheManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShenheManagerCell" forIndexPath:indexPath];
    ShenheModel *model = self.dataArray[indexPath.row];
    if ([self.audit_management isEqualToString:@"3"]) {
        cell.selected = YES;
    } else if ([self.audit_management isEqualToString:@"2"]) {
        cell.selected = NO;
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    cell.phoneLabel.text = [NSString stringWithFormat:@"%@", model.phone];
    cell.beizhuLabel.text = [NSString stringWithFormat:@"%@", model.remarks];
    cell.timeLabel.text = [NSString stringWithFormat:@"申请时间:%@", model.reason_time];
    //    if (indexPath.row==4) {
    //        [cell.stateLable setTextColor: [UIColor colorWithRed:250/255.0 green:84/255.0 blue:88/255.0 alpha:1.0]];
    //        [cell.stateLable setText:@"异常申请"];
    //    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShenheModel *model = self.dataArray[indexPath.row];
    self.list_id = model.list_id;
    self.shenheLabel.text = [NSString stringWithFormat:@"%@", model.remarks];
    self.shensuView.frame = self.view.bounds;
    [self.view addSubview:self.shensuView];
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否同意TA的申诉" preferredStyle:UIAlertControllerStyleAlert];
    //
    //    //增加取消按钮；
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"拒绝"
    //                                                        style:UIAlertActionStyleDefault
    //                                                      handler:^(UIAlertAction *_Nonnull action){
    //                                                          NSDictionary *dict=@{
    //                                                                               @"list_id":@(model.list_id),
    //                                                                               @"type":@(1)
    //                                                                               };
    //                                                          [self shenqingBtnClick:dict];
    //                                                      }]];
    //    //增加确定按钮；
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"通过"
    //                                                        style:UIAlertActionStyleDefault
    //                                                      handler:^(UIAlertAction *_Nonnull action) {
    //                                                          NSDictionary *dict=@{
    //                                                                               @"list_id":@(model.list_id),
    //                                                                               @"type":@(2)
    //                                                                               };
    //                                                          [self shenqingBtnClick:dict];
    //                                                      }]];
    //    [self presentViewController:alertController animated:true completion:nil];
}
//-(void)shenqingBtnClick:(NSDictionary *)dict{
//
//    [DZNetworkingTool postWithUrl:kAdminApply params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject[@"code"] intValue] ==SUCCESS) {
//            [DZTools showOKHud:responseObject[@"msg"] delay:2];
//            [self refresh];
//        }else{
//               [DZTools showNOHud:responseObject[@"msg"] delay:2];
//        }
//    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
//           [DZTools showNOHud:responseObject[@"msg"] delay:2];
//    } IsNeedHub:NO];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.001f;
}
#pragma mark - Xcode点击事件
//同意驳回的点击
- (IBAction)shensuBtnCLick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 1) {
        self.bohuiBtn.selected = NO;
        self.typeId = 2;
        //        self.
    } else if (sender.tag == 2) {
        self.tongyiBtn.selected = NO;
        self.typeId = 1;
    }
}
//理由按钮的点击
- (IBAction)liyouBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择理由" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.liyouArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.liyouArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertGangweiClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertGangweiClick:self.liyouArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertGangweiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.liyouArray.count) {
        [self.liyouBtn setTitle:self.liyouArray[rowInteger] forState:UIControlStateNormal];
        self.liyouBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//确定按钮的点击
- (IBAction)sureBtnClick:(id)sender {
    [self.shensuView removeFromSuperview];
    if (self.liyouBtn.titleLabel.text.length == 0) {
        [DZTools showNOHud:@"理由不能为空" delay:2];
        return;
    }
    NSDictionary *params = @{
        @"list_id": @(self.list_id),
        @"type": @(self.typeId),
        @"content": self.liyouBtn.titleLabel.text
    };
    [DZNetworkingTool postWithUrl:kAbnormalAppealList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self refresh];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//取消view
- (IBAction)cancelView:(id)sender {
    [self.shensuView removeFromSuperview];
}


@end
