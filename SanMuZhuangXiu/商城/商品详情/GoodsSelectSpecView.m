//
//  EditSpecView.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GoodsSelectSpecView.h"
#import "SpecCollectionViewCell.h"
#import "SelectSpecTableViewCell.h"
#import "GuigeModel.h"
#import "SpecGuigeModel.h"
@interface GoodsSelectSpecView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *specIdArray;
@property (nonatomic, strong) NSString *goods_num;
@property (nonatomic, strong) NSString *pingPaiID;
@property (nonatomic, strong) NSString *pingPaiName;
@property (nonatomic, strong) NSString *goods_spec_id;
@property (nonatomic, strong) NSString *goods_price;

@end
@implementation GoodsSelectSpecView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"GoodsSelectSpecView" owner:self options:nil][0];
        self.frame = frame;
    }
    self.dataArray = [NSMutableArray array];

    self.specIdArray = [NSMutableArray arrayWithCapacity:0];

    [self initTableView];
    self.numberBtn.currentNumber = 1;
    self.numberBtn.minValue = 1;
    self.goods_num = @"1";
    self.numberBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        self.goods_num = [NSString stringWithFormat:@"%.f",number];
    };

    return self;
}
#pragma mark – UI

- (void)initTableView {
    self.guigeView.delegate = self;
    self.guigeView.dataSource = self;

    [self.guigeView registerNib:[UINib nibWithNibName:@"SpecCollectionViewCell" bundle:nil] forCellReuseIdentifier:@"SpecCollectionViewCell"];
    self.guigeView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.dataArray.count;
    }else{
        if (self.pingPaiArray) {
            return 1;
        }else{
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SpecCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecCollectionViewCell"];
    if (indexPath.section == 0) {

        GuigeModel *guigeModel = self.dataArray[indexPath.row];

        cell.nameLabel.text = guigeModel.spec_name;
        NSMutableArray *temp = [NSMutableArray array];

        NSArray *array = guigeModel.data;
        for (NSDictionary *dict in array) {
            SpecGuigeModel *model = [[SpecGuigeModel alloc]init];
            model.stuff_spec_id = [dict[@"item_id"] integerValue];
            model.name = dict[@"spec_value"];
            [temp addObject:model];
        }
        cell.dataArray = [temp mutableCopy];

        if (guigeModel.data.count == 0) {
            cell.collectionHeight.constant = 50;
        } else {
            cell.collectionHeight.constant = ceil(((guigeModel.data.count - 1) / 4 + 1) * 30 + 5 * floorf((guigeModel.data.count - 1) / 4));
        }
        [cell.collectionView reloadData];
        cell.cellBlock = ^(SpecGuigeModel *model) {
            [self.tempArray replaceObjectAtIndex:indexPath.row withObject:model];
            [self resetheaderInfo];
        };
    }else{
        cell.nameLabel.text = @"品牌";
        NSMutableArray *temp = [NSMutableArray array];
        NSArray *array = self.pingPaiArray;
        for (NSDictionary *dict in array) {
            SpecGuigeModel *model = [[SpecGuigeModel alloc]init];
            if ([[dict allKeys] containsObject:@"brand_id"]) {
                model.stuff_spec_id = [dict[@"brand_id"] integerValue];
                model.name = dict[@"brand_name"];
            }else{
                model.stuff_spec_id = [dict[@"id"] integerValue];
                model.name = dict[@"name"];
            }
            [temp addObject:model];
        }
        cell.dataArray = [temp mutableCopy];
        
        if (array.count == 0) {
            cell.collectionHeight.constant = 50;
        } else {
            cell.collectionHeight.constant = ceil(((array.count - 1) / 4 + 1) * 30 + 5 * floorf((array.count - 1) / 4));
        }
        [cell.collectionView reloadData];
        cell.cellBlock = ^(SpecGuigeModel *model) {
            self.pingPaiID = [NSString stringWithFormat:@"%ld", (long)model.stuff_spec_id];
            self.pingPaiName = model.name;
            [self resetheaderInfo];
        };
    }
    return cell;
}



#pragma mark - Function

- (void)resetheaderInfo {
    NSString *nameStr = @"";
    NSString *idStr = @"";
    for (int i = 0; i < self.tempArray.count; i++) {
        SpecGuigeModel *model = self.tempArray[i];
        nameStr = [nameStr stringByAppendingFormat:@"%@ ", model.name];
        idStr = [idStr stringByAppendingFormat:@"%ld_", (long)model.stuff_spec_id];
    }
    BOOL isCunZai = NO;
    for (NSDictionary *dict in self.dataDict[@"specData"][@"spec_list"]) {
        if ([idStr containsString:dict[@"spec_sku_id"]] && [self.pingPaiID intValue] == [dict[@"stuff_brand_id"] intValue]) {
            self.priceLabel.text = dict[@"form"][@"goods_price"];
//            [self.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"form"][@"imgshow"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            self.nameLabel.text = self.dataDict[@"detail"][@"goods_name"];
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",dict[@"form"][@"goods_price"]];
            self.goods_spec_id = [NSString stringWithFormat:@"%@",dict[@"goods_spec_id"]];;
            isCunZai = YES;
            self.goods_price = dict[@"form"][@"goods_price"];
        }
    }
    if (!isCunZai) {
//        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"detail"][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        self.nameLabel.text = self.dataDict[@"detail"][@"goods_name"];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.dataDict[@"detail"][@"goods_price"]];
        self.goods_spec_id = @"";
        self.goods_price = [NSString stringWithFormat:@"%@",self.dataDict[@"detail"][@"goods_price"]];
    }
}

#pragma mark – XibFunction

- (IBAction)cancelBtnCLick:(id)sender {
    [self removeFromSuperview];
    self.deleteBlock();
}

- (IBAction)sureAddBtnClick:(id)sender {
    if (self.tempArray.count == 0) {
        [DZTools showNOHud:@"暂无规格" delay:2];
        return;
    }

    NSLog(@"%@", self.tempArray);
    NSString *nameStr = @"";
    NSString *idStr = @"";
    for (int i = 0; i < self.tempArray.count; i ++) {
        SpecGuigeModel *model = self.tempArray[i];
        if (i == 0) {
            idStr = [NSString stringWithFormat:@"%ld",(long)model.stuff_spec_id];
            nameStr = model.name;
        }else{
            nameStr = [NSString stringWithFormat:@"%@ %@", nameStr, model.name];
            idStr = [NSString stringWithFormat:@"%@_%ld", idStr, (long)model.stuff_spec_id];
        }
    }
    self.sureBlock(self.goods_num, idStr, nameStr, self.goods_spec_id, self.pingPaiID, self.dataDict[@"detail"][@"goods_name"], self.goods_price, self.pingPaiName ,self.cartTiaozhuan);
    [self removeFromSuperview];
    self.deleteBlock();
}

#pragma mark – 懒加载
- (NSMutableArray *)tempArray {
    if (!_tempArray) {
        _tempArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tempArray;
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tempArray removeAllObjects];
    if (_dataArray.count != 0) {
        for (GuigeModel *guigeModel in dataArray) {
            NSArray *array = guigeModel.data;
            SpecGuigeModel *model = [[SpecGuigeModel alloc]init];
            model.stuff_spec_id = [array[0][@"item_id"] integerValue];
            model.name = array[0][@"spec_value"];
            [self.tempArray addObject:model];
        }
    }
    [self resetheaderInfo];
    [self.guigeView reloadData];
}
- (void)setPingPaiArray:(NSMutableArray *)pingPaiArray
{
    _pingPaiArray = pingPaiArray;
    if (pingPaiArray.count > 0) {
        if ([[pingPaiArray[0] allKeys] containsObject:@"brand_id"]) {
            self.pingPaiID = [NSString stringWithFormat:@"%@", pingPaiArray[0][@"brand_id"]];
            self.pingPaiName = pingPaiArray[0][@"brand_name"];
        }else{
            self.pingPaiID = [NSString stringWithFormat:@"%@", pingPaiArray[0][@"id"]];
            self.pingPaiName = pingPaiArray[0][@"name"];
        }
    }else{
        self.pingPaiID = @"0";
    }
    [self resetheaderInfo];
    [self.guigeView reloadData];
}
-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
     [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    [self.guigeView reloadData];
}
@end
