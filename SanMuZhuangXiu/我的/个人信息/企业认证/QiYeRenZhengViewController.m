//
//  QiYeRenZhengViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/29.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "QiYeRenZhengViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "TZImagePickerController.h"

@interface QiYeRenZhengViewController ()<TZImagePickerControllerDelegate>
//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *tijiaoButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *yewuTF;
///营业执照
@property (weak, nonatomic) IBOutlet UIImageView *yingyeImageView;
@property (weak, nonatomic) IBOutlet UITextView *addressTV;
///上传图片
@property (weak, nonatomic) IBOutlet UIButton *shangchuanBtn;
///营业
@property(nonatomic,strong)NSMutableArray *yinyeArray;
///照片
@property (nonatomic, strong) NSMutableArray *photosArray;
///照片URL
@property (nonatomic, strong) NSArray *photoUrlArray;
///图片icon
@property (nonatomic, strong) NSString *iconStr;
///是否上传
@property (nonatomic, assign) BOOL isUploadpImg;
@end

@implementation QiYeRenZhengViewController
//
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"企业认证";
    self.shangchuanBtn.userInteractionEnabled = YES;
     self.tijiaoButton.userInteractionEnabled = YES;
    
    self.photosArray = [NSMutableArray array];
    self.photoUrlArray = [NSMutableArray array];
    self.yinyeArray=[NSMutableArray array];
    
    self.addressTV.layer.cornerRadius = 8;
    self.addressTV.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    self.addressTV.layer.borderWidth = 1;
    //请求数据
     [self loadQiyeRenzheng];
}
-(void)loadQiyeRenzheng{
//
    [DZNetworkingTool postWithUrl:kMyEnterpriseAuth params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
 
        if ([responseObject[@"code"] intValue] == SUCCESS) {
           
            NSDictionary *dict=responseObject[@"data"];
            if ([dict[@"is_auth_business"] isEqualToString:@"0"]) {
                 [DZTools showNOHud:@"您暂时没有申请，请填写企业信息" delay:1];
            }else if ([dict[@"is_auth_business"] isEqualToString:@"1"]){
                 self.shangchuanBtn.userInteractionEnabled = NO;
                 [DZTools showNOHud:@"认证申请中，请耐心等待" delay:1];
                self.shangchuanBtn.userInteractionEnabled = NO;
                NSDictionary *temp=dict[@"auth_info"];
                self.nameTF.text=[NSString stringWithFormat:@"%@",temp[@"company_name"]];
                self.phoneTF.text=[NSString stringWithFormat:@"%@",temp[@"phone"]];
                self.yewuTF.text=[NSString stringWithFormat:@"%@",temp[@"legal_person"]];
                self.addressTV.text=[NSString stringWithFormat:@"%@",temp[@"address"]];
                [self.yingyeImageView sd_setImageWithURL:[NSURL URLWithString:temp[@"compony_license"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
                self.tijiaoButton.userInteractionEnabled = NO;
                
            }else{
                 self.tijiaoButton.userInteractionEnabled = NO;
                 self.shangchuanBtn.userInteractionEnabled = NO;
                NSDictionary *temp=dict[@"auth_info"];
                self.nameTF.text=[NSString stringWithFormat:@"%@",temp[@"company_name"]];
                self.phoneTF.text=[NSString stringWithFormat:@"%@",temp[@"phone"]];
                self.yewuTF.text=[NSString stringWithFormat:@"%@",temp[@"legal_person"]];
                self.addressTV.text=[NSString stringWithFormat:@"%@",temp[@"address"]];
                 [self.yingyeImageView sd_setImageWithURL:[NSURL URLWithString:temp[@"compony_license"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            }
            
        }else
        {
           
//            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
-(void)loadYinyeData{
    
    [DZNetworkingTool postWithUrl:kManagementType params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            
            [self.yinyeArray removeAllObjects];
            NSArray *array=responseObject[@"data"][@"value"];
            for (NSDictionary *dict in array) {
                [self.yinyeArray addObject:dict];
            }
   
        }else
        {
//            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
-(void)loadImage{
    self.isUploadpImg = NO;
    if (self.photosArray.count == 0) {
        self.photoUrlArray = @[];
        self.isUploadpImg = YES;
    } else {
        
        [DZNetworkingTool uploadWithUrl:kUploadImgURL
                                 params:nil
                               fileData:self.photosArray
                                   name:@"img[]"
                               fileName:@"file.png"
                               mimeType:@"image/PNG"
                               progress:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                                        NSLog(@"%@", responseObject[@"data"]);
                                        self.isUploadpImg = YES;
                                        self.photoUrlArray = responseObject[@"data"];
                                        self.iconStr = self.photoUrlArray[0];
                                        [self.yingyeImageView sd_setImageWithURL:[NSURL URLWithString:self.iconStr]];
                                    }
                                }
                                 failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                 }
                              IsNeedHub:NO];
    }
}
#pragma mark-- XibFunction
//选择主营业务
- (IBAction)selectyewuBtnClicked:(id)sender {
   
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择主营业务" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < self.yinyeArray.count; i++) {
            NSDictionary *dict = self.yinyeArray[i];
            NSString *name=dict[@"k"];
            
            [alert addAction:[UIAlertAction actionWithTitle:name
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                        [self alertXinziClick:i];
                                                    }]];
        }
    
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertXinziClick:self.yinyeArray.count];
                                                }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
   
    
 
}
- (void)alertXinziClick:(NSInteger)rowInteger
{
   
    if (rowInteger < self.yinyeArray.count) {
//
        NSDictionary *dict = self.yinyeArray[rowInteger];
        self.yewuTF.text=[NSString stringWithFormat:@"%@",dict[@"k"]];

    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
//提交
- (IBAction)commitBtnClicked:(id)sender {
    
    [self.view endEditing:YES];
    if (self.nameTF.text.length<=0) {
         [DZTools showNOHud:@"公司名称不能为空" delay:2];
        return;
    }
    if (self.phoneTF.text.length<=0) {
        [DZTools showNOHud:@"联系方式不能为空" delay:2];
        return;
    }
    //电话号码非法验证
      NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTF.text];
    if (!isMatch) {
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    if (self.yewuTF.text.length<=0) {
        [DZTools showNOHud:@"企业法人不能为空" delay:2];
        return;
    }
    if (self.addressTV.text.length<=0) {
        [DZTools showNOHud:@"公司地址不能为空" delay:2];
        return;
    }
    if (self.iconStr.length == 0) {
        [DZTools showNOHud:@"请先上传营业执照" delay:2];
        return;
    }
    NSDictionary *dict=@{
                         @"company_name":self.nameTF.text,
                         @"phone":self.phoneTF.text,
                         @"legal_person":self.yewuTF.text,
                         @"address":self.addressTV.text,
                         @"compony_license":self.iconStr,
                         @"describe":@""
                         };
    [DZNetworkingTool postWithUrl:kAddEnterpriseAuth params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
           [DZTools showOKHud:responseObject[@"msg"] delay:2];
            //返回到指定的控制器，要保证前面有入栈。
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            if (index>4) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-4)] animated:YES];
            }else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];

}
//上传图片click
- (IBAction)shangchuanBtnClick:(id)sender {
    //设置头像
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self.photosArray removeAllObjects];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [self.photosArray addObjectsFromArray:photos];
        [self loadImage];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}
//取消编辑
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
