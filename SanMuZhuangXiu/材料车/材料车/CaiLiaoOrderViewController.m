//
//  CaiLiaoOrderViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CaiLiaoOrderViewController.h"
#import "CaiLiaoOrderListCell.h"
#import "CaiLiaoDanDetailViewController.h"
#import "CartListModel.h"
#import "HebingCartModel.h"
#import "ReLayoutButton.h"
#import "AddressManagerViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AddressModel.h"

@interface CaiLiaoOrderViewController () <CLLocationManagerDelegate>
// 定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UITextField *cailiaoNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *gongdiTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *addressBtn;
///合并按钮
@property (weak, nonatomic) IBOutlet UIButton *hebingButton;

//编辑地址
@property (strong, nonatomic) IBOutlet UIScrollView *AddressScrollView;

@property (nonatomic) NSInteger page;
@property (nonatomic, assign) int addressId;
@property (nonatomic, assign) BOOL isSelectAll;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedCellArray;
@property (nonatomic, strong) NSMutableArray *stuffArray;

@end

@implementation CaiLiaoOrderViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isSelectAll = NO;
    if ([DZTools islogin]) {
        [self getDataArrayFromServerIsRefresh:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.stuffArray = [NSMutableArray array];
    self.selectedCellArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYYMMddHHmm"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    self.cailiaoNameTextField.placeholder = currentTimeString;

    self.tableView.backgroundColor = [UIColor whiteColor];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];

    [self.tableView registerNib:[UINib nibWithNibName:@"CaiLiaoOrderListCell" bundle:nil] forCellReuseIdentifier:@"CaiLiaoOrderListCell"];
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadAddress {
    NSDictionary *params = @{
        @"token": [User getToken],
    };
    [DZNetworkingTool getWithUrl:kAddressLists
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                for (NSDictionary *addDict in dict[@"list"]) {
                    AddressModel *model = [AddressModel mj_objectWithKeyValues:addDict];
                    if ([model.last_time isEqualToString:@"1"]) {
                        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
                        self.addressId = model.address_id;

                        if (self.addressLabel.text.length == 0) {
                            [self.addressBtn setTitle:@"请选择工地地址" forState:UIControlStateNormal];
                            //                        self.addressBtn.userInteractionEnabled=YES;
                            [self.addressBtn setImage:[UIImage imageNamed:@"xiasanjiao"] forState:UIControlStateNormal];
                        } else {
                            [self.addressBtn setImage:[UIImage imageNamed:@"xiasanjiao"] forState:UIControlStateNormal];
                            //                        self.addressBtn.userInteractionEnabled=NO;
                            [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail] forState:UIControlStateNormal];
                        }
                    }
                }

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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

    [DZNetworkingTool postWithUrl:kGetcartLists
        params:nil
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
                //                [self.dataArray removeAllObjects];
                NSArray *array = dict[@"lists"];
                if (array.count > 0) {
                    for (NSDictionary *dict in array) {

                        CartListModel *model = [CartListModel mj_objectWithKeyValues:dict];
                        [self.dataArray addObject:model];
                    }
                    [self.tableView reloadData];
                }
            } else {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
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
    if (self.dataArray.count <= 1) {
        self.selectAllBtn.hidden = YES;
        self.hebingButton.hidden = YES;
    }else{
        self.selectAllBtn.hidden = NO;
        self.hebingButton.hidden = NO;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 190;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CaiLiaoOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaiLiaoOrderListCell" forIndexPath:indexPath];

    CartListModel *model = self.dataArray[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
        cell.stateLabel.text = @"(未采购)";
    } else if ([model.status isEqualToString:@"3"]) {
        cell.stateLabel.text = @"(已采购)";
    }
    if (model.sharename != nil && model.sharename.length > 0) {
        cell.shareByLabel.text = [NSString stringWithFormat:@"%@", model.sharename];
    } else {
        cell.shareByLabel.text = [NSString stringWithFormat:@"%@", model.share];
    }

    cell.nameLabel.text = model.name;
    cell.timeLabel.text = model.updatetime;
    cell.classNumLabel.text = [NSString stringWithFormat:@"材料种类：%ld种", model.stuff_count];
    cell.numLabel.text = [NSString stringWithFormat:@"数量：%ld种", model.stuff_number];

    if (self.isSelectAll) {
        cell.selectBtn.selected = YES;

    } else {

        cell.selectBtn.selected = NO;
    }

    cell.selectBlock = ^(BOOL isSelected) {
        if (isSelected) {
            [self.selectedCellArray addObject:@(model.stuff_cart_id)];

        } else {

            [self.selectedCellArray removeObject:@(model.stuff_cart_id)];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;
    CaiLiaoDanDetailViewController *viewController = [CaiLiaoDanDetailViewController new];
    CartListModel *model = self.dataArray[indexPath.row];
    viewController.stuff_cart_id = [NSString stringWithFormat:@"%ld", (long) model.stuff_cart_id];
    [self.parentViewController.parentViewController.navigationController pushViewController:viewController animated:YES];
    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = NO;
}
#pragma mark – UI
#pragma mark – Network

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTF resignFirstResponder];
    if (self.searchTF.text.length == 0) {
        [DZTools showNOHud:@"搜索内容不能为空" delay:2];
    }
    NSDictionary *dict = @{
                           @"name": self.searchTF.text
                           };
    [DZNetworkingTool postWithUrl:kGetcartLists
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict = responseObject[@"data"];
                                  
                                  [self.dataArray removeAllObjects];
                                  
                                  NSArray *array = dict[@"lists"];
                                  if (array.count > 0) {
                                      for (NSDictionary *dict in array) {
                                          
                                          CartListModel *model = [CartListModel mj_objectWithKeyValues:dict];
                                          [self.dataArray addObject:model];
                                      }
                                      
                                      [self.tableView reloadData];
                                  }
                                  
                              } else {
                                  [self.dataArray removeAllObjects];
                                  [self.tableView reloadData];
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
    return YES;
}
#pragma mark - XibFunction
- (IBAction)addressBtnClick:(id)sender {

    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;
    AddressManagerViewController *vc = [[AddressManagerViewController alloc] init];
    vc.block = ^(AddressModel *_Nonnull model) {
        self.addressId = model.address_id;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
        [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail] forState:UIControlStateNormal];
        [self.addressBtn setImage:[UIImage imageNamed:@"xiasanjiao"] forState:UIControlStateNormal];

    };
    [self.navigationController pushViewController:vc animated:YES];
    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = NO;
}
//合并
- (IBAction)hebingBtnClicked:(id)sender {

    __block int numberTotal = 0;

    NSString *string = [self.selectedCellArray componentsJoinedByString:@","];
    if (string.length == 0) {
        [DZTools showNOHud:@"请选择两种及以上材料才能合并" delay:2];
        return;
    }
    NSDictionary *dict = @{
        @"stuff_cart_id": string
    };

    [DZNetworkingTool postWithUrl:kCheckCart
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                NSDictionary *dict = responseObject[@"data"][@"data"];
                numberTotal = [dict[@"echoesNumber"] intValue];
                NSArray *array = dict[@"stuff"];
                [self.stuffArray removeAllObjects];
                for (NSDictionary *cartDict in array) {
                    [self.stuffArray addObject:cartDict];
                }

                //三元运算
                NSString *message = numberTotal > 0 ? [NSString stringWithFormat:@"有%d种材料重复，是否全部合并?", numberTotal] : @"是否确定合并?";

                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"合并" message:message preferredStyle:UIAlertControllerStyleAlert];

                [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action){

                                                         }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {

                                                             [self isHebing];
                                                         }]];
                [self presentViewController:alertC animated:YES completion:nil];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)isHebing {

    self.AddressScrollView.frame  = CGRectMake(0, 0, ViewWidth, ViewHeight);
    [self.scrollView addSubview:self.AddressScrollView];
    [[DZTools getAppWindow] addSubview:self.scrollView];
 
}
//全选
- (IBAction)selectAllBtnClicked:(id)sender {
    self.selectAllBtn.selected = !self.selectAllBtn.selected;

    if (self.selectAllBtn.selected) {
        self.isSelectAll = YES;
        for (CartListModel *temp in self.dataArray) {
            [self.selectedCellArray addObject:@(temp.stuff_cart_id)];
        }
    } else {
        [self.selectedCellArray removeAllObjects];
        self.isSelectAll = NO;
    }
    [self.tableView reloadData];
}
//删除
- (IBAction)deleteBtnClicked:(id)sender {

    NSString *string = [self.selectedCellArray componentsJoinedByString:@","];
    if (string.length == 0) {
        [DZTools showNOHud:@"请先选择材料车里的材料" delay:2];
        return;
    }

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除" message:@"您确定删除材料车里的材料吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *_Nonnull action){

                                             }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                               style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction *_Nonnull action) {

                                                 NSString *string = [self.selectedCellArray componentsJoinedByString:@","];
                                                 NSDictionary *dict = @{
                                                     @"stuff_cart_ids": string
                                                 };
                                                 [DZNetworkingTool postWithUrl:kDeleteCart
                                                     params:dict
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

                                             }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)addressCancelClick:(id)sender {
    [self.scrollView removeFromSuperview];
//    [self.AddressScrollView removeFromSuperview];
}
- (IBAction)sureHebingClick:(id)sender {
    [self.scrollView removeFromSuperview];
//    [self.AddressScrollView removeFromSuperview];
    
    if (self.cailiaoNameTextField.text.length == 0) {
        self.cailiaoNameTextField.text = self.cailiaoNameTextField.placeholder;
    }

    //    double latitude = [DZTools getAppDelegate].latitude;
    //    double longitude = [DZTools getAppDelegate].longitude;
    NSString *string = [self.selectedCellArray componentsJoinedByString:@","];
    //kMergeCart
    NSDictionary *dict = @{
        @"stuff_cart_id": string,
        @"name": self.cailiaoNameTextField.text,
        @"stuff": [self.stuffArray mj_JSONString]
    };
    [DZNetworkingTool postWithUrl:kMergeCart
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.selectedCellArray removeAllObjects];

            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                self.isSelectAll = NO;
                self.selectAllBtn.selected = NO;
                //                [self refresh];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            [self refresh];
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [self.selectedCellArray removeAllObjects];
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
    [self.AddressScrollView removeFromSuperview];
}

#pragma mark – 懒加载
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        _scrollView.contentSize = CGSizeMake(ViewWidth, ViewHeight);
    }
    return _scrollView;
}
@end
