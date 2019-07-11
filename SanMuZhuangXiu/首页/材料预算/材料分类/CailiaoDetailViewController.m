//
//  CailiaodanDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CailiaoDetailViewController.h"
#import "PPNumberButton.h"
#import "ReLayoutButton.h"
#import "SDCycleScrollView.h"
#import "PinpaiModel.h"
#import "GuigeModel.h"
#import "CZHTagsView.h"
@interface CailiaoDetailViewController () <SDCycleScrollViewDelegate, CZHTagsViewDataSource, CZHTagsViewDelegate>
//商城搜索
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
//轮播图
@property (weak, nonatomic) IBOutlet UIView *lunboView;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet PPNumberButton *jiajianBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *selectGuigeBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *pinpaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *zidingyiPinpaiBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigeVIewHeight;
//规格
@property (strong, nonatomic) IBOutlet UIView *guigeView;
//规格背景
@property (weak, nonatomic) IBOutlet UIView *guigeBgView;

@property (strong, nonatomic) CZHTagsView *tagsView;
@property (nonatomic, strong) GuigeModel *guigeModel;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *guigeArray;

@property (nonatomic, strong) NSArray *selectTagArray;
@property (nonatomic, strong) NSMutableArray *pinpaiArray;
@end

@implementation CailiaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"材料详情";
    //设置边框的颜色
    [self.searchBtn.layer setBorderColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor];
    //设置边框的粗细
    [self.searchBtn.layer setBorderWidth:1.0];
    [self initItem];
    [self initScrollview];
    [self initData];
}
#pragma mark – UI

- (void)initItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [button setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)initScrollview {

    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth/375.0*225) imageNamesGroup: @[@"home_pic_banner1",@"home_pic_banner2",@"home_pic_banner3"]];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    [self.lunboView addSubview:self.cycleScrollView];
}




#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
}



#pragma mark-- CZHTagsViewDelegateCZHTagsViewDataSource
- (NSArray *)czh_tagsArrayInTagsView:(CZHTagsView *)tagsView {
    NSMutableArray *nameArray = [NSMutableArray array];
    for (GuigeModel *dict in self.guigeArray) {
        [nameArray addObject:dict.spec_name];
    }

    return [nameArray copy];
}
//标签文字两边留白 默认5 如果是CZHTagsViewStyleFit，不走这个方法
- (CGFloat)czh_paddingWidthForItemInTagsView:(CZHTagsView *)tagsView {
    return 10;
}
//标签的高度 默认30
- (CGFloat)czh_heightForItemInTagsView:(CZHTagsView *)tagsView {
    return 20;
}
//每一行之前的距离 默认10
- (CGFloat)czh_marginHeightForRowInTagsView:(CZHTagsView *)tagsView {
    return 10;
}
//两个标签之前的距离 默认10
- (CGFloat)czh_marginWithForItemInTagsView:(CZHTagsView *)tagsView {
    return 15;
}

