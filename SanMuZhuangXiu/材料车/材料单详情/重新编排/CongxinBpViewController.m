//
//  CongxinBpViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CongxinBpViewController.h"
#import "CailaodanEditCell.h"
#import "CaiLiaoDanDetailHeaderView.h"
#import "CaiLiaoDanDetailViewController.h"
#import "MBProgressHUD.h"
#import "CaiLiaoFenLeiViewController.h"
#import "BaojiadanDetailViewController.h"
#import "CaiLiaoOrderViewController.h"

#import "PinpaiModel.h"
#import "EditSpecView.h"
#import "SpecGuigeModel.h"
#import "GuigeModel.h"
#import "CartOrdeInfoModel.h"
#import "StuffInfoModel.h"

@interface CongxinBpViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *xiugaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *gongZhongLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *xinzengBtn;

@property (nonatomic, strong) StuffInfoModel *stuModel;
@property (nonatomic, strong) EditSpecView *editSpecView;

@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) NSString *addressStr;

@property (strong, nonatomic) NSMutableArray *deleteArray;
@property (strong, nonatomic) NSMutableArray *pinpaiArray;
@property (nonatomic, strong) NSMutableArray *sectionArry;
@property (nonatomic, strong) NSArray *selectSpecData;
@property (nonatomic, strong) NSMutableArray *selectGuigeArray;
@property (nonatomic, strong) NSMutableArray *guigeArray;

@property (nonatomic, assign) NSInteger numberStr;
@property (nonatomic, assign) NSInteger stuff_data_id;
@property (nonatomic, assign) NSInteger stuff_id;

@end

@implementation CongxinBpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"材料单详情";
    
    [self initData];
    
    self.nameTextField.userInteractionEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self getDataArrayFMDB];
    
    [self XinzengBtnInit];
    [self initTableView];

}
#pragma mark – UI

- (void)initTableView {
    self.tableHeaderView.frame = CGRectMake(0, 0, ViewWidth, 110);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableFooterView.frame = CGRectMake(0, 0, ViewWidth, 100);
    self.tableView.tableFooterView = self.tableFooterView;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.rowHeight = 110;
    [self.tableView registerNib:[UINib nibWithNibName:@"CailaodanEditCell" bundle:nil] forCellReuseIdentifier:@"CailaodanEditCell"];
}
#pragma mark – xinzengBtn

- (void)XinzengBtnInit {
    
    //设置边框的颜色
    [self.xinzengBtn.layer setBorderColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor];
    
    //设置边框的粗细
    [self.xinzengBtn.layer setBorderWidth:1.0];
    
    //设置圆角的半径
    [self.xinzengBtn.layer setCornerRadius:3];
    
    //切割超出圆角范围的子视图
    self.xinzengBtn.layer.masksToBounds = YES;
}
#pragma mark – Network

