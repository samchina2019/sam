//
//  ZidongjisuanViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ZidongjisuanViewController.h"
#import "CailaodanEditCell.h"
#import "ImgTitleCCell.h"
#import "CartOrdeInfoModel.h"
#import "StuffInfoModel.h"
@interface ZidongjisuanViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *HeadCollectionView;
@property (strong, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UIView *cailiaodanView;
@property (weak, nonatomic) IBOutlet UIView *jisuanVIew;
@property (weak, nonatomic) IBOutlet UIButton *xinzengBtn;
@property (weak, nonatomic) IBOutlet UIView *tongjiView;
@property (weak, nonatomic) IBOutlet UIView *xinzengView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *FootView;
@property(nonatomic,strong)NSMutableArray *sectionArry;

@end
static NSString* imgCellId = @"imgCellId";
@implementation ZidongjisuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initTableView];
    [self getDataArrayFMDB];
    [self initCollectionView];
    self.sectionArry=[NSMutableArray array];
}
- (void)getDataArrayFMDB {
    NSDictionary *dict = @{
                           @"stuff_cart_id": @(6)
                           };
    
    [DZNetworkingTool postWithUrl:kGetcartDetail
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict = responseObject[@"data"];
                                  
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
                             
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
}
- (void)initCollectionView
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (ViewWidth - 60) / 5;
    layout.itemSize = CGSizeMake(width, 50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.HeadCollectionView.collectionViewLayout = layout;
    [self.HeadCollectionView registerClass:[ImgTitleCCell class] forCellWithReuseIdentifier:imgCellId];
}
-(void)initTableView{
    self.HeadView.frame = CGRectMake(0, 0, ViewWidth, 425);
    self.tableView.tableHeaderView = self.HeadView;
    self.FootView.frame = CGRectMake(0, 0, ViewWidth, 165);
    self.tableView.tableFooterView = self.FootView;
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[UINib nibWithNibName:@"CailaodanEditCell" bundle:nil] forCellReuseIdentifier:@"CailaodanEditCell"];


}

-(void)initView{
    //阴影的颜色
    self.jisuanVIew.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.jisuanVIew.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.jisuanVIew.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.jisuanVIew.layer.shadowOffset = CGSizeMake(0,0);
    self.jisuanVIew.layer.cornerRadius = 3;
    
    //阴影的颜色
    self.tableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.tableView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.tableView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.tableView.layer.shadowOffset = CGSizeMake(0,0);
    self.tableView.layer.cornerRadius = 3;
    
    
    //阴影的颜色
    self.cailiaodanView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.cailiaodanView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.cailiaodanView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.cailiaodanView.layer.shadowOffset = CGSizeMake(0,0);
    self.cailiaodanView.layer.cornerRadius = 3;
    
    
    
    //阴影的颜色
    self.xinzengView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.xinzengView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.xinzengView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.xinzengView.layer.shadowOffset = CGSizeMake(0,0);
    self.xinzengView.layer.cornerRadius = 3;
    
    
    //阴影的颜色
    self.tongjiView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.tongjiView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.tongjiView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.tongjiView.layer.shadowOffset = CGSizeMake(0,0);
    self.tongjiView.layer.cornerRadius = 3;
    
    
    
    //设置边框的颜色
    [self.xinzengBtn.layer setBorderColor: [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0].CGColor];
    
    //设置边框的粗细
    [self.xinzengBtn.layer setBorderWidth:1.0];
    
    //设置圆角的半径
    [self.xinzengBtn.layer setCornerRadius:3];
    
    //切割超出圆角范围的子视图
    self.xinzengBtn.layer.masksToBounds = YES;
}

#pragma mark - <UICollectionViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    
//    return self.array.count;
    return 10;
}
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    ImgTitleCCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId forIndexPath:indexPath];
    
//    GongzhongClassModel* gongzhongModel = self.array[indexPath.row];
//
//    cell.textLabel.text = gongzhongModel.name;
//
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.image]] placeholderImage:[UIImage imageNamed:@"icon_hangong"]];
//    if (self.classSelectIndex == indexPath.row) {
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.selectimage]] placeholderImage:[UIImage imageNamed:@"icon_hangong_pre"]];
//    }
    
    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    
//    GongzhongClassModel* gongzhongModel = self.array[self.classSelectIndex];
//    GongzhongClassModel* gongzhongModel2 = self.array[indexPath.row];
    
//    ImgTitleCCell* selectCell = (ImgTitleCCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.classSelectIndex inSection:0]];
    
//    [selectCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.selectimage]] placeholderImage:[UIImage imageNamed:@"icon_hangong_pre"]];
//
//    ImgTitleCCell* cell = (ImgTitleCCell*)[collectionView cellForItemAtIndexPath:indexPath];
//
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel2.image]] placeholderImage:[UIImage imageNamed:@"icon_hangong"]];
//    self.classSelectIndex = indexPath.row;
//
//    //不同的工种有不同的材料分类
//    self.classDataArray = gongzhongModel2.category;
//    [self.classTableView reloadData];
//
//    [self.dataArray removeAllObjects];
//    [self.tableView reloadData];
//    if (self.classDataArray.count > 0) {
//        CailiaoClassModel* cailiaomodel = [CailiaoClassModel mj_objectWithKeyValues:self.classDataArray[0]];
//        self.categoryId = cailiaomodel.category_id;
//        [self getDataArrayFromServerIsRefresh:YES];
//        self.tableFootView.hidden=NO;
//    }else{
//        self.tableFootView.hidden=YES;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CartOrdeInfoModel *model=self.sectionArry[section];
    return model.stuff_info.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
    [view addSubview:self.xinzengView];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CailaodanEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CailaodanEditCell"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    CartOrdeInfoModel *model = self.sectionArry[indexPath.section];
    NSDictionary *dict = model.stuff_info[indexPath.row];
    StuffInfoModel *stuModel = [StuffInfoModel mj_objectWithKeyValues:dict];
    
    cell.nameLabel.text = stuModel.stuff_name;
    if ([stuModel.stuff_brand_name isKindOfClass:[NSNull class]]) {
        [cell.pinpaiBtn setTitle:@"没有数据" forState:UIControlStateNormal];
    }else{
        [cell.pinpaiBtn setTitle:stuModel.stuff_brand_name forState:UIControlStateNormal];
    }
    if ([stuModel.stuff_spec_name isKindOfClass:[NSNull class]]) {
        [cell.guigeBtn setTitle:@"没有数据" forState:UIControlStateNormal];
    }else{
        [cell.guigeBtn setTitle:stuModel.stuff_spec_name forState:UIControlStateNormal];
    }
    [cell.guigeBtn setTitle:stuModel.stuff_spec_name forState:UIControlStateNormal];
    cell.numberBtn.currentNumber=stuModel.number;
    //    __weak typeof (CailaodanEditCell *) weakself=cell;
    cell.moreBlock=^{
       
        
    };
    //品牌
    cell.pinpaiBlock = ^{
        //        添加品牌
    };
    cell.guigeBlock = ^{
        //        添加规格
    };
    cell.numBlock = ^(CGFloat num) {
        //        数量的变化
    };
    return cell;
}


@end
