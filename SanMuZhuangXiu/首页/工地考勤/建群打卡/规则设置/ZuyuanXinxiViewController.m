//
//  ZuyuanXinxiViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ZuyuanXinxiViewController.h"
#import "ReLayoutButton.h"

@interface ZuyuanXinxiViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
//基本信息视图
@property (weak, nonatomic) IBOutlet UIView *jibenXinxiView;
//人员昵称：xxx
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//状态：正常
@property (weak, nonatomic) IBOutlet ReLayoutButton *zhuangtaiBtn;
//联系方式：13526567147
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
//身份证
@property (weak, nonatomic) IBOutlet UITextField *IDCardTextField;
//工种
@property (weak, nonatomic) IBOutlet ReLayoutButton *gongzhongBtn;
//底部是图
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
//薪资设置view
@property (weak, nonatomic) IBOutlet UIView *XinziView;
//管理设置view
@property (weak, nonatomic) IBOutlet UIView *managerView;
//日工工资
@property (weak, nonatomic) IBOutlet UITextField *xinziTextField;
//加班工资
@property (weak, nonatomic) IBOutlet UITextField *jiabanTextField;
//计时工资
@property (weak, nonatomic) IBOutlet UIButton *xinziJishiBtn;
//计量工资
@property (weak, nonatomic) IBOutlet UIButton *xinziJijianBtn;
//普通工人
@property (weak, nonatomic) IBOutlet UIButton *workerBtn;
//管理人员
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;
//人员管理查看
@property (weak, nonatomic) IBOutlet UIButton *renyuanLookBtn;
//人员管理修改
@property (weak, nonatomic) IBOutlet UIButton *renyuanUpdateBtn;
//规则管理查看
@property (weak, nonatomic) IBOutlet UIButton *ruleLookBtn;
//规则管理修改
@property (weak, nonatomic) IBOutlet UIButton *ruleUpdateBtn;
//审核管理查看
@property (weak, nonatomic) IBOutlet UIButton *shenheLookBtn;
//审核管理修改
@property (weak, nonatomic) IBOutlet UIButton *shenheUpdateBtn;
//统计管理查看
@property (weak, nonatomic) IBOutlet UIButton *tongjiLookBtn;
//统计管理修改
@property (weak, nonatomic) IBOutlet UIButton *tongjiUpdateBtn;
@property (weak, nonatomic) IBOutlet UITextField *gongzhongTextField;


@property(nonatomic,strong)NSString *user_type;
@property(nonatomic,strong)NSString *salary_type;

@property(nonatomic,strong)NSMutableArray *gongzhongArray;
@property(nonatomic,strong)NSMutableArray *personnelArry;
@property(nonatomic,strong)NSMutableArray *ruleArry;
@property(nonatomic,strong)NSMutableArray *auditArry;
@property(nonatomic,strong)NSMutableArray *statisticalArry;
@end

