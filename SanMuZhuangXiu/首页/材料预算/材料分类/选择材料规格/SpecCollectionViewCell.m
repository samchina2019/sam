//
//  SpecCollectionViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SpecCollectionViewCell.h"
#import "SelectCollectionViewCell.h"

#import "SpecGuigeModel.h"
@interface SpecCollectionViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>



@end
@implementation SpecCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = (ViewWidth - CGRectGetMaxX(self.nameLabel.frame)-18)/4;
    layout.itemSize = CGSizeMake(width, 30);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    
     self.dataArray=[NSArray array];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
   
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SelectCollectionViewCell"];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCollectionViewCell" forIndexPath:indexPath];

   SpecGuigeModel *model=self.dataArray[indexPath.row];
    cell.nameLabel.text =model.name;
    if(indexPath.item==self.lastNum) {
        
        model.isSelected=YES;
        
        cell.nameLabel.backgroundColor=RGBCOLOR(217, 231, 253);
        cell.nameLabel.borderColor=UIColorFromRGB(0x3FAEE9);
        cell.nameLabel.textColor=[MTool colorWithHexString:@"#2e8cff"];
    }else{
        
        model.isSelected=NO;
        
       cell.nameLabel.backgroundColor=[MTool colorWithHexString:@"#f5f5f5"];
       cell.nameLabel.borderColor=[UIColor clearColor];
        cell.nameLabel.textColor=[MTool colorWithHexString:@"#7f8082"];

    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

     SpecGuigeModel *model=self.dataArray[indexPath.row];

    self.lastNum= indexPath.row;

   [self.collectionView   reloadData];
    self.cellBlock(self.dataArray[indexPath.row]);

}


-(void)setDataArray:(NSArray *)dataArray{
    
    
        _dataArray = dataArray;
    
        if (_dataArray.count == 0) {
            self.collectionHeight.constant = 50;

        }else{
         
            self.collectionHeight.constant = ceil(((dataArray.count - 1) / 4 + 1) * 30 + 5 * floorf((dataArray.count - 1) / 4));
        }
        [self.collectionView reloadData];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
