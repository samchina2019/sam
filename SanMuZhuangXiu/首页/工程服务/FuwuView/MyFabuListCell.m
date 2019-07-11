//
//  MyFabuListCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyFabuListCell.h"

@interface MyFabuListCell()<YBPopupMenuDelegate>
@property(nonatomic,strong)NSArray *tilteArray;
@property (weak, nonatomic) IBOutlet UIView *bgView;



@end
@implementation MyFabuListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 3;
    
   self.tilteArray=[NSArray arrayWithObjects:@"删除",@"分享",@"编辑" ,nil];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    !self.moreBlock ? : self.moreBlock(index);
}

#pragma mark -- XibFunction
//下架 tag=100；刷新 200；置顶 300
- (IBAction)xiajiaBtnClick:(id)sender {
    
    //回调事件
    if (self.cellButtonClickedHandler) {
        self.cellButtonClickedHandler(self, sender);
    }
    
}

- (IBAction)moreBtnClick:(id)sender {
    //    !self.moreBlock ? : self.moreBlock();
    if (self.tilteArray.count > 0) {
        [YBPopupMenu showRelyOnView:sender titles:self.tilteArray icons:nil menuWidth:76 otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.dismissOnSelected = YES;
            popupMenu.isShowShadow = YES;
            popupMenu.delegate = self;
            popupMenu.type = YBPopupMenuTypeDefault;
            popupMenu.cornerRadius = 8;
            popupMenu.tag = 100;
            popupMenu.backColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            popupMenu.separatorColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            popupMenu.textColor=[UIColor whiteColor];
            
            popupMenu.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        }];
    }else{
        //        [HUTools showNOHud:Localized(@"正在请求分类列表，请稍后重试！") delay:2.0];
        //        [self initData];
    }
}

@end
