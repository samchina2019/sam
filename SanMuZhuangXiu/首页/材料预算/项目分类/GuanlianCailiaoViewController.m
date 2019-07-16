//
//  GuanlianCailiaoViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GuanlianCailiaoViewController.h"
#import "XiangmuFenleiViewController.h"
#import "GuanlianCailiaoCell.h"
#import "CaiLiaoFenLeiViewController.h"
#import "StuffListModel.h"
#import "PinpaiModel.h"
#import "GuigeModel.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ZIdongjisuanController.h"
#import "ProjectListModel.h"
#import "GuanlianSelectCell.h"
#import "EditSpecView.h"
#import "SpecGuigeModel.h"

@interface GuanlianCailiaoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITableView *guanlianTableView;
@property (weak, nonatomic) IBOutlet UITableView *yixuanTableView;
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guanlianTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yixuanTableHeight;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *pinpaiArray;
@property (nonatomic, strong) NSMutableArray *guigeArray;
@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) NSString *loginToken;
///stuff Id
@property (nonatomic, strong) NSString *stuffId;
///规格ID
@property (nonatomic, strong) NSIndexPath *spcIndex;
///品牌ID
@property (nonatomic, strong) NSIndexPath *bandIndex;
///选中的第几个
@property (nonatomic, strong) NSIndexPath *index;
///页
@property (nonatomic) NSInteger page;

@property (nonatomic, strong) EditSpecView *editSpecView;
@property (nonatomic, strong) StuffListModel *stuffListModel;
@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;
///选中的cell
@property (nonatomic, strong) UITableViewCell *selectCell;

@end

@implementation GuanlianCailiaoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataisRefresh:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"关联材料";

    self.view.backgroundColor = [UIColor whiteColor];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pinpaiArray = [NSMutableArray array];
    self.guigeArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
//
    [self initTableView];
}
#pragma mark – UI

