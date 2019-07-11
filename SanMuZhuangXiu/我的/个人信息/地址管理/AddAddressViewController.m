//
//  AddAddressViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/28.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddressPickerView.h"
#import "ReLayoutButton.h"
@interface AddAddressViewController () <AddressPickerViewDelegate>
@property (nonatomic, strong) AddressPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (nonatomic, strong) NSString *addressStr;
@property (weak, nonatomic) IBOutlet UITextView *addressTV;
@property (weak, nonatomic) IBOutlet ReLayoutButton *quyuBtn;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新增地址";

    self.addressTV.layer.cornerRadius = 8;
    self.addressTV.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    self.addressTV.layer.borderWidth = 1;
}
#pragma mark - AddressPickerViewDelegate
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    [self.quyuBtn setTitle:[NSString stringWithFormat:@"%@%@%@", province, city, area] forState:UIControlStateNormal];

    self.addressStr = [NSString stringWithFormat:@"%@,%@,%@", province, city, area];

    [self.pickerView hide];
}
#pragma mark - Function
- (void)cancelBtnClick {
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
#pragma mark-- XibFunction

//确认添加
- (IBAction)commitBtnClicked:(id)sender {
    if (self.nameTF.text.length == 0) {
        [DZTools showNOHud:@"名字不能为空" delay:2];
        return;
    }
    if (self.phoneTF.text.length == 0) {
        [DZTools showNOHud:@"电话不能为空" delay:2];
        return;
    }
    if (self.addressTV.text.length == 0) {
        [DZTools showNOHud:@"详细地址不能为空" delay:2];
        return;
    }
    NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTF.text];
    if (!isMatch) {

        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }

    if (self.addressTV.text.length == 0) {
        [DZTools showNOHud:@"地址信息不能为空" delay:2];
        return;
    }
    NSDictionary *params = @{
        @"region": self.addressStr,
        @"name": self.nameTF.text,
        @"phone": self.phoneTF.text,
        @"detail": self.addressTV.text,
        @"isdefault": @(0)
    };
    [DZNetworkingTool postWithUrl:kAddressAdd
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//取消编辑
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)addressBtnClick:(id)sender {
    [self.view endEditing:YES];
    [[DZTools getAppWindow] addSubview:self.pickerView];
    [self.pickerView show];
}

#pragma mark – 懒加载
- (AddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}
@end