@implementation ZuyuanXinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initItem];
    [self initBgView];

    [self initJibenxinxiView];
    [self initXinziView];
    [self initMamagerView];

    self.personnelArry=[NSMutableArray array];
    self.ruleArry=[NSMutableArray array];
    self.auditArry=[NSMutableArray array];
    self.gongzhongArray = [NSMutableArray array];
    self.statisticalArry=[NSMutableArray array];
    
    if ([self.personnel_management isEqualToString:@"3"]) {
        self.bgView.userInteractionEnabled=YES;

    }else  if ([self.personnel_management isEqualToString:@"2"]){
        self.bgView.userInteractionEnabled=NO;
    }
     [self loadPeopleData];
    [self loadGongzhong];
   self.user_type=@"2";
   self.salary_type=@"1";
}
#pragma mark – Network
-(void)loadGongzhong{
    [DZNetworkingTool postWithUrl:kWorkList params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [self.gongzhongArray removeAllObjects];
            NSArray * array = responseObject[@"data"][@"list"];
            for (NSDictionary * dict in array) {
                [self.gongzhongArray addObject:dict];
            }

        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
-(void)loadPeopleData{
    NSDictionary *dict=@{
                         @"group_id":@(self.group_id),
                         @"list_id":self.list_id
                         };
    [DZNetworkingTool postWithUrl:kGetUserInfo params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            self.phoneLabel.text=[NSString stringWithFormat:@"联系方式：%@",self.phoneStr];
            self.nameLabel.text=[NSString stringWithFormat:@"人员昵称：%@",dict[@"group_nickname"]];
            self.IDCardTextField.text=[NSString stringWithFormat:@"%@",dict[@"IDCard"]];
        
            if ([dict[@"name"] isKindOfClass:[NSNull class]]) {
                    self.realNameTextField.text=[NSString stringWithFormat:@""];
            }else{
                    self.realNameTextField.text=[NSString stringWithFormat:@"%@",dict[@"name"]];
            }
            self.xinziTextField.text=[NSString stringWithFormat:@"%@",dict[@"salary"]];
            [self.gongzhongBtn setTitle:[NSString stringWithFormat:@"%@",dict[@"group_nickname"]] forState:UIControlStateNormal];;
            if ([dict[@"salary_type"] isKindOfClass:[NSNull class]]) {
                self.xinziJishiBtn.selected=YES;
                self.xinziJijianBtn.selected=NO;
            }else if ([dict[@"salary_type"] isEqualToString:@"1"]){
                 self.xinziJishiBtn.selected=YES;
                self.xinziJijianBtn.selected=NO;
            }else if ([dict[@"salary_type"] isEqualToString:@"2"]){
                self.xinziJishiBtn.selected=NO;
                self.xinziJijianBtn.selected=YES;
            }
            if ([dict[@"overtime_salary"] isKindOfClass:[NSNull class]]) {
                self.jiabanTextField.text=[NSString stringWithFormat:@""];
            }else{
                self.jiabanTextField.text=[NSString stringWithFormat:@"%@",dict[@"overtime_salary"]];
            }
            if ([dict[@"user_type"] isKindOfClass:[NSNull class]]) {
                self.workerBtn.selected=YES;
                self.managerBtn.selected=NO;
            }else if([dict[@"user_type"] isEqualToString:@"1"]){
                  self.workerBtn.selected=YES;
                self.managerBtn.selected=NO;
            }else if ([dict[@"user_type"] isEqualToString:@"2"]){
                 self.workerBtn.selected=NO;
                self.managerBtn.selected=YES;
            }
            if ([dict[@"personnel_management"] containsString:@"1"]) {
                self.renyuanLookBtn.selected=YES;

            }
            if ([dict[@"personnel_management"] containsString:@"2"]){

                self.renyuanUpdateBtn.selected=YES;
            }
            if ([dict[@"rule_management"] containsString:@"1"]) {
                self.ruleLookBtn.selected=YES;

            }
            if ([dict[@"rule_management"] containsString:@"2"]){

                self.ruleUpdateBtn.selected=YES;
            }
            
            if ([dict[@"audit_management"] containsString:@"1"]) {
                self.shenheLookBtn.selected=YES;

            }
            if ([dict[@"audit_management"] containsString:@"2"]){

                self.shenheUpdateBtn.selected=YES;
            }
            
            if ([dict[@"statistical_management"] containsString:@"1"]) {
                self.tongjiLookBtn.selected=YES;
            }
            if ([dict[@"statistical_management"] containsString:@"2"]){
                self.tongjiUpdateBtn.selected=YES;
            }
            
        }else{
//             [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
-(void)initBgView{
    
    //设置圆角
    self.bgView.layer.cornerRadius = 3;
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    
}
-(void)initItem{
    self.navigationItem.title=@"组员信息设置";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x101010) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    if ([self.personnel_management isEqualToString:@"3"]) {
        button.userInteractionEnabled=YES;
        
        
    }else  if ([self.personnel_management isEqualToString:@"2"]){
        button.userInteractionEnabled=NO;
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

}
-(void)initJibenxinxiView{
    //设置圆角
    self.jibenXinxiView.layer.cornerRadius = 3;
    //阴影的颜色
    self.jibenXinxiView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.jibenXinxiView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.jibenXinxiView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.jibenXinxiView.layer.shadowOffset = CGSizeMake(0,0);
}
-(void)initXinziView{
    //设置圆角
    self.XinziView.layer.cornerRadius = 3;
    //阴影的颜色
    self.XinziView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.XinziView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.XinziView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.XinziView.layer.shadowOffset = CGSizeMake(0,0);
}
-(void)initMamagerView{
    
    //设置圆角
    self.managerView.layer.cornerRadius = 3;
    //阴影的颜色
    self.managerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.managerView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.managerView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.managerView.layer.shadowOffset = CGSizeMake(0,0);

}
//保存点击事件
-(void)rightBarButtonItemClicked{
    if (self.realNameTextField.text.length==0) {
        [DZTools showNOHud:@"用户名不能为空" delay:2];
        return;
    }
    if (self.IDCardTextField.text.length==0) {
        [DZTools showNOHud:@"身份证不能为空" delay:2];
        return;
    }
    if ([self.gongzhongBtn.titleLabel.text isEqualToString:@"请选择工种"]) {
        [DZTools showNOHud:@"工种不能为空" delay:2];
        return;
    }
    if (self.xinziTextField.text.length==0) {
        [DZTools showNOHud:@"薪资不能为空" delay:2];
        return;
    }
    if (self.jiabanTextField.text.length==0) {
        [DZTools showNOHud:@"加班薪资不能为空" delay:2];
        return;
    }
        if ( self.personnelArry.count==0) {
            [DZTools showNOHud:@"此项必须选择" delay:2];
            return;
        }
        if ( self.ruleArry.count==0) {
            [DZTools showNOHud:@"此项必须选择" delay:2];
            return;
        }
        if ( self.auditArry.count==0) {
            [DZTools showNOHud:@"此项必须选择" delay:2];
            return;
        }
        if ( self.statisticalArry.count==0) {
            [DZTools showNOHud:@"此项必须选择" delay:2];
            return;
        }
   

    NSDictionary *dict=@{
                         @"group_id":@(self.group_id),
                         @"list_id":self.list_id,
                         @"name":self.realNameTextField.text,
                         @"IDCard":self.IDCardTextField.text,
                         @"work_type":self.gongzhongBtn.titleLabel.text,
                         @"salary":self.xinziTextField.text,
                         @"salary_type":self.salary_type,
                         @"overtime_salary":self.jiabanTextField.text,
                         @"user_type":self.user_type,
                         @"personnel_management":[self.personnelArry componentsJoinedByString:@","],
                         @"rule_management":[self.ruleArry componentsJoinedByString:@","],
                         @"audit_management":[self.auditArry componentsJoinedByString:@","],
                         @"statistical_management":[self.statisticalArry componentsJoinedByString:@","]
 
                         };
    [DZNetworkingTool postWithUrl:kSetUserInfo params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] ==SUCCESS) {
            
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
             [self.navigationController popViewControllerAnimated:YES];
            
        }else{
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];

}
//结束编辑事件
- (IBAction)endEditing:(id)sender {
     [self.backGroundView endEditing:YES];
}

//薪资按钮的点击事件
- (IBAction)xinziBtnClick:(UIButton *)sender {
    
    if ( self.xinziJishiBtn.selected==YES) {
        self.xinziJishiBtn.selected = !self.xinziJishiBtn.selected;
        self.xinziJijianBtn.selected=YES;
        self.salary_type=@"1";
    }else{
        
        self.xinziJijianBtn.selected=!self.xinziJijianBtn.selected;
        self.xinziJishiBtn.selected=YES;
        self.salary_type=@"2";
    }
}

//管理设置按钮的点击事件
- (IBAction)guanliBtnClick:(UIButton *)sender {
   
    
    if ( self.workerBtn.selected==YES) {
        self.workerBtn.selected = !self.workerBtn.selected;
        self.managerBtn.selected=YES;
        self.user_type=@"2";
    }else{
        
        self.managerBtn.selected=!self.managerBtn.selected;
        self.workerBtn.selected=YES;
        self.user_type=@"1";
    }
    
}

//人员管理按钮的点击事件
- (IBAction)renyuanManageBtnClick:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    if (sender.selected) {
        [self.personnelArry addObject:@(sender.tag)];
    }else{
        [self.personnelArry removeObject:@(sender.tag)];
    }
    
}


//规则管理按钮的点击事件
- (IBAction)ruleManageBtnClick:(UIButton *)sender {

    sender.selected=!sender.selected;
    if (sender.selected) {
        [self.ruleArry addObject:@(sender.tag)];
    }else{
        [self.ruleArry removeObject:@(sender.tag)];
    }
        
}


//审核管理按钮的点击事件
- (IBAction)shenheManageBtnClick:(UIButton *)sender {

    sender.selected=!sender.selected;
    if (sender.selected) {
        [self.auditArry addObject:@(sender.tag)];
    }else{
        [self.auditArry removeObject:@(sender.tag)];
    }

}

//统计管理按钮的点击事件
- (IBAction)tongjiManageBtnClick:(UIButton *)sender {
    
    
    sender.selected=!sender.selected;
    if (sender.selected) {
        [self.statisticalArry addObject:@(sender.tag)];
    }else{
        [self.statisticalArry removeObject:@(sender.tag)];
    }

}
//确定按钮的点击事件
- (IBAction)sureBtnClick:(id)sender {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)gongzongBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择工种类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.gongzhongArray.count; i ++) {

        [alert addAction:[UIAlertAction actionWithTitle: self.gongzhongArray[i][@"workname"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertClick:i];
        }]];
        
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self alertClick:self.gongzhongArray.count];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];


}
- (void)alertClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.gongzhongArray.count) {

        [self.gongzhongBtn setTitle:self.gongzhongArray[rowInteger][@"workname"] forState:UIControlStateNormal];
        self.gongzhongBtn.imageView.hidden=YES;

    }
    [self dismissViewControllerAnimated:YES completion:nil];
        
    
}


@end
