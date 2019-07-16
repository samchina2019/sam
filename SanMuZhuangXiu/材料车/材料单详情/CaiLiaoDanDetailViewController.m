//
//  CaiLiaoDanDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CaiLiaoDanDetailViewController.h"
#import "CaiLiaoDanDetailHeaderView.h"
#import "CailaodanEditCell.h"
#import "SelectStoreViewController.h"
#import "CongxinBpViewController.h"
#import "CartOrdeInfoModel.h"
#import "StuffInfoModel.h"
#import <UShareUI/UShareUI.h>
#import "FriendsListViewController.h"
#import "FriendsListModel.h"
#import "CaiLiaoOrderViewController.h"
#import "PinpaiModel.h"
#import "EditSpecView.h"
#import "GuigeModel.h"
#import "SpecGuigeModel.h"
#import "CaiLiaoFenLeiViewController.h"


@interface CaiLiaoDanDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reEdictBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuguBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gongzhongLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *gongZhongLabel;
@property (weak, nonatomic) IBOutlet UILabel *cailiaoZhongLeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sectionArry;
///有无品牌
@property (nonatomic, assign) int no_brand;

///材料车ID
@property (nonatomic, strong) NSString *cartId;
@property (nonatomic, strong) NSString *nameStr;


@property (strong, nonatomic) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSIndexPath *index;
@property (strong, nonatomic) NSMutableArray *pinpaiArray;
@property (nonatomic, assign) NSInteger stuff_id;
@property (nonatomic, strong) EditSpecView *editSpecView;
@property (nonatomic, strong) StuffInfoModel *stuModel;
@property (nonatomic, strong) NSMutableArray *guigeArray;





@end

@implementation CaiLiaoDanDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataArrayFMDB];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"材料单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.nameLabel.userInteractionEnabled = NO;
    self.sectionArry = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    self.pinpaiArray = [NSMutableArray array];
    self.guigeArray = [NSMutableArray array];
    
    
    [self initTableView];
    [self initBottomView];
    [self setupRightItem];
    //        self.priceLabel.text=[NSString stringWithFormat:@"¥0.00"];
}
#pragma mark – UI
- (void)initTableView {
    self.tableHeaderView.frame = CGRectMake(0, 0, ViewWidth, 176);
    self.tableView.tableHeaderView = self.tableHeaderView;
//    self.tableFooterView.frame = CGRectMake(0, 0, ViewWidth, 220);
//    self.tableView.tableFooterView = self.tableFooterView;

    self.tableView.rowHeight = 90;
//    [self.tableView registerNib:[UINib nibWithNibName:@"CaiLiaoDanDetailCell" bundle:nil] forCellReuseIdentifier:@"CaiLiaoDanDetailCell"];
      [self.tableView registerNib:[UINib nibWithNibName:@"CailaodanEditCell" bundle:nil] forCellReuseIdentifier:@"CailaodanEditCell"];
}
- (void)initBottomView {
    
    self.bottomView.frame=CGRectMake(0, SCREEN_HEIGHT-SafeAreaBottomHeight-60, SCREEN_WIDTH, 60);
    [self.view addSubview:self.bottomView];
}
- (void)setupRightItem{
    UIButton* _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70,100, 44*SCREEN_WIDTH/750, 44*SCREEN_WIDTH/750)];
    [_rightButton setImage:[UIImage imageNamed:@"icon_share"]forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rightButton addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}


#pragma mark – Network

