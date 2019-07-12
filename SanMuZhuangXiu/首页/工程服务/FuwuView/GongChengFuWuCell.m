//
//  GongChengFuWuCell.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GongChengFuWuCell.h"
#import "GongChengFuWuCCell.h"

static NSString *const imgCellId = @"imgCellId";
@implementation GongChengFuWuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = (ViewWidth - 30)/3;
    layout.itemSize = CGSizeMake(width, 90);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"GongChengFuWuCCell" bundle:nil] forCellWithReuseIdentifier:imgCellId];
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GongChengFuWuCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId forIndexPath:indexPath];
    NSDictionary *dict = self.array[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.nameLabel.text = dict[@"name"];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}
#pragma mark - UICollectionViewDelegate
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.array[indexPath.row];
    self.block([dict[@"id"] intValue],dict[@"name"]);
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    if (array.count == 0) {
        self.collectionViewHeight.constant = 0;
    }else{
        self.collectionViewHeight.constant = ceil(array.count/3.0)*90;
    }
    [self.collectionView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
