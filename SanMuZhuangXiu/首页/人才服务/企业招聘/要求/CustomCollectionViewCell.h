//
//  CustomCollectionViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

/**
 *  数据
 */
@property (nonatomic, strong) id           data;

/**
 *  indexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 * 设置cell的基本属性
 */
- (void)setUpCell;

/**
 *  控件的添加
 */
- (void)buildUpSubviews;

/**
 *  加载数据
 */
- (void)loadContent;

/**
 *  点击事件
 */
- (void)touchEvent;

@end