- (void)getDataArrayFMDB {
    NSDictionary *dict = @{};
  
        dict = @{
                 @"stuff_cart_id": self.stuff_cart_id,
                 };

    [DZNetworkingTool postWithUrl:kGetcartDetail
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                NSDictionary *dictBasic = dict[@"lists"];

                NSString *name = dictBasic[@"stuff_work_name"];
                if ([name isKindOfClass:[NSNull class]]) {
                    self.gongzhongLabel.text = @"测试数据";
                } else {
                    self.gongzhongLabel.text = name;
                }
                NSDictionary *stuffCartDict = dictBasic[@"stuff_cart_info"];
                self.cartId = stuffCartDict[@"stuff_cart_id"];
                self.nameLabel.text = stuffCartDict[@"stuff_cart_name"];
                self.nameStr = stuffCartDict[@"stuff_cart_name"];
                NSDictionary *cartDict = dict[@"lists"][@"cart_info"];
                self.no_brand = [cartDict[@"no_brand"] intValue];
                NSLog(@"%@", cartDict);

                self.cailiaoZhongLeiLabel.text = [NSString stringWithFormat:@"%@", cartDict[@"stuff_count"]];
                self.numLabel.text = [NSString stringWithFormat:@"%@", cartDict[@"stuff_number"]];

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
    NSArray *array = model.stuff_info;
    return array.count;
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
//    CailaodanEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CailaodanEditCell"];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    CartOrdeInfoModel *model = self.sectionArry[indexPath.section];
//    NSDictionary *dict = model.stuff_info[indexPath.row];
//
//    StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
//    cell.nameLabel.text = stuModel.stuff_name;
////    cell.pinpaiBtn.text = stuModel.stuff_brand_name;
//    [cell.pinpaiBtn setTitle:[NSString stringWithFormat:@"%@",stuModel.stuff_brand_name] forState:UIControlStateNormal];
////    cell.guigeBtn.text = stuModel.stuff_spec;
//    [cell.guigeBtn setTitle:[NSString stringWithFormat:@"%@",stuModel.stuff_spec] forState:UIControlStateNormal];
//
////    if (stuModel.unit.length == 0) {
////        cell.numberLabel.text = [NSString stringWithFormat:@"%d", stuModel.number];
////    } else {
////        cell.numberLabel.text = [NSString stringWithFormat:@"%d (%@)", stuModel.number, stuModel.unit];
////    }
//
//    return cell;
    
    CailaodanEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CailaodanEditCell"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    CartOrdeInfoModel *model = self.sectionArry[indexPath.section];
     NSDictionary *dict = model.stuff_info[indexPath.row];
     StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
    
    NSMutableArray *cellArray = [NSMutableArray array];
    [cellArray removeAllObjects];
    for (NSDictionary *dict in model.stuff_info) {
        StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
        [cellArray addObject:stuModel];
    }
//
//    StuffInfoModel *stuModel = cellArray[indexPath.row];
    
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
//        [self alertPinpaiViewWithcellView:weakself];
        
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

#pragma mark - Function
//编辑材料单
-(void)editCailiaodanWithStr:(NSString *)name{
    
    if ([name isEqualToString:self.nameStr]) {
        [DZTools showNOHud:@"材料单名称未修改" delay:2];
        return ;
    }
    
    NSDictionary *dict = @{
                           @"stuff_cart_ids": self.cartId,
                           @"name": name
                           
                           };
    [DZNetworkingTool postWithUrl:kUpdateCartname
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
      if ([responseObject[@"code"] intValue] == SUCCESS) {
          //                NSDictionary *dict=responseObject[@"data"];
          [DZTools showOKHud:responseObject[@"msg"] delay:2];
          self.editBtn.selected=NO;
          self.nameLabel.userInteractionEnabled = NO;
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
    
}
#pragma mark - XibFunction
//立即分享
- (IBAction)shareBtnClicked:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    FriendsListViewController *viewController = [[FriendsListViewController alloc] init];
    viewController.isFromCart = YES;
    viewController.block = ^(FriendsListModel *model) {
        NSDictionary *dict = @{
            @"stuff_cart_id": self.cartId,
            @"to_id": @(model.user_id)
        };

        [DZNetworkingTool postWithUrl:kStuffShare
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {

                    [DZTools showOKHud:responseObject[@"msg"] delay:2];

//                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
//
//                    //LoginViewController是指定的要返回的控制器
//                    for (UIViewController *controller in self.navigationController.viewControllers) {
//                        if ([controller isKindOfClass:[CaiLiaoOrderViewController class]]) {
//                            [self.navigationController popToViewController:controller animated:YES];
//                        }
//                    }
                    [self.tableView reloadData];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            IsNeedHub:NO];

    };
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//重新编辑
- (IBAction)editBtnClicked:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    CongxinBpViewController *viewController = [[CongxinBpViewController alloc] init];
    viewController.stuff_cart_id = self.stuff_cart_id;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//立即购买
- (IBAction)buyBtnClicked:(id)sender {

    if (self.no_brand > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"有%d种材料未设置品牌\n是否进行设置", self.no_brand] preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是"
                                                             style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *_Nonnull action) {
       self.hidesBottomBarWhenPushed = YES;
       CongxinBpViewController *viewController = [[CongxinBpViewController alloc] init];
       viewController.stuff_cart_id = self.stuff_cart_id;
       [self.navigationController pushViewController:viewController animated:YES];
       self.hidesBottomBarWhenPushed = YES;
                                                           }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
         self.hidesBottomBarWhenPushed = YES;
         SelectStoreViewController *viewController = [SelectStoreViewController new];
         viewController.stuff_cart_id = self.cartId;
         viewController.cartName = self.nameLabel.text;
         [self.navigationController pushViewController:viewController animated:YES];
         self.hidesBottomBarWhenPushed = YES;
                                                                 
                                                             }];

        [alertController addAction:cancelAction];

        [alertController addAction:sureAction];

        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        self.hidesBottomBarWhenPushed = YES;
        SelectStoreViewController *viewController = [SelectStoreViewController new];
        viewController.stuff_cart_id = self.cartId;
        viewController.cartName = self.nameLabel.text;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - 编辑材料单名称
- (IBAction)bianjiBtnCLick:(UIButton *)sender {

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
#pragma mark - 跳转新增材料
- (IBAction)xinzengBtnClick:(id)sender {
    
    CaiLiaoFenLeiViewController *vc = [[CaiLiaoFenLeiViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
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


#pragma mark - 商城预估计价格
- (IBAction)gujiBtnClick:(id)sender {

    NSDictionary *dict = @{
        @"stuff_cart_id": self.cartId
    };
    [DZNetworkingTool postWithUrl:kGerPrices
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                [self.yuguBtn setTitle:[NSString stringWithFormat:@" 预估价格：¥%@ ", dict[@"prices"]] forState:UIControlStateNormal];

                //            self.priceLabel.text=[NSString stringWithFormat:@"¥%@",dict[@"prices"]];
                [self.tableView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

- (EditSpecView *)editSpecView {
    if (!_editSpecView) {
        _editSpecView = [[EditSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(CaiLiaoDanDetailViewController *) weakself = self;
        
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
