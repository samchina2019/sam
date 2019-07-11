//
//  StoreDetailGoodsViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreDetailGoodsViewController.h"
//#import "UITableView+JHNoData.h"
#import "StoreDetailGoodsListCell.h"
#import "PPNumberButton.h"
#import "CZHTagsView.h"
#import "GoodsDetailPageViewController.h"
#import "CailiaoViewCell.h"
#import "SpecSkuModel.h"
#import "GoodsSkuModel.h"
#import "GoodsSelectSpecView.h"
#import "GuigeModel.h"

@interface StoreDetailGoodsViewController ()<CZHTagsViewDelegate, CZHTagsViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *yixuanCailiaoView;
@property (weak, nonatomic) IBOutlet UITableView *cailiaodanTableview;
@property (strong, nonatomic) IBOutlet UIView *guigeView;
@property (strong, nonatomic) IBOutlet UIView *guigebgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigebgViewHeight;
@property (weak, nonatomic) IBOutlet UIView *jiajianBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *classTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) CZHTagsView *tagsView;
@property (strong, nonatomic) PPNumberButton *ppNumberButton;
@property (nonatomic, strong) GoodsSelectSpecView *goodsSelectSpecView;

@property (strong, nonatomic) NSMutableArray *classDataArray;
@property(nonatomic,strong)NSMutableArray *specArray;
@property (nonatomic, strong) NSArray* selectTagArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectedCailiao;

@property(nonatomic,strong)NSString *catageryId;
@property (nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger selectIndex;
@property(nonatomic,assign)NSInteger goodsId;
@property (nonatomic, assign) NSInteger number;
@property(nonatomic,assign)BOOL isSelect;

@property (nonatomic, strong) NSString *goods_spec_id; //根据规格和品牌确定的商品ID
@property (nonatomic, strong) NSString *goods_sku_id;  //规格ID 1_2_3
@property (nonatomic, strong) NSString *goods_sku_name;
@property (nonatomic, strong) NSString *pingPaiID;
@property (nonatomic, strong) NSString *goods_num;

@end

@implementation StoreDetailGoodsViewController


#pragma mark – UI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.number = 0;
    self.navigationItem.title = @"更多";
    self.selectedCailiao=[NSMutableArray array];
    self.ppNumberButton.currentNumber = 1;
    self.ppNumberButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        
    };
    self.specArray=[NSMutableArray array];
    [self initData];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.classDataArray=[NSMutableArray array];
  