- (void)getDataArrayFMDB {

    NSDictionary *dict = @{};
    if (self.isFromBaojiadan) {
        dict = @{
            @"stuff_cart_id": self.stuff_cart_id,
            @"data_id": self.data_id
        };
    } else {
        dict = @{
            @"stuff_cart_id": self.stuff_cart_id
        };
    };

    [DZNetworkingTool postWithUrl:kGetcartDetail
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                NSDictionary *dictBasic = dict[@"lists"];
                self.addressStr = dictBasic[@"address"];
                NSString *name = dictBasic[@"stuff_work_name"];
                
                if ([name isKindOfClass:[NSNull class]]) {
                    self.gongZhongLabel.text = @"测试数据";
                } else {
                    self.gongZhongLabel.text = name;
                }
                NSDictionary *stuffCartDict = dictBasic[@"stuff_cart_info"];
                self.nameTextField.text = stuffCartDict[@"stuff_cart_name"];
                self.nameStr = stuffCartDict[@"stuff_cart_name"];
                [self.sectionArry removeAllObjects];
                
                NSArray *array = dict[@"lists"][@"info"];
                if (array.count > 0) {
                    for (NSDictionary *dict in array) {
                        CartOrdeInfoModel *model = [CartOrdeInfoModel mj_objectWithKeyValues:dict];

                        [self.sectionArry addObject:model];
                    }
                    [self.tableView reloadData];
                }

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    CartOrdeInfoModel *model = self.sectionArry[section];

    return model.stuff_info.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CaiLiaoDanDetailHeaderView *view = [[CaiLiaoDanDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
    CartOrdeInfoModel *model = self.sectionArry[section];

    view.nameLabel.text = model.stuff_category_name;
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CailaodanEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CailaodanEditCell"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    CartOrdeInfoModel *model = self.sectionArry[indexPath.section];

    NSMutableArray *cellArray = [NSMutableArray array];
    [cellArray removeAllObjects];
    for (NSDictionary *dict in model.stuff_info) {
        StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
        [cellArray addObject:stuModel];
    }

    StuffInfoModel *stuModel = cellArray[indexPath.row];

    cell.nameLabel.text = stuModel.stuff_name;
    if ([stuModel.stuff_brand_name isKindOfClass:[NSNull class]]) {
        [cell.pinpaiBtn setTitle:@"没有数据" forState:UIControlStateNormal];
    } else {
        [cell.pinpaiBtn setTitle:[NSString stringWithFormat:@" %@ ", stuModel.stuff_brand_name] forState:UIControlStateNormal];
    }

    if (stuModel.selectsSpecDict.count == 0) {
        if ([stuModel.stuff_spec_name isKindOfClass:[NSNull class]]) {
            [cell.guigeBtn setTitle:@"没有数据" forState:UIControlStateNormal];
        } else {
            [cell.guigeBtn setTitle:[NSString stringWithFormat:@" %@ ", stuModel.stuff_spec] forState:UIControlStateNormal];
        }
    } else {

        [cell.guigeBtn setTitle:[NSString stringWithFormat:@" %@ ", stuModel.selectsSpecDict[@"name"]] forState:UIControlStateNormal];
    }

    cell.numberBtn.currentNumber = stuModel.number;

    cell.moreBlock = ^{
        [cellArray removeObjectAtIndex:indexPath.row];
        if (cellArray.count == 0) {
            [self.sectionArry removeObjectAtIndex:indexPath.section];
        } else {

            CartOrdeInfoModel *model1 = self.sectionArry[indexPath.section];
            model1.stuff_info = cellArray;

            [self.sectionArry replaceObjectAtIndex:indexPath.section withObject:model1];
        }

        [self.deleteArray addObject:@(stuModel.stuff_data_id)];
        [self.tableView reloadData];

    };
    //品牌
    __weak typeof(CailaodanEditCell *) weakself = cell;
    cell.pinpaiBlock = ^{

        self.index = indexPath;
        self.stuff_id = model.stuff_id;
        [self.pinpaiArray removeAllObjects];
        if (stuModel.brand_list.count == 0) {

        } else {
            NSArray *array = stuModel.brand_list;
            for (NSDictionary *dict in array) {
                PinpaiModel *model = [PinpaiModel mj_objectWithKeyValues:dict];
                [self.pinpaiArray addObject:model];
            }
        }
        [self alertPinpaiViewWithcellView:weakself];

    };
    cell.guigeBlock = ^{

        self.editSpecView = nil;

        self.index = indexPath;

        self.stuModel = stuModel;
        [self.guigeArray removeAllObjects];

        if (stuModel.spec_list.count == 0) {

        } else {
            NSArray *guiTempArray = stuModel.spec_list;

            for (NSDictionary *guigeDict in guiTempArray) {
                GuigeModel *guigeModel = [GuigeModel mj_objectWithKeyValues:guigeDict];

                [self.guigeArray addObject:guigeModel];
            }
        }

        self.editSpecView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        self.editSpecView.dataArray = self.guigeArray;
        [self.editSpecView.guigeView reloadData];
        [[DZTools getAppWindow] addSubview:self.editSpecView];

    };
    cell.numBlock = ^(CGFloat num) {

        //  数量的变化
        weakself.numberBtn.currentNumber = num;

        stuModel.number = num;

        CartOrdeInfoModel *model1 = self.sectionArry[indexPath.section];
        [cellArray replaceObjectAtIndex:indexPath.row withObject:stuModel];

        model1.stuff_info = cellArray;

        [self.sectionArry replaceObjectAtIndex:indexPath.section withObject:model1];

    };
    return cell;
}
#pragma mark – UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.nameTextField resignFirstResponder];
    
    if ([self.nameTextField.text isEqualToString:self.nameStr]) {
        [DZTools showNOHud:@"材料单名称未修改" delay:2];
        return NO;
    }
    if (self.nameTextField.text.length == 0) {
        [DZTools showNOHud:@"料单名称不能为空" delay:2];
        return NO;
    }
    //        kUpdateCartname
    NSDictionary *dict = @{
                           @"stuff_cart_ids": self.stuff_cart_id,
                           @"name": self.nameTextField.text
                           
                           };
    [DZNetworkingTool postWithUrl:kUpdateCartname
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  //                NSDictionary *dict=responseObject[@"data"];
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  self.xiugaiBtn.selected = NO;
                                  self.nameTextField.userInteractionEnabled = NO;
                                  [self.view layoutIfNeeded];
                                  [self getDataArrayFMDB];
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:responseObject[@"msg"] delay:2];
                           }
                        IsNeedHub:NO];
    
    return YES;
}