- (void)initTableView {
    
    self.headView.frame = CGRectMake(0, 0, ViewWidth, 80);
    self.guanlianTableView.tableHeaderView = self.headView;
   
    [self.yixuanTableView registerNib:[UINib nibWithNibName:@"GuanlianCailiaoCell" bundle:nil] forCellReuseIdentifier:@"GuanlianCailiaoCell"];
    self.yixuanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.guanlianTableView
                   registerNib:[UINib nibWithNibName:@"GuanlianSelectCell" bundle:nil]
        forCellReuseIdentifier:@"GuanlianSelectCell"];
    self.guanlianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    [self.guanlianTableView.mj_header beginRefreshing];
    
    self.guanlianTableView.mj_footer =
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
}
#pragma mark – Network
- (void)loadMore {

    [self loadDataisRefresh:NO];
}
- (void)loadDataisRefresh:(BOOL)isRefresh {
    NSMutableArray *array = [NSMutableArray array];
    self.loginToken = [User getToken];

    for (StuffListModel *model in self.totalSelectedStuffList) {

        [array addObject:@(model.stuff_id)];
    }
    NSString *string = [array componentsJoinedByString:@","];

    NSDictionary *dict =
        @{ @"token": self.loginToken,
           @"relation_stuff": string };

    [DZNetworkingTool postWithUrl:kGetStuffRelation
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                
                NSArray *arr = [responseObject objectForKey:@"data"][@"stuff_list"];
                
                if (arr.count == 0 || [array isEqual:@[]]) {
                    [DZTools showNOHud:@"没有数据" delay:2];
                } else {
                    [self.dataArray removeAllObjects];
                    for (NSDictionary *dict in arr) {
                        StuffListModel *model =
                            [StuffListModel mj_objectWithKeyValues:dict];

                        [self.dataArray addObject:model];
                    }

                    self.guanlianTableHeight.constant = self.dataArray.count * 70 + 80;

                    self.numberLabel.text = [NSString stringWithFormat:@"您所选的材料中有%ld种关联材料", self.dataArray.count];
                    [self.guanlianTableView reloadData];
                    [self.view layoutIfNeeded];
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

#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.guanlianTableView) {
        if (self.dataArray.count == 0) {
            
            UIImageView *backgroundImageView =
                [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.guanlianTableView.backgroundView = backgroundImageView;
            self.guanlianTableView.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.guanlianTableView.backgroundView = nil;
        }
        return self.dataArray.count;
    } else {

        return self.selectArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.guanlianTableView) {
        return 70;
    } else {
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.yixuanTableView) {
        
        GuanlianCailiaoCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"GuanlianCailiaoCell"
                                            forIndexPath:indexPath];
        self.selectCell = (GuanlianCailiaoCell *) cell;
        StuffListModel *dict = self.selectArray[indexPath.row];
        cell.nameLabel.text = dict.stuff_name;
        
        if ([dict.selectBrandDict allValues] == 0) {

        } else {
            [cell.pinpaiBtn setTitle:dict.selectBrandDict[@"name"] forState:UIControlStateNormal];
        }
        cell.jiajianBtn.currentNumber = [dict.selectsSpecDict[@"number"] intValue];
        cell.guigeLabel.text = dict.selectsSpecDict[@"name"];
        __weak typeof(GuanlianCailiaoCell *) weakself = cell;
        
        cell.pinpaiBlock = ^{
            
            self.stuffListModel = dict;
            [self.pinpaiArray removeAllObjects];
            self.spcIndex = indexPath;
            NSArray *tempArray = dict.brand;
            
            [self.pinpaiArray removeAllObjects];
            
            for (NSDictionary *pinpaiDict in tempArray) {
                PinpaiModel *pinModel = [PinpaiModel mj_objectWithKeyValues:pinpaiDict];
                [self.pinpaiArray addObject:pinModel];
            }

            self.stuffId = [NSString stringWithFormat:@"%ld", dict.stuff_id];
            [self alertPinpaiViewWithCell:weakself];

        };

        cell.numBlock = ^(CGFloat num) {

            NSDictionary *temp = @{
                @"stuff_spec_id": dict.selectsSpecDict[@"stuff_spec_id"],
                @"number": @(num),
                @"name": dict.selectsSpecDict[@"name"]
            };

            dict.selectsSpecDict = temp;

            [self.selectArray replaceObjectAtIndex:indexPath.row withObject:dict];
            if (num == 0) {

                [self.selectArray removeObjectAtIndex:indexPath.row];
            }
            //            weakself.jiajianBtn.currentNumber = num;
            [self.yixuanTableView reloadData];

        };
        return cell;
    } else {
        GuanlianSelectCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"GuanlianSelectCell"
                                            forIndexPath:indexPath];
        
        self.selectCell = (GuanlianSelectCell *) cell;
        StuffListModel *dict = self.dataArray[indexPath.row];
        cell.nameLabel.text = dict.stuff_name;
        
        __weak typeof(GuanlianSelectCell *) weakself = cell;
        cell.pinpaiBlock = ^{

            self.stuffListModel = dict;

            self.bandIndex = indexPath;
            NSArray *tempArray = dict.brand;
            
            [self.pinpaiArray removeAllObjects];
            
            for (NSDictionary *pinpaiDict in tempArray) {
                PinpaiModel *pinModel = [PinpaiModel mj_objectWithKeyValues:pinpaiDict];
                [self.pinpaiArray addObject:pinModel];
            }

            self.stuffId = [NSString stringWithFormat:@"%ld", dict.stuff_id];
            [self alertPinpaiViewWithCell1:weakself];

        };

        cell.selectBlock = ^{
            
            self.index = indexPath;
            self.stuffListModel = dict;
            
            [self.guigeArray removeAllObjects];
            
            if (dict.spec.count == 0) {
                [DZTools showNOHud:@"暂无规格" delay:2];
                return ;
            } else {
                NSArray *guiTempArray = dict.spec;

                for (NSDictionary *guigeDict in guiTempArray) {
                    GuigeModel *guigeModel = [GuigeModel mj_objectWithKeyValues:guigeDict];

                    [self.guigeArray addObject:guigeModel];
                }
            }

            self.editSpecView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
            self.editSpecView.dataArray = self.guigeArray;
            [self.editSpecView.selectDataArray removeAllObjects];
            [self.editSpecView.guigeView reloadData];
            [[DZTools getAppWindow] addSubview:self.editSpecView];

        };

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Function
- (void)alertPinpaiViewWithCell1:(GuanlianSelectCell *)cell {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"请选择品牌类型"
                         message:nil
                  preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.pinpaiArray.count; i++) {
        PinpaiModel *typeModel = self.pinpaiArray[i];

        [alert addAction:[UIAlertAction
                             actionWithTitle:typeModel.name
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *_Nonnull action) {
                                         [self alertPinpaiClick:i WithCell:cell];
                                     }]];
    }
    [alert addAction:[UIAlertAction
                         actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self alertPinpaiClick:self.pinpaiArray.count WithCell:cell];
                                 }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//选择品牌
- (void)alertPinpaiClick:(NSInteger)rowInteger WithCell:(GuanlianSelectCell *)cell {
    if (rowInteger < self.pinpaiArray.count) {

        PinpaiModel *typeModel = self.pinpaiArray[rowInteger];

        [cell.pinpaiBtn setTitle:typeModel.name forState:UIControlStateNormal];

        self.stuffListModel.selectBrandDict = @{
            @"stuff_brand_id": @(typeModel.stuff_brand_id),
            @"stuff_id": @(typeModel.stuff_brand_id),
            @"name": typeModel.name
        };
        for (StuffListModel *model in self.dataArray) {
            if (model.stuff_id == self.stuffListModel.stuff_id) {

                break;
            }
        }
        [self.dataArray
            replaceObjectAtIndex:self.bandIndex.row
                      withObject:self.stuffListModel];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择品牌
- (void)alertPinpaiViewWithCell:(GuanlianCailiaoCell *)cell {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"请选择品牌类型"
                         message:nil
                  preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.pinpaiArray.count; i++) {
        PinpaiModel *typeModel = self.pinpaiArray[i];

        [alert addAction:[UIAlertAction
                             actionWithTitle:typeModel.name
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *_Nonnull action) {
                                         [self alertXinziClick:i WithCell:cell];
                                     }]];
    }
    [alert addAction:[UIAlertAction
                         actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self alertXinziClick:self.pinpaiArray.count WithCell:cell];
                                 }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//选择规格
- (void)alertXinziClick:(NSInteger)rowInteger WithCell:(GuanlianCailiaoCell *)cell {

    if (rowInteger < self.pinpaiArray.count) {

        PinpaiModel *typeModel = self.pinpaiArray[rowInteger];

        [cell.pinpaiBtn setTitle:typeModel.name forState:UIControlStateNormal];
        self.stuffListModel.selectBrandDict = @{
            @"stuff_brand_id": @(typeModel.stuff_brand_id),
            @"stuff_id": @(typeModel.stuff_brand_id),
            @"name": typeModel.name
        };
        for (StuffListModel *model in self.selectArray) {
            if (model.stuff_id == self.stuffListModel.stuff_id) {

                break;
            }
        }
        [self.selectArray
            replaceObjectAtIndex:self.spcIndex.row
                      withObject:self.stuffListModel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择规格
- (void)alertGuigeViewWithCell:(GuanlianCailiaoCell *)cell {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"请选择规格类型"
                         message:nil
                  preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.guigeArray.count; i++) {
        GuigeModel *typeModel = self.guigeArray[i];

        [alert addAction:[UIAlertAction
                             actionWithTitle:typeModel.spec_name
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *_Nonnull action) {
                                         [self alertGuigeClick:i withCell:cell];
                                     }]];
    }

    [alert addAction:[UIAlertAction
                         actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self alertGuigeClick:self.guigeArray.count
                                                  withCell:cell];
                                 }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertGuigeClick:(NSInteger)rowInteger
               withCell:(GuanlianCailiaoCell *)cell {

    if (rowInteger < self.guigeArray.count) {

        GuigeModel *typeModel = self.guigeArray[rowInteger];
        [cell.xinghaoBtn setTitle:typeModel.spec_name forState:UIControlStateNormal];
        self.stuffListModel.selectsSpecDict = @{
            @"stuff_spec_id": @(typeModel.spec_id),
            @"stuff_id": @(typeModel.stuff_id),
            @"name": typeModel.spec_name
        };
    }
    for (StuffListModel *model in self.dataArray) {
        if (model.stuff_id == self.stuffListModel.stuff_id) {

            break;
        }
    }
    [[self.dataArray mutableCopy]
        replaceObjectAtIndex:self.spcIndex.row
                  withObject:self.stuffListModel];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 返回
-(void)returnNextFunction{
    
    //    /回退到指定界面
    UINavigationController *naviVc = self.navigationController;
    // self.navigationController表示本界面
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc]
                                       init]; //初始化一个vc的数组,用于存放跳转本界面以来的所有vc
    for (UIViewController *vc in
         [naviVc viewControllers]) {    //遍历一路跳转到本界面以来的所有界面
        [viewControllers addObject:vc]; //将遍历出来的界面存放入数组
        
        //判断要回退的指定界面是否与遍历的界面相同,ZYYSeconedViewController也可以替换为ZYYThirdViewController
        if ([vc isKindOfClass:[XiangmuFenleiViewController class]]) {
            if (self.returnBlock) {
                NSMutableArray *tempArray = [NSMutableArray array];
                
                ProjectListModel *model = [[ProjectListModel alloc] init];
                for (StuffListModel *dict in self.selectArray) {
                    if (dict.selectsSpecDict.allValues == 0) {
                        [DZTools showNOHud:@"请选择规格" delay:2];
                        return;
                    }
                    if (dict.selectBrandDict.allValues == 0) {
                        [DZTools showNOHud:@"请选择品牌" delay:2];
                        return;
                    }
                    if (dict.number == 0) {
                        dict.number = 1;
                    }
                    model.stuff_name = dict.stuff_name;
                    model.selectBrandDict = dict.selectBrandDict;
                    model.selectsSpecDict = dict.selectsSpecDict;
                    model.stuff_id = dict.stuff_id;
                    model.number = [dict.selectsSpecDict[@"number"] intValue];
                    [tempArray addObject:model];
                }
                
                self.returnBlock(tempArray);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            //执行回退动作
            self.isFromTiaoguo = NO;
        }
        
        //判断要回退的指定界面是否与遍历的界面相同,ZYYSeconedViewController也可以替换为ZYYThirdViewController
        if ([vc isKindOfClass:[CaiLiaoFenLeiViewController class]]) {
            if (self.returnBlock) {
                for (StuffListModel *dict in self.selectArray) {
                    if (dict.selectsSpecDict.allValues == 0) {
                        [DZTools showNOHud:@"请选择规格" delay:2];
                        return;
                    }
                    if (dict.selectBrandDict.allValues == 0) {
                        [DZTools showNOHud:@"请选择品牌" delay:2];
                        return;
                    }
                    if (dict.number == 0) {
                        dict.number = 1;
                    } else {
                        dict.number = [dict.selectsSpecDict[@"number"] intValue];
                    }
                }
                
                self.returnBlock(self.selectArray);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            self.isFromTiaoguo = NO;
        }
        //判断要回退的指定界面是否与遍历的界面相同,ZYYSeconedViewController也可以替换为ZYYThirdViewController
        if ([vc isKindOfClass:[ZIdongjisuanController class]]) {
            if (self.returnBlock) {
                for (StuffListModel *dict in self.selectArray) {
                    if (dict.selectsSpecDict.allValues == 0) {
                        [DZTools showNOHud:@"请选择规格" delay:2];
                        return;
                    }
                    if (dict.selectBrandDict.allValues == 0) {
                        [DZTools showNOHud:@"请选择品牌" delay:2];
                        return;
                    }
                    if (dict.number == 0) {
                        dict.number = 1;
                    } else {
                        dict.number = [dict.selectsSpecDict[@"number"] intValue];
                    }
                }
                
                self.returnBlock(self.selectArray);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            self.isFromTiaoguo = NO;
        }
    }
}
//跳过
-(void)tiaoguoFunction{
    [self.navigationController popViewControllerAnimated:YES];
    //    /回退到指定界面
    UINavigationController *naviVc = self.navigationController;
    // self.navigationController表示本界面
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc]
                                       init]; //初始化一个vc的数组,用于存放跳转本界面以来的所有vc
    for (UIViewController *vc in
         [naviVc viewControllers]) {    //遍历一路跳转到本界面以来的所有界面
        [viewControllers addObject:vc]; //将遍历出来的界面存放入数组
        
        //判断要回退的指定界面是否与遍历的界面相同,ZYYSeconedViewController也可以替换为ZYYThirdViewController
        if ([vc isKindOfClass:[XiangmuFenleiViewController class]]) {
            [self.navigationController popToViewController:vc
                                                  animated:YES]; //执行回退动作
            self.isFromTiaoguo = YES;
        }
        
        //判断要回退的指定界面是否与遍历的界面相同,ZYYSeconedViewController也可以替换为ZYYThirdViewController
        if ([vc isKindOfClass:[CaiLiaoFenLeiViewController class]]) {
            [self.navigationController popToViewController:vc
                                                  animated:YES]; //执行回退动作
            self.isFromTiaoguo = YES;
        }
        //判断要回退的指定界面是否与遍历的界面相同,ZYYSeconedViewController也可以替换为ZYYThirdViewController
        if ([vc isKindOfClass:[ZIdongjisuanController class]]) {
            [self.navigationController popToViewController:vc
                                                  animated:YES]; //执行回退动作
            self.isFromTiaoguo = YES;
        }
    }
}
#pragma mark-- XiBFunction
- (IBAction)nextBtnClick:(id)sender {

    if (self.dataArray.count == 0) {
        [DZTools showNOHud:@"这里没有数据，请返回上一页面" delay:2];
        return;
    } else {
        if (self.selectArray.count == 0) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"提示"
                                        message:@"您没有选择关联材料，是否确认跳过？"
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction
                                  actionWithTitle:@"是"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *_Nonnull action) {
                                      [self tiaoguoFunction];
                                  }]];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"否"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *_Nonnull action) {
                                  return ;
                              }]];
            //弹出提示框
            [self presentViewController:alert animated:true completion:nil];
        }else{
        
        [self returnNextFunction];
        }
    }
}
- (IBAction)tiaoguoBtnClick:(id)sender {
    
    [self tiaoguoFunction];
}
#pragma mark – 懒加载
-(void)setTotalSelectedStuffList:(NSArray *)totalSelectedStuffList{
    _totalSelectedStuffList=totalSelectedStuffList;
}
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        _scrollView.contentSize = CGSizeMake(ViewWidth, ViewHeight);
    }
    return _scrollView;
}
- (EditSpecView *)editSpecView {
    if (!_editSpecView) {
        _editSpecView = [[EditSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(GuanlianCailiaoViewController *) weakself = self;

        _editSpecView.sureBlock = ^(NSArray *_Nonnull array) {

            if (weakself.selectArray.count != 0) {
                BOOL isXiangTong = NO;
                for (StuffListModel *temp in weakself.selectArray) {
                    NSString *isStr = temp.selectsSpecDict[@"stuff_spec_id"];

                    NSDictionary *dict = array[0];
                    NSString *selectStr = @"";
                    if ([dict[@"array"] count] > 0) {
                        NSArray *array1 = dict[@"array"];
                        for (SpecGuigeModel *model in array1) {
                            selectStr = [selectStr stringByAppendingFormat:@"%ld,", (long) model.stuff_spec_id];
                        }
                    } else {
                        selectStr = dict[@"stuff_spec_id"];
                    }
                    if ([isStr isEqualToString:selectStr] && selectStr.length > 0) {
                        isXiangTong = YES;
                        return;
                    }
                }
                if (!isXiangTong) {
                    for (NSDictionary *dict in array) {
                        NSArray *array1 = dict[@"array"];
                        NSString *selectStr = @"";
                        for (SpecGuigeModel *model in array1) {
                            selectStr = [selectStr stringByAppendingFormat:@"%ld,", (long) model.stuff_spec_id];
                        }

                        weakself.stuffListModel.selectsSpecDict = @{
                            @"stuff_spec_id": selectStr,
                            @"number": dict[@"number"],
                            @"name": dict[@"name"]
                        };

                        StuffListModel *xinModel = [[StuffListModel alloc] init];
                        xinModel.stuff_name = weakself.stuffListModel.stuff_name;
                        xinModel.image = weakself.stuffListModel.image;
                        xinModel.auto_type = weakself.stuffListModel.auto_type;
                        xinModel.auto_count = weakself.stuffListModel.auto_count;
                        xinModel.stuff_id = weakself.stuffListModel.stuff_id;
                        xinModel.auto_integer = weakself.stuffListModel.auto_integer;
                        xinModel.scale = weakself.stuffListModel.scale;
                        xinModel.brand = weakself.stuffListModel.brand;
                        xinModel.spec = weakself.stuffListModel.spec;
                        xinModel.selectBrandDict = weakself.stuffListModel.selectBrandDict;
                        xinModel.selectsSpecDict = weakself.stuffListModel.selectsSpecDict;
                        [weakself.selectArray addObject:xinModel];
                    }
                }
            } else {

                for (NSDictionary *dict in array) {
                    NSArray *array1 = dict[@"array"];
                    NSString *selectStr = @"";
                    NSMutableArray *idArray = [NSMutableArray array];
                    for (SpecGuigeModel *model in array1) {
                        //                        selectStr = [selectStr stringByAppendingFormat:@"%ld,", (long) model.stuff_spec_id];
                        [idArray addObject:@(model.stuff_spec_id)];
                    }
                    selectStr = [idArray componentsJoinedByString:@","];

                    weakself.stuffListModel.selectsSpecDict = @{
                        @"stuff_spec_id": selectStr,
                        @"number": dict[@"number"],
                        @"name": dict[@"name"]
                    };
                    StuffListModel *xinModel = [[StuffListModel alloc] init];
                    xinModel.stuff_name = weakself.stuffListModel.stuff_name;
                    xinModel.image = weakself.stuffListModel.image;
                    xinModel.auto_type = weakself.stuffListModel.auto_type;
                    xinModel.auto_count = weakself.stuffListModel.auto_count;
                    xinModel.stuff_id = weakself.stuffListModel.stuff_id;
                    xinModel.auto_integer = weakself.stuffListModel.auto_integer;
                    xinModel.scale = weakself.stuffListModel.scale;
                    xinModel.brand = weakself.stuffListModel.brand;
                    xinModel.spec = weakself.stuffListModel.spec;
                    xinModel.selectBrandDict = weakself.stuffListModel.selectBrandDict;
                    xinModel.selectsSpecDict = weakself.stuffListModel.selectsSpecDict;
                    [weakself.selectArray addObject:xinModel];
                }
            }
            weakself.yixuanTableHeight.constant = weakself.selectArray.count * 120;
            
            [weakself.yixuanTableView reloadData];
        };
        _editSpecView.deleteBlock = ^{
            weakself.editSpecView = nil;
        };
    }
    
    return _editSpecView;
}
@end


