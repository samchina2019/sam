//
//  ImagBtnCCell.h
//  HOOLA
//
//  Created by 犇犇网络 on 2018/9/20.
//  Copyright © 2018年 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"

@interface ImagBtnCCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet ReLayoutButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (copy, nonatomic) void(^block)(int tag);//1.删除 2.点击

@end