#pragma mark - Function
-(void)initData{
    
    self.deleteArray = [NSMutableArray array];
    self.pinpaiArray = [NSMutableArray array];
    self.guigeArray = [NSMutableArray array];
    self.sectionArry = [NSMutableArray array];
    self.selectSpecData = [NSArray array];
    self.selectGuigeArray = [NSMutableArray array];
    self.numberStr = 1;
}
//        添加品牌
- (void)alertPinpaiViewWithcellView:(CailaodanEditCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择品牌类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.pinpaiArray.count; i++) {
        PinpaiModel *typeModel = self.pinpaiArray[i];

        [alert addAction:[UIAlertAction actionWithTitle:typeModel.name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertXinziClick:i intoCell:cell];
                                                }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertXinziClick:self.pinpaiArray.count intoCell:cell];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertXinziClick:(NSInteger)rowInteger intoCell:(CailaodanEditCell *)cell;
{

    if (rowInteger < self.pinpaiArray.count) {

        PinpaiModel *typeModel = self.pinpaiArray[rowInteger];

        [cell.pinpaiBtn setTitle:typeModel.name forState:UIControlStateNormal];

        NSMutableArray *cellArray = [NSMutableArray array];
        [cellArray removeAllObjects];
        CartOrdeInfoModel *model = self.sectionArry[self.index.section];
        for (NSDictionary *dict in model.stuff_info) {
            StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
            [cellArray addObject:stuModel];
        }

        StuffInfoModel *stuModel = cellArray[self.index.row];
        stuModel.stuff_brand_name = typeModel.name;
        stuModel.stuff_brand_id = typeModel.stuff_brand_id;

        [cellArray replaceObjectAtIndex:self.index.row withObject:stuModel];
        CartOrdeInfoModel *model1 = self.sectionArry[self.index.section];

        model1.stuff_info = cellArray;

        [self.sectionArry replaceObjectAtIndex:self.index.section withObject:model1];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadPinpaiDataWithCell:(CailaodanEditCell *)cell {
    //    kBrandList
    NSDictionary *dict = @{
        @"stuff_id": @(self.stuff_id)
    };

    [DZNetworkingTool postWithUrl:kBrandList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [self.pinpaiArray removeAllObjects];
                NSArray *array = responseObject[@"data"][@"lists"];
                for (NSDictionary *dict in array) {
                    PinpaiModel *model = [PinpaiModel mj_objectWithKeyValues:dict];
                    [self.pinpaiArray addObject:model];
                }
                //        添加品牌
                [self alertPinpaiViewWithcellView:cell];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
-(void)editCailiaodanWithStr:(NSString *)name{
    
    if ([name isEqualToString:self.nameStr]) {
        [DZTools showNOHud:@"材料单名称未修改" delay:2];
        return ;
    }
    
    NSDictionary *dict = @{
                           @"stuff_cart_ids": @(self.stuff_id),
                           @"name": name
                           
                           };
    [DZNetworkingTool postWithUrl:kUpdateCartname
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  //                NSDictionary *dict=responseObject[@"data"];
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  self.xiugaiBtn.selected = NO;
                                  self.nameTextField.userInteractionEnabled = NO;
                                  [self.view layoutIfNeeded];
                                  [self getDataArrayFMDB];
                                  
                                  [self getDataArrayFMDB];
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:responseObject[@"msg"] delay:2];
                           }
                        IsNeedHub:NO];
    
}
#pragma mark – XibFunction
//编辑材料单名称
- (IBAction)EditBtnClick:(UIButton *)sender {

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"修改材料单名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertC addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.frame = CGRectMake(15, 64, 240, 30);
        textField.text = self.nameStr;
        textField.placeholder = @"请输入材料单名称";
        
    }];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *_Nonnull action){
                                                 
                                             }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                               style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction *_Nonnull action) {
                                                 UITextField *textField = alertC.textFields.firstObject;
                                                 if (textField.text.length == 0) {
                                                     [DZTools showNOHud:@"材料单名称不能为空" delay:2.0];
                                                     return;
                                                 }
                                                 [self editCailiaodanWithStr:textField.text];
                                             }]];
    [self presentViewController:alertC animated:YES completion:nil];
}