//    self.classTableView.jh_showNoDataEmptyView = YES;
 
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreDetailGoodsListCell" bundle:nil] forCellReuseIdentifier:@"StoreDetailGoodsListCell"];
   
    [self.cailiaodanTableview registerNib:[UINib nibWithNibName:@"CailiaoViewCell" bundle:nil] forCellReuseIdentifier:@"CailiaoViewCell"];
    self.cailiaodanTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchData:) name:@"searchData" object:nil];
}
-(void)searchData:(NSNotification *)noti{
    //使用userInfo处理消息
    NSDictionary  *dic = [noti userInfo];
    NSString  *searchStr =dic[@"title"];
    
    NSDictionary *params = @{@"category_id":self.catageryId,
                             @"seller_id":@(self.storeId),
                             @"search":searchStr
                             };
    [DZNetworkingTool postWithUrl:kCategoryGoods params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict = responseObject[@"data"];
            
            [self.dataArray removeAllObjects];
          
            for (NSDictionary *dataDict in dict[@"data"]) {
                
                [self.dataArray addObject:dataDict];
            }
            
            [self.tableView reloadData];
            
        }else
        {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
    
    
}

#pragma mark – Network

-(void)initData{
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
                             @"lng": [NSString stringWithFormat:@"%lf", longitude],
                             @"lat": [NSString stringWithFormat:@"%lf", latitude],
                             @"seller_id":@(self.storeId)
                             };
    [DZNetworkingTool postWithUrl:kSellerDetails
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict=responseObject[@"data"][@"data"];
                                  NSArray *array=dict[@"goods_category"];
                                  [self.classDataArray removeAllObjects];
                                  for (NSDictionary *goodDict in array) {
                                      [self.classDataArray addObject:goodDict];
                                  }
                                  
                                  [self.classTableView reloadData];
                                  [self.dataArray removeAllObjects];
                                  [self.tableView reloadData];
                                  if (self.classDataArray.count > 0) {
                                      NSDictionary *dict = self.classDataArray[0];
                                      
                                      self.catageryId = dict[@"category_id"];
                                      [self getDataArrayFromServerIsRefresh:YES];
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

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    NSDictionary *params = @{@"category_id":self.catageryId,
                             @"seller_id":@(self.storeId)
                             
                             };
    [DZNetworkingTool postWithUrl:kCategoryGoods params:params success:^(NSURLSessionDataTask *task, id responseObject) {
      
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict = responseObject[@"data"];
            
            if(isRefresh){
            [self.dataArray removeAllObjects];
             }
 
            for (NSDictionary *dataDict in dict[@"data"]) {
                  [self.dataArray addObject:dataDict];
            }
          
            [self.tableView reloadData];
            
        }else
        {
            [self.dataArray removeAllObjects];
             [self.tableView reloadData];
            [DZTools showNOHud:responseObject[@"msg"] delay:1];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
       
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
   
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.classTableView) {
        return 1;
    }else{
       return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.classTableView) {
        return self.classDataArray.count;
    } else if (tableView == self.cailiaodanTableview) {
        if (self.selectedCailiao.count == 0) {
            UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.cailiaodanTableview.backgroundView = backgroundImageView;
            self.cailiaodanTableview.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.cailiaodanTableview.backgroundView = nil;
        }
        return self.selectedCailiao.count;

    
    }else{
        return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        return 44;
    }else if (tableView == self.cailiaodanTableview) {
        return 80;
    }else{
        return 110;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (tableView == self.classTableView) {
        return 0.01;
//    }else{
//        return 40;
//    }
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
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if (tableView == self.classTableView) {
        return @"";
//    }else{
//        return @"线管部分";
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        static NSString *cellIdentifier = @"classCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSDictionary *dict=self.classDataArray[indexPath.row];
        cell.textLabel.text=dict[@"name"];
        
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
    }else if (tableView == self.cailiaodanTableview) {
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
        
    }
    else{
        StoreDetailGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreDetailGoodsListCell" forIndexPath:indexPath];
        NSDictionary *dict=self.dataArray[indexPath.row];
        
//        NSArray *tempArray=dict[@"spec_sku"];

        cell.nameLabel.text=dict[@"goods_name"];
        NSLog(@"%@",dict[@"goods_name"]);
        cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@",dict[@"goods_price"]];
        [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:dict[@"images"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        cell.haoAndMayLabel.text=[NSString stringWithFormat:@"%@%%好评 %@购买",dict[@"evaluate"],dict[@"sales_actual"]];
        [cell.addressLabel setTitle:[NSString stringWithFormat:@"%@",dict[@"seller_addr"]] forState:UIControlStateNormal];
        cell.resultBlock = ^(NSInteger number) {
            
        };
        self.imgView.image = [UIImage imageNamed:@"defaultImg"];
        self.nameLabel.text=@"";
        self.priceLabel.text=@"";
   
        self.goodsId=0;
        
        cell.addBlock = ^{
            self.goodsSelectSpecView.dataDict = @{@"detail":dict,@"specData":dict[@"specData"]};
            NSMutableArray *guigeArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tempdict in dict[@"specData"][@"spec_attr"]) {
                GuigeModel *model = [[GuigeModel alloc] init];
                model.data = tempdict[@"spec_items"];
                model.spec_name = tempdict[@"group_name"];
                model.spec_rel_id = [tempdict[@"group_id"] integerValue];
                [guigeArray addObject:model];
            }
            self.goodsSelectSpecView.dataArray = [guigeArray mutableCopy];
//            [self.goodsSelectSpecView.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"images"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            self.goodsSelectSpecView.imageStr = dict[@"images"];
//            self.goodsSelectSpecView.pingPaiArray = [dict[@"specData"][@"brand_list"] mutableCopy];
            
            [[DZTools getAppWindow] addSubview:self.goodsSelectSpecView];
            self.goodsId=[dict[@"goods_id"] intValue];
//            [self.selectedCailiao removeAllObjects];
//            [self.specArray removeAllObjects];
//            self.selectTagArray = nil;
//            for (NSDictionary *temp in tempArray) {
//                SpecSkuModel *specModel=[SpecSkuModel mj_objectWithKeyValues:temp];
////               name=specModel.spec;
//                [self.specArray addObject:specModel];
//            }
//            
//            [self.imgView sd_setImageWithURL:dict[@"images"] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
//            self.nameLabel.text=dict[@"goods_name"];
//            self.priceLabel.text=[NSString stringWithFormat:@"¥%@",dict[@"goods_price"]];
//            self.ppNumberButton.currentNumber = 1;
//            [self.jiajianBgView addSubview:self.ppNumberButton];
//            [self.guigebgView addSubview:self.tagsView];
//            [self.tagsView reloadData];
//            self.guigeView.frame = [DZTools getAppWindow].bounds;
//            [[DZTools getAppWindow] addSubview:self.guigeView];
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
            NSDictionary *dict=self.classDataArray[indexPath.row];
            
            if (self.classDataArray.count == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            } else {
                
                self.catageryId=dict[@"category_id"];
                [self getDataArrayFromServerIsRefresh:YES];
            }
        }
    } else  if(tableView == self.cailiaodanTableview){
        //        CailiaodanDetailViewController
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *dict=self.dataArray[indexPath.row];
        
         self.goodsId=[dict[@"goods_id"] intValue];
        self.parentViewController.hidesBottomBarWhenPushed = YES;
        
        GoodsDetailPageViewController *viewController = [GoodsDetailPageViewController new];
        viewController.goodsId=self.goodsId;
        viewController.mallId=self.storeId;
        viewController.storeName=self.storeName;
        viewController.image=dict[@"images"];
       
        [self.parentViewController.navigationController pushViewController:viewController animated:YES];
        self.parentViewController.hidesBottomBarWhenPushed = YES;
    }
}
#pragma mark -- CZHTagsViewDelegateCZHTagsViewDataSource
- (NSArray *)czh_tagsArrayInTagsView:(CZHTagsView *)tagsView {
    
    NSMutableArray* nameArray = [NSMutableArray array];
    for (SpecSkuModel* dict in self.specArray) {
        [nameArray addObject:dict.spec];
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
    return UIEdgeInsetsMake(10, 20, 10, 10);
}
//字体大小 默认15
- (UIFont *)czh_fontForItemInTagsView:(CZHTagsView *)tagsView
{
    return [UIFont systemFontOfSize:10];
}
//边框颜色
- (UIColor *)czh_borderColorForItemInTagsView:(CZHTagsView *)tagsView
{
    return UIColorFromRGB(0x999999);
}
//选中边框颜色
- (UIColor *)czh_selectBorderColorForItemInTagsView:(CZHTagsView *)tagsView;
{
    return TabbarColor;
}
//字体颜色 默认 黑色
- (UIColor *)czh_textColorForItemInTagsView:(CZHTagsView *)tagsView
{
    return UIColorFromRGB(0x666666);
}
//字体颜色 默认 黑色
- (UIColor *)czh_selectTextColorForItemInTagsView:(CZHTagsView *)tagsView
{
    return TabbarColor;
}
- (void)czh_tagsView:(CZHTagsView *)tagsView didSelectItemWithSelectTagsArray:(NSArray *)selectTagsArray {
    
    self.selectTagArray=nil;
    self.selectTagArray = selectTagsArray;
    
}
-(void)czh_tagsViewWithHeigth:(CGFloat)selfHeight;
{
    self.guigebgViewHeight.constant = selfHeight + 10;
}
#pragma mark - XibFunction
//取消
- (IBAction)cancleBtnClicked:(id)sender {
    [self.guigeView removeFromSuperview];
}
//确定
- (IBAction)commitBtnClicked:(id)sender {
    if (self.selectTagArray.count==0) {
        [DZTools showNOHud:@"请务必选择一个规格" delay:2];
        return;
    }
    
    [self.guigeView removeFromSuperview];
    [self.tagsView removeFromSuperview];
    self.tagsView = nil;
    
    NSString *name=self.nameLabel.text;
    NSString *price=self.priceLabel.text;
    NSInteger spec_id=0;
    NSString *spec=@"";
    self.tagsView=nil;
     NSString *spec_sku_id=@"";
    for (SpecSkuModel* dict in self.specArray) {
        if ([dict.spec isEqualToString:self.selectTagArray[0]]) {
            
            spec = dict.spec;
            spec_id = dict.spec_id;
            spec_sku_id=dict.spec_sku_id;
        }
    }
    
    
    GoodsSkuModel *model=[GoodsSkuModel new];
    model.selectsGoodsDict = @{
                                         @"goods_name":name,
                                         @"goods_price":price,
                                         @"goods_id":@(self.goodsId),
                                         @"spec_id":@(spec_id),
                                         @"spec_sku_id":spec_sku_id,
                                         @"spec":spec,
                                         @"number":@(self.ppNumberButton.currentNumber)

                                            };
    NSLog(@"%@", model.selectsGoodsDict);
    model.number = 1;
    self.isSelect=YES;
    [self.selectedCailiao addObject:model];
    [self.cailiaodanTableview reloadData];
    self.number = self.selectedCailiao.count;
    [self.tableView reloadData];
  
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
                                  [self.selectedCailiao removeAllObjects];
                                  self.numberLabel.text = 0;
                                  [self.view layoutIfNeeded];
                                  [self.cailiaodanTableview reloadData];
                                  
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"cartXiaoxi" object:nil userInfo:dict]; self.tabBarController.selectedIndex = 2;
                                  [self.navigationController popToRootViewControllerAnimated:NO];
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];

                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                               
                           }
                        IsNeedHub:NO];
    [self.specArray removeAllObjects];
    [self.yixuanCailiaoView removeFromSuperview];
}

- (IBAction)gouwucheBtnClick:(id)sender {
    self.yixuanCailiaoView.frame = [DZTools getAppWindow].bounds;
    
    [[DZTools getAppWindow] addSubview:self.yixuanCailiaoView];
    
}

- (IBAction)cancelCailiaocheClick:(id)sender {
    [self.yixuanCailiaoView removeFromSuperview];

}

#pragma mark – 懒加载
//MARK:懒加载
- (GoodsSelectSpecView *)goodsSelectSpecView {
    if (!_goodsSelectSpecView) {
        _goodsSelectSpecView = [[GoodsSelectSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(self) weakSelf = self;
        _goodsSelectSpecView.sureBlock = ^(NSString *_Nonnull num, NSString *_Nonnull guigeID, NSString *_Nonnull guigeName, NSString *_Nonnull goods_spec_id, NSString *_Nonnull pingPaiID, NSString *_Nonnull goods_name, NSString *_Nonnull goods_price, NSString *_Nonnull pingPaiName ,int cartTiaozhuan) {
            [weakSelf.selectedCailiao removeAllObjects];
            weakSelf.goods_num = num;
            weakSelf.goods_sku_id = guigeID;
            weakSelf.goods_sku_name = guigeName;
            weakSelf.goods_spec_id = goods_spec_id;
//            weakSelf.pingPaiID = pingPaiID;
            
            GoodsSkuModel *model=[GoodsSkuModel new];
            model.selectsGoodsDict = @{
                                       @"goods_name":goods_name,
                                       @"goods_price":goods_price,
                                       @"goods_id":@(weakSelf.goodsId),
                                       @"goods_sku_id": guigeID,
//                                       @"pingPaiName":pingPaiName,
                                       @"guigeName":guigeName,
                                       @"number":num};
            NSLog(@"%@", model.selectsGoodsDict);
            model.number = [num intValue];
            weakSelf.isSelect = YES;
            [weakSelf.selectedCailiao addObject:model];
            [weakSelf.cailiaodanTableview reloadData];
            weakSelf.number = weakSelf.selectedCailiao.count;
            [weakSelf.tableView reloadData];
           
            //通知更新了表格
            NSDictionary *dict = @{
                                   @"data":weakSelf.selectedCailiao,
                                   @"number":@(weakSelf.number)
                                   };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newCartViewShow1" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newCartViewShow2" object:nil userInfo:dict];
           
        };
        _goodsSelectSpecView.deleteBlock = ^{
            weakSelf.goodsSelectSpecView = nil;
        };
    }

    return _goodsSelectSpecView;
}
- (PPNumberButton *)ppNumberButton;
{
    if (!_ppNumberButton) {
        _ppNumberButton = [[PPNumberButton alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
        _ppNumberButton.increaseTitle = @"+";
        _ppNumberButton.decreaseTitle = @"-";
        _ppNumberButton.borderColor = [UIColor lightGrayColor];
        _ppNumberButton.minValue = 1;
        _ppNumberButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
            
        };
    }
    return _ppNumberButton;
}
- (CZHTagsView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[CZHTagsView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth-60, 0) style:CZHTagsViewStyleDefault];
        _tagsView.backgroundColor = [UIColor whiteColor];
        _tagsView.dataSource = self;
        _tagsView.delegate = self;
    }
    return _tagsView;
}
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
