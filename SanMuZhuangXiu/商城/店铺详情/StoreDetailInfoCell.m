//
//  StoreDetailInfoCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreDetailInfoCell.h"
#import "MyPingJiaImgCollectionViewCell.h"

static NSString *const imgCellId = @"imgCellId";

@implementation StoreDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = (ViewWidth - 40)/3;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.imgCollectionView.collectionViewLayout = layout;
    self.imgCollectionView.delegate = self;
    self.imgCollectionView.dataSource = self;
    [self.imgCollectionView registerNib:[UINib nibWithNibName:@"MyPingJiaImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:imgCellId];
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
    
    MyPingJiaImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId forIndexPath:indexPath];
    if ([self.array[indexPath.row] containsString:@"http://"]) {
         [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.array[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }else{
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMageUrl,self.array[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}
#pragma mark - UICollectionViewDelegate
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    if (array.count == 0) {
        self.layoutConstraint.constant = 0;
    }else{
        self.layoutConstraint.constant = ceil(((array.count - 1) / 3 + 1) * (ViewWidth - 40) / 3.0 + 5 * floorf((array.count - 1) / 3));
    }
    [self.imgCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
