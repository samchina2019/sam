//
//  InputCaigoudanView.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "InputCaigoudanView.h"
#import "InputCaigoudanCell.h"
#import "CartListModel.h"
#import "JieSuanViewController.h"

@interface InputCaigoudanView ()
@property (nonatomic, strong) NSMutableArray *selectData;
@property (nonatomic, strong) NSString *name;
@end
@implementation InputCaigoudanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"InputCaigoudanView" owner:self options:nil][0];
        self.frame = frame;
        self.selectData = [NSMutableArray array];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"InputCaigoudanCell" bundle:nil] forCellReuseIdentifier:@"InputCaigoudanCell"];
    }
    return self;
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.tableView.backgroundView = backgroundImageView;
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.tableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 105;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputCaigoudanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputCaigoudanCell" forIndexPath:indexPath];
    CartListModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.classNumLabel.text = [NSString stringWithFormat:@"材料种类：%ld种", (long) model.stuff_number];
    cell.timeLabel.text = model.updatetime;
    //    状态值:-1=禁用,0=自动保存,1=等待发布（未采购）,2=发布采购报价中（未采购）,3=交易中（已采购）,4=交易完成,5=交易失败'
    NSString *statStr = model.status;

    if ([statStr isEqualToString:@"1"]) {
        cell.buyLabel.layer.borderColor = UIColorFromRGB(0xFA5458).CGColor;
        cell.buyLabel.text = @"未采购";

    } else if ([statStr isEqualToString:@"3"]) {
        cell.buyLabel.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        cell.buyLabel.textColor = UIColorFromRGB(0x999999);
        cell.buyLabel.text = @"已采购";
    }

    if ([self.selectData containsObject:@(model.stuff_cart_id)]) {
        cell.selectBtn.selected = YES;
    } else {
        cell.selectBtn.selected = NO;
    }
    cell.selectBlock = ^(BOOL isSelected) {
        [self.selectData removeAllObjects];
        if (isSelected) {
            self.name = model.name;
            [self.selectData addObject:@(model.stuff_cart_id)];
        } else {
            [self.selectData removeObject:@(model.stuff_cart_id)];
        }
        [self.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - XibFunction
//取消
- (IBAction)cancleBtnClicked:(id)sender {
    [self removeFromSuperview];
}
//确认导入
- (IBAction)commitBtnClicked:(id)sender {
//    double latitude = [DZTools getAppDelegate].latitude;
//    double longitude = [DZTools getAppDelegate].longitude;
    [self removeFromSuperview];
    if (self.selectData.count == 0) {
        [DZTools showNOHud:@"请选择要导入的材料单" delay:2];
        return;
    }
    
    NSDictionary *dict = @{
        @"stuff_cart_id": self.selectData[0],
        @"seller_id": self.seller_id,
    };
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"CartData" object:nil userInfo:dict];
}
    




@end