//新增材料
- (IBAction)xinzengBtnClick:(id)sender {

    CaiLiaoFenLeiViewController *vc = [[CaiLiaoFenLeiViewController alloc] init];
    CartOrdeInfoModel *cartModel = [CartOrdeInfoModel new];
    vc.stuffCartId = self.stuff_cart_id;
    vc.isFromEdit = YES;
    StuffInfoModel *stuModel = [[StuffInfoModel alloc] init];

    vc.change = ^(NSArray *array) {
        for (StuffListModel *model in array) {
            NSDictionary *dict = model.selectBrandDict;

            if ([dict[@"name"] isKindOfClass:[NSNull class]]) {
                stuModel.stuff_brand_name = @"没有数据";
            } else {
                stuModel.stuff_brand_name = dict[@"name"];
            }
            stuModel.stuff_brand_id = [dict[@"stuff_brand_id"] intValue];
            //赋值
            NSDictionary *speDict = model.selectsSpecDict;

            stuModel.stuff_spec_id = speDict[@"stuff_spec_id"];
            stuModel.selectsSpecDict = model.selectsSpecDict;
            if ([speDict[@"name"] isKindOfClass:[NSNull class]]) {
                stuModel.stuff_spec_name = @"没有数据";
            } else {
                stuModel.stuff_spec_name = speDict[@"name"];
            }
            stuModel.stuff_id = (int) model.stuff_id;
            stuModel.number = model.number;
            stuModel.stuff_name = model.stuff_name;
            stuModel.spec_list = model.spec;
            stuModel.brand_list = model.brand;
            NSDictionary *stuDict = [stuModel mj_keyValues];
            cartModel.stuff_info = @[stuDict];
            cartModel.stuff_category_name = @"新增";
            //添加到数组中
            [self.sectionArry addObject:cartModel];
        }
        [self.tableView reloadData];
    };

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - finish
- (IBAction)finishBtnClick:(id)sender {

    // 1.弹框提醒

    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"编辑完成，请选择保存方式" preferredStyle:UIAlertControllerStyleAlert];
    //添加点击事件
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"另存材料名"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           //
                                                           [self renameFinish];

                                                       }];

    [alert addAction:sureAction];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"覆盖原材料单"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *_Nonnull action) {

                                                       //设置字体颜色
                                                       [action setValue:[UIColor redColor] forKey:@"titleTextColor"];
                                                       //        [self.navigationController popViewControllerAnimated:YES];
                                                       [self fugaiCailiaodan];

                                                   }];
    [alert addAction:action];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark--重新命名提交订单
