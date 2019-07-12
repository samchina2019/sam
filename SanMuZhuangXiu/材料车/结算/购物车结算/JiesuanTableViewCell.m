//
//  JiesuanTableViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/21.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JiesuanTableViewCell.h"
#import "JiesuanGoodsViewCell.h"
@interface JiesuanTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation JiesuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 5;
  
    self.cellTableView.delegate = self;
    self.cellTableView.dataSource = self;
    [self.cellTableView registerNib:[UINib nibWithNibName:@"JiesuanGoodsViewCell" bundle:nil] forCellReuseIdentifier:@"JiesuanGoodsViewCell"];
//    self.cellTableView.userInteractionEnabled=NO;
}

-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark--tableview deleteGate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.cellTableView.backgroundView = backgroundImageView;
        self.cellTableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.cellTableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JiesuanGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JiesuanGoodsViewCell" forIndexPath:indexPath];
    CartGoodListModel *dict=self.dataArray[indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dict.images]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.nameLabel.text = dict.goods_name;
    cell.guigeLabel.text = [NSString stringWithFormat:@"品牌:%@规格:%@",dict.stuff_brand_name,dict.stuff_spec_name];
    cell.priceLabel.text=[NSString stringWithFormat:@"¥%@",dict.goods_price];
    cell.numberLabel.text=[NSString stringWithFormat:@"x%d",dict.total_num];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark --Model
- (void)setModel:(CartSellerModel *)model
{
    _model = model;
    NSArray *goodsArray=model.data;

    [self.dataArray removeAllObjects];
    for (NSDictionary *dict in goodsArray) {
        
       CartGoodListModel *goodsModel=[CartGoodListModel mj_objectWithKeyValues:dict];
        [self.dataArray addObject:goodsModel];
    }
    [self.cellTableView reloadData];
    if (self.dataArray.count == 0) {
        self.tableViewHeight.constant = 0;
    }else{
        self.tableViewHeight.constant = ceil(_dataArray.count*110);
    }


}
#pragma mark --XibFunction

- (IBAction)fapiaoBtnClick:(id)sender {
    
    self.fapiaoBlock();
}
- (IBAction)youhuiquanBtnClick:(id)sender {
    
    self.youhuiquanBlock();
    
}
- (IBAction)jifenBtnClick:(id)sender {
    self.jifenBtn.selected = !self.jifenBtn.selected;
    self.jifenBlock(self.jifenBtn.selected);

}



@end