- (UIEdgeInsets)czh_insetForTagsView:(CZHTagsView *)tagsView {
    return UIEdgeInsetsMake(10, 20, 10, 0);
}
//字体大小 默认15
- (UIFont *)czh_fontForItemInTagsView:(CZHTagsView *)tagsView {
    return [UIFont systemFontOfSize:10];
}
//边框颜色
- (UIColor *)czh_borderColorForItemInTagsView:(CZHTagsView *)tagsView {
    return UIColorFromRGB(0x999999);
}
//选中边框颜色
- (UIColor *)czh_selectBorderColorForItemInTagsView:(CZHTagsView *)tagsView;
{
    return TabbarColor;
}
//字体颜色 默认 黑色
- (UIColor *)czh_textColorForItemInTagsView:(CZHTagsView *)tagsView {
    return UIColorFromRGB(0x666666);
}
//字体颜色 默认 黑色
- (UIColor *)czh_selectTextColorForItemInTagsView:(CZHTagsView *)tagsView {
    return TabbarColor;
}
- (void)czh_tagsView:(CZHTagsView *)tagsView didSelectItemWithSelectTagsArray:(NSArray *)selectTagsArray {

    self.selectTagArray = selectTagsArray;
}
- (void)czh_tagsViewWithHeigth:(CGFloat)selfHeight;
{
    self.guigeVIewHeight.constant = selfHeight + 10;
}
#pragma mark - Function
- (void)initData {
    self.jiajianBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        
    };
    self.jiajianBtn.currentNumber = 1;
    self.pinpaiArray = [NSMutableArray array];
    self.guigeArray = [NSMutableArray array];
    self.selectTagArray = [NSArray array];
}
//自定义品牌
- (void)zidingyipinpai {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"自定义品牌" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = @"请自定义品牌";
    }];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action){
                                                          
                                                      }]];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
                                                          //获取第1个输入框；
                                                          UITextField *textField = alertController.textFields.firstObject;
                                                          [self sendMessage:textField.text];
                                                      }]];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)sendMessage:(NSString *)messsage {
    
    //    NSString* stuff = [NSString stringWithFormat:@"%d", self.stuffId];
    NSDictionary *dict = @{
                           //                           @"stuff_id" : stuff,
                           //                           @"brand_name" : messsage
                           };
    [DZNetworkingTool postWithUrl:kGetapplyBrand
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
}

- (void)alertPinpaiView {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择品牌类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.pinpaiArray.count; i++) {
        PinpaiModel *typeModel = self.pinpaiArray[i];
        //
        [alert addAction:[UIAlertAction actionWithTitle:typeModel.name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertXinziClick:i];
                                                }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertXinziClick:self.pinpaiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertXinziClick:(NSInteger)rowInteger {
    
    if (rowInteger < self.pinpaiArray.count) {
        
        PinpaiModel *typeModel = self.pinpaiArray[rowInteger];
        
        [self.pinpaiBtn setTitle:typeModel.name forState:UIControlStateNormal];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)shareClick {
    NSLog(@"......分享点击了。。。。。");
}

#pragma mark – XibFunction

//自定义pinpai
- (IBAction)zidingyiClick:(id)sender {
    [self zidingyipinpai];
}
//搜索商家
- (IBAction)searchMallClick:(id)sender {
}
//选择规格
- (IBAction)selectGuigeClick:(id)sender {
    
    [self.guigeArray removeAllObjects];
    NSArray *guiTempArray = self.cailiaomodel.spec;
    
    for (NSDictionary *guigeDict in guiTempArray) {
        GuigeModel *guigeModel = [GuigeModel mj_objectWithKeyValues:guigeDict];
        
        [self.guigeArray addObject:guigeModel];
    }
    [self.tagsView reloadData];
    [self.guigeBgView addSubview:self.tagsView];
    self.guigeView.frame = [DZTools getAppWindow].bounds;
    [[DZTools getAppWindow] addSubview:self.guigeView];
}

//确认添加
- (IBAction)sureAddClick:(id)sender {
    
    
}
//取消规格
- (IBAction)guigeCancelClick:(id)sender {
    [self.guigeView removeFromSuperview];

}

//  选择品牌
- (IBAction)selectPinpaiClick:(id)sender {
    [self.pinpaiArray removeAllObjects];
    NSArray *tempArray = self.cailiaomodel.brand;
    for (NSDictionary *pinpaiDict in tempArray) {
        PinpaiModel *pinModel = [PinpaiModel mj_objectWithKeyValues:pinpaiDict];
        [self.pinpaiArray addObject:pinModel];
    }
    [self alertPinpaiView];
}
#pragma mark – 懒加载
- (CZHTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[CZHTagsView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 0) style:CZHTagsViewStyleDefault];
        _tagsView.backgroundColor = [UIColor whiteColor];
        _tagsView.dataSource = self;
        _tagsView.delegate = self;
    }
    return _tagsView;
}

@end