- (void)renameFinish {
    //#warning 信息有调整

    NSMutableArray *tempArray = [NSMutableArray array];

    for (CartOrdeInfoModel *cartDict in self.sectionArry) {
        for (NSDictionary *dict in cartDict.stuff_info) {
            StuffInfoModel *model = [StuffInfoModel mj_objectWithKeyValues:dict];
            if (model.stuff_brand_name.length == 0) {
                [DZTools showNOHud:@"品牌不能为空" delay:2];
                return;
            }
            if (model.selectsSpecDict.count == 0) {
                [tempArray addObject:@{
                    @"number": @(model.number),
                    @"stuff_id": @(model.stuff_id),
                    @"stuff_name": model.stuff_name,
                    @"stuff_brand_id": @(model.stuff_brand_id) == nil ? @"" : @(model.stuff_brand_id),
                    @"stuff_brand_name": model.stuff_brand_name == nil ? @"" : model.stuff_brand_name,
                    @"stuff_spec_id": model.stuff_spec_id == nil ? @"" : model.stuff_spec_id,
                }];
            } else {
                [tempArray addObject:@{
                    @"number": @(model.number),
                    @"stuff_id": @(model.stuff_id),
                    @"stuff_name": model.stuff_name,
                    @"stuff_brand_id": @(model.stuff_brand_id) == nil ? @"" : @(model.stuff_brand_id),
                    @"stuff_brand_name": model.stuff_brand_name == nil ? @"" : model.stuff_brand_name,
                    @"stuff_spec_id": model.selectsSpecDict[@"stuff_spec_id"] == nil ? @"" : model.selectsSpecDict[@"stuff_spec_id"],
                }];
            }
        }
    }

    NSDictionary *dict = @{
        @"name": self.nameTextField.text,
        @"stuff": [tempArray mj_JSONString],

    };
    NSLog(@"%@", dict);

    [DZNetworkingTool postWithUrl:kAddStuffCart
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                if (self.isFromBaojiadan) {

                    NSArray *viewControllers = self.navigationController.viewControllers;

                    [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                                      usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                      //从BaojiadanDetailViewController进入
                      if ([obj isKindOfClass:[BaojiadanDetailViewController class]]) {
                          BaojiadanDetailViewController *vc = (BaojiadanDetailViewController *) obj;
                          vc.sx = @"1";
                          [self.navigationController popViewControllerAnimated:YES];

                          *stop = YES;
                      }
                  }];

                } else {

                    //objectAtIndex后面的参数就是你想要返回的控制器在navigationController.viewControllers的下标
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

                    //CaiLiaoOrderViewController是指定的要返回的控制器
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[CaiLiaoOrderViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            NSLog(@"********%@", responseObject);
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark-- 覆盖原来订单名称
- (void)fugaiCailiaodan {

    NSMutableArray *tempArray = [NSMutableArray array];
    for (CartOrdeInfoModel *model in self.sectionArry) {
        for (NSDictionary *dict in model.stuff_info) {
            StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
            if (stuModel.stuff_brand_name.length == 0) {
                [DZTools showNOHud:@"品牌不能为空" delay:2];
                return;
            }
            if (stuModel.selectsSpecDict.count != 0) {
                [tempArray addObject:@{
                    @"stuff_data_id": @(stuModel.stuff_data_id),
                    @"number": @(stuModel.number),
                    @"stuff_id": @(stuModel.stuff_id),
                    @"stuff_name": stuModel.stuff_name,
                    @"stuff_brand_id": @(stuModel.stuff_brand_id) == nil ? @"" : @(stuModel.stuff_brand_id),
                    @"stuff_brand_name": stuModel.stuff_brand_name == nil ? @"" : stuModel.stuff_brand_name,
                    @"stuff_spec_id": stuModel.selectsSpecDict[@"stuff_spec_id"],
                    @"stuff_spec_name": stuModel.selectsSpecDict[@"name"] == nil ? @"" : stuModel.selectsSpecDict[@"name"]
                }];
            } else {
                [tempArray addObject:@{

                    @"stuff_data_id": @(stuModel.stuff_data_id),
                    @"number": @(stuModel.number),
                    @"stuff_id": @(stuModel.stuff_id),
                    @"stuff_name": stuModel.stuff_name,
                    @"stuff_brand_id": @(stuModel.stuff_brand_id) == nil ? @"" : @(stuModel.stuff_brand_id),
                    @"stuff_brand_name": stuModel.stuff_brand_name == nil ? @"" : stuModel.stuff_brand_name,
                    @"stuff_spec_id": stuModel.stuff_spec_id == nil ? @"" : stuModel.stuff_spec_id,
                    @"stuff_spec_name": stuModel.stuff_spec
                }];
            }
        }
    }
    NSLog(@"-------%@", tempArray);
    NSString *deleteStr = [self.deleteArray componentsJoinedByString:@","];
    NSDictionary *dict = @{
        @"del_cart": deleteStr,
        @"stuff_cart_id": self.stuff_cart_id,
        @"updaue_stuff": [tempArray mj_JSONString],
    };
    NSLog(@"-------%@", dict);
    [DZNetworkingTool postWithUrl:kUpdateCart
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                if (self.isFromBaojiadan) {
                    NSArray *viewControllers = self.navigationController.viewControllers;

                    [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                                      usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                      //从BaojiadanDetailViewController进入
                      if ([obj isKindOfClass:[BaojiadanDetailViewController class]]) {
                          BaojiadanDetailViewController *vc = (BaojiadanDetailViewController *) obj;
                          vc.sx = @"1";
                          [self.navigationController popViewControllerAnimated:YES];
                          
                          *stop = YES;
                      }
                                                      }];

                } else {
                    //objectAtIndex后面的参数就是你想要返回的控制器在navigationController.viewControllers的下标
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

                    //CaiLiaoOrderViewController是指定的要返回的控制器
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[CaiLiaoOrderViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            
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

#pragma mark – 懒加载
- (EditSpecView *)editSpecView {
    if (!_editSpecView) {
        _editSpecView = [[EditSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(CongxinBpViewController *) weakself = self;
        
        _editSpecView.sureBlock = ^(NSArray *_Nonnull array) {
            
            for (NSDictionary *dict in array) {
                NSArray *array1 = dict[@"array"];
                NSString *selectStr = @"";
                NSMutableArray *idArray = [NSMutableArray array];
                for (SpecGuigeModel *model in array1) {
                    [idArray addObject:@(model.stuff_spec_id)];
                }
                selectStr = [idArray componentsJoinedByString:@","];
                
                weakself.stuModel.selectsSpecDict = @{
                          @"stuff_spec_id": selectStr,
                          @"number": dict[@"number"],
                          @"name": dict[@"name"]
                          };
            }
            
            CartOrdeInfoModel *model1 = weakself.sectionArry[weakself.index.section];
            NSMutableArray *cellArray = [NSMutableArray array];
            [cellArray removeAllObjects];
            for (NSDictionary *dict in model1.stuff_info) {
                StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
                [cellArray addObject:stuModel];
            }
            
            StuffInfoModel *stuModel = cellArray[weakself.index.row];
            
            stuModel.selectsSpecDict = weakself.stuModel.selectsSpecDict;
            
            [cellArray replaceObjectAtIndex:weakself.index.row withObject:stuModel];
            model1.stuff_info = cellArray;
            
            [weakself.sectionArry replaceObjectAtIndex:weakself.index.section withObject:model1];
            
            [weakself.tableView reloadData];
            
        };
        _editSpecView.deleteBlock = ^{
            weakself.editSpecView = nil;
        };
    }
    
    return _editSpecView;
}



    @end
