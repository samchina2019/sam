//
//  HomeViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "CaiLiaoYuSuanViewController.h"
#import "RenCaiFuWuViewController.h"
#import "GongDiKaoQinViewController.h"
#import "JiFenStoreViewController.h"
#import "GongchengfuwuViewController.h"
#import "WebViewViewController.h"
#import "StoreDetailViewController.h"
#import <UShareUI/UShareUI.h>
#import "NewCaiLiaoViewController.h"
#import "CaiLiaoFenLeiViewController.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>

//@property (weak, nonatomic) IBOutlet UIView *lunboView;
//@property (weak, nonatomic) IBOutlet UILabel *numLabel1;
//@property (weak, nonatomic) IBOutlet UILabel *numLabel2;
//@property (weak, nonatomic) IBOutlet UILabel *numLabel3;
//@property (weak, nonatomic) IBOutlet UILabel *numLabel4;
//@property (weak, nonatomic) IBOutlet UILabel *numLabel5;
//@property (weak, nonatomic) IBOutlet UILabel *numLabel6;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *lunboArray;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([DZTools islogin]) {
        [self getDataFromServer];
    }
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
    // Do any additional setup after loading the view from its nib.
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SafeAreaTopHeight-Nav_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH/750*406) imageNamesGroup: @[@"home_pic_banner1",@"home_pic_banner2",@"home_pic_banner3"]];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    [SDCycleScrollView clearImagesCache]; 
    [self.view addSubview:self.cycleScrollView];
    

   [self CreatUI];
}

-(void)CreatUI{
    UIView*FuWuView=[[UIView alloc]initWithFrame:CGRectMake(0, self.cycleScrollView.bottom, SCREEN_WIDTH, 294*SCREEN_WIDTH/750)];
   
    FuWuView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:FuWuView];
    
    UILabel*TitleLab=[MTool quickCreateLabelWithleft:30*SCREEN_WIDTH/750 top:0 width:SCREEN_WIDTH heigh:100*SCREEN_WIDTH/750 title:@"特色服务"];
    TitleLab.font=[UIFont fontWithName:@"Helvetica-Bold" size:32*SCREEN_WIDTH/750];
    [FuWuView addSubview:TitleLab];
    
    //分割线
    UIView*lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 100*SCREEN_WIDTH/750 , SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [MTool colorWithHexString:@"#edeff2"];
    [FuWuView addSubview:lineView];
    //材料预算
    UIImageView*YuSuanImg=[[UIImageView alloc]initWithFrame:CGRectMake(100*SCREEN_WIDTH/750, 100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [YuSuanImg setImage:[UIImage imageNamed:@"home_icon_budget"]];
    [FuWuView addSubview:YuSuanImg];
    UILabel*YuSuanLab=[MTool quickCreateLabelWithleft:10*SCREEN_WIDTH/750 top:100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750+76*SCREEN_WIDTH/750+20*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:44*SCREEN_WIDTH/750 title:@"材料预算"];
    YuSuanLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    YuSuanLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    YuSuanLab.textAlignment=NSTextAlignmentCenter;
    [FuWuView addSubview:YuSuanLab];
    
    UIButton *YuSuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    YuSuanBtn.frame = CGRectMake(0, lineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_WIDTH/750);
    [YuSuanBtn setBackgroundColor:[UIColor clearColor]];
    [YuSuanBtn addTarget:self action:@selector(cailiaoyusuan:) forControlEvents:UIControlEventTouchUpInside];
    [FuWuView addSubview:YuSuanBtn];
    
   
    //工地打卡
    UIImageView*DakaImg=[[UIImageView alloc]initWithFrame:CGRectMake(340*SCREEN_WIDTH/750, 100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [DakaImg setImage:[UIImage imageNamed:@"home_icon_work"]];
    [FuWuView addSubview:DakaImg];
    UILabel*DakaLab=[MTool quickCreateLabelWithleft:5*SCREEN_WIDTH/750+SCREEN_WIDTH/3 top:100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750+76*SCREEN_WIDTH/750+20*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:44*SCREEN_WIDTH/750 title:@"工地打卡"];
    DakaLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    DakaLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    DakaLab.textAlignment=NSTextAlignmentCenter;
    [FuWuView addSubview:DakaLab];
    UIButton *DakaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    DakaBtn.frame = CGRectMake(SCREEN_WIDTH/3, lineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_WIDTH/750);
    [DakaBtn setBackgroundColor:[UIColor clearColor]];
    [DakaBtn addTarget:self action:@selector(gongdikaoqin:) forControlEvents:UIControlEventTouchUpInside];
    [FuWuView addSubview:DakaBtn];
    
    
    //工地找人
    UIImageView*peopleImg=[[UIImageView alloc]initWithFrame:CGRectMake(566*SCREEN_WIDTH/750, 100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [peopleImg setImage:[UIImage imageNamed:@"home_icon_personnel"]];
    [FuWuView addSubview:peopleImg];
    UILabel*peopleLab=[MTool quickCreateLabelWithleft:2*SCREEN_WIDTH/3-15*SCREEN_WIDTH/750 top:100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750+76*SCREEN_WIDTH/750+20*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:44*SCREEN_WIDTH/750 title:@"工地找人"];
    peopleLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    peopleLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    peopleLab.textAlignment=NSTextAlignmentCenter;
    [FuWuView addSubview:peopleLab];
    UIButton *rencaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rencaiBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, lineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_WIDTH/750);
    [rencaiBtn setBackgroundColor:[UIColor clearColor]];
    [rencaiBtn addTarget:self action:@selector(rencaifuwu:) forControlEvents:UIControlEventTouchUpInside];
    [FuWuView addSubview:rencaiBtn];
    
   
    
    
    //配套服务
    
    UIView*PeiTaoFuWuView=[[UIView alloc]initWithFrame:CGRectMake(0, FuWuView.bottom+16*SCREEN_WIDTH/750, SCREEN_WIDTH, 294*SCREEN_WIDTH/750)];
    PeiTaoFuWuView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:PeiTaoFuWuView];
    
    UILabel*PeiTaoFuWuLab=[MTool quickCreateLabelWithleft:30*SCREEN_WIDTH/750 top:0 width:SCREEN_WIDTH heigh:100*SCREEN_WIDTH/750 title:@"配套服务"];
    PeiTaoFuWuLab.font=[UIFont fontWithName:@"Helvetica-Bold" size:32*SCREEN_WIDTH/750];
    [PeiTaoFuWuView addSubview:PeiTaoFuWuLab];
    
    //分割线
    UIView*PeiTaoFuWulineView = [[UIView alloc]initWithFrame:CGRectMake(0, 100*SCREEN_WIDTH/750 , SCREEN_WIDTH, 1)];
    PeiTaoFuWulineView.backgroundColor = [MTool colorWithHexString:@"#edeff2"];
    [PeiTaoFuWuView addSubview:PeiTaoFuWulineView];
    
    
    //工程服务
    UIImageView*GongChengImg=[[UIImageView alloc]initWithFrame:CGRectMake(100*SCREEN_WIDTH/750, 100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [GongChengImg setImage:[UIImage imageNamed:@"home_icon_ project"]];
    [PeiTaoFuWuView addSubview:GongChengImg];
    UILabel*GongChengLab=[MTool quickCreateLabelWithleft:10*SCREEN_WIDTH/750 top:100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750+76*SCREEN_WIDTH/750+20*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:44*SCREEN_WIDTH/750 title:@"工程服务"];
   GongChengLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    GongChengLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
   GongChengLab.textAlignment=NSTextAlignmentCenter;
    [PeiTaoFuWuView addSubview:GongChengLab];
    
    UIButton *GongChengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    GongChengBtn.frame = CGRectMake(0, PeiTaoFuWulineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_WIDTH/750);
    [GongChengBtn setBackgroundColor:[UIColor clearColor]];
    [GongChengBtn addTarget:self action:@selector(gongchengfuwu:) forControlEvents:UIControlEventTouchUpInside];
    [PeiTaoFuWuView addSubview:GongChengBtn];
    
    
   
    //法律法规
    UIImageView*LawImg=[[UIImageView alloc]initWithFrame:CGRectMake(340*SCREEN_WIDTH/750, 100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [LawImg setImage:[UIImage imageNamed:@"home_icon_law"]];
    [PeiTaoFuWuView addSubview:LawImg];
    UILabel*LawLab=[MTool quickCreateLabelWithleft:5*SCREEN_WIDTH/750+SCREEN_WIDTH/3 top:100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750+76*SCREEN_WIDTH/750+20*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:44*SCREEN_WIDTH/750 title:@"法律法规"];
    LawLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    LawLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    LawLab.textAlignment=NSTextAlignmentCenter;
    [PeiTaoFuWuView addSubview:LawLab];
    
    UIButton * LawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LawBtn.frame = CGRectMake(SCREEN_WIDTH/3, PeiTaoFuWulineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_WIDTH/750);
    [LawBtn setBackgroundColor:[UIColor clearColor]];
    [LawBtn addTarget:self action:@selector(law:) forControlEvents:UIControlEventTouchUpInside];
    [PeiTaoFuWuView addSubview:LawBtn];
    
   
    
    //装修展示Show
    UIImageView*ShowImg=[[UIImageView alloc]initWithFrame:CGRectMake(566*SCREEN_WIDTH/750, 100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [ShowImg setImage:[UIImage imageNamed:@"home_icon_show"]];
    [PeiTaoFuWuView addSubview:ShowImg];
    UILabel*ShowLab=[MTool quickCreateLabelWithleft:2*SCREEN_WIDTH/3-15*SCREEN_WIDTH/750 top:100*SCREEN_WIDTH/750+36*SCREEN_WIDTH/750+76*SCREEN_WIDTH/750+20*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:44*SCREEN_WIDTH/750 title:@"装修展示"];
    ShowLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    ShowLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    ShowLab.textAlignment=NSTextAlignmentCenter;
    [PeiTaoFuWuView addSubview:ShowLab];
    
    UIButton * ShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ShowBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, PeiTaoFuWulineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_WIDTH/750);
    [ShowBtn setBackgroundColor:[UIColor clearColor]];
    [ShowBtn addTarget:self action:@selector(Show:) forControlEvents:UIControlEventTouchUpInside];
      [PeiTaoFuWuView addSubview:ShowBtn];
    
    //推荐有礼 tuijianyouli
    UIView*ShareView=[[UIView alloc]initWithFrame:CGRectMake(0, PeiTaoFuWuView.bottom+16*SCREEN_WIDTH/750, 364*SCREEN_WIDTH/750, 146*SCREEN_WIDTH/750)];
    ShareView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:ShareView];
    
    UIImageView*ShareImg=[[UIImageView alloc]initWithFrame:CGRectMake(76*SCREEN_WIDTH/750, 36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [ShareImg setImage:[UIImage imageNamed:@"home_icon_Recommend"]];
    [ShareView addSubview:ShareImg];
    UILabel*ShareLab=[MTool quickCreateLabelWithleft:20*SCREEN_WIDTH/750+ShareImg.right top:36*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:76*SCREEN_WIDTH/750 title:@"推荐有礼"];
    ShareLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    ShareLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    [ShareView addSubview:ShareLab];
    UIButton * tuijianyouliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tuijianyouliBtn.frame = CGRectMake(0, 0, 364*SCREEN_WIDTH/750, 146*SCREEN_WIDTH/750);
    [tuijianyouliBtn setBackgroundColor:[UIColor clearColor]];
    [tuijianyouliBtn addTarget:self action:@selector(tuijianyouli:) forControlEvents:UIControlEventTouchUpInside];
    [ShareView addSubview:tuijianyouliBtn];
    
    
   
    //帮助与反馈
    UIView*HelpView=[[UIView alloc]initWithFrame:CGRectMake(ShareView.right+16*SCREEN_WIDTH/750, PeiTaoFuWuView.bottom+16*SCREEN_WIDTH/750, 364*SCREEN_WIDTH/750, 146*SCREEN_WIDTH/750)];
    HelpView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:HelpView];
    
    UIImageView*HelpImg=[[UIImageView alloc]initWithFrame:CGRectMake(76*SCREEN_WIDTH/750, 36*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750, 76*SCREEN_WIDTH/750)];
    [HelpImg setImage:[UIImage imageNamed:@"home_ico_bangzhufankui"]];
    [HelpView addSubview:HelpImg];
    UILabel*HelpLab=[MTool quickCreateLabelWithleft:20*SCREEN_WIDTH/750+HelpImg.right top:36*SCREEN_WIDTH/750 width:SCREEN_WIDTH/3 heigh:76*SCREEN_WIDTH/750 title:@"帮助与反馈"];
    HelpLab.textColor = [MTool colorWithHexString:@"#7f8082"];
    HelpLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    [HelpView addSubview:HelpLab];
    UIButton * HelpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    HelpBtn.frame = CGRectMake(0, 0, 364*SCREEN_WIDTH/750, 146*SCREEN_WIDTH/750);
    [HelpBtn setBackgroundColor:[UIColor clearColor]];
    [HelpBtn addTarget:self action:@selector(Help:) forControlEvents:UIControlEventTouchUpInside];
    [HelpView addSubview:HelpBtn];
    
    //精确适配X系列
    if (isPhoneX||isPhoneXR||isPhoneXSMax||isPhoneXS){

        self.cycleScrollView.frame=CGRectMake(0, SafeAreaTopHeight-Nav_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/1336*370);
        FuWuView.frame=CGRectMake(0, self.cycleScrollView.bottom, SCREEN_WIDTH,  290*SCREEN_HEIGHT/1336);

        YuSuanImg.frame=CGRectMake(95*SCREEN_WIDTH/750, lineView.bottom+36*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        YuSuanLab.frame=CGRectMake(15*SCREEN_WIDTH/750 ,YuSuanImg.bottom+20*SCREEN_WIDTH/750 ,SCREEN_WIDTH/3 ,44*SCREEN_WIDTH/750);
        YuSuanBtn.frame = CGRectMake(0, lineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_HEIGHT/1336);
        DakaImg.frame=CGRectMake(330*SCREEN_WIDTH/750,  lineView.bottom+36*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        DakaLab.frame=CGRectMake(SCREEN_WIDTH/3,YuSuanImg.bottom+20*SCREEN_WIDTH/750 , SCREEN_WIDTH/3, 44*SCREEN_WIDTH/750);
        DakaBtn.frame = CGRectMake(SCREEN_WIDTH/3, lineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_HEIGHT/1336);
        
        peopleImg.frame=CGRectMake(560*SCREEN_WIDTH/750,lineView.bottom+36*SCREEN_HEIGHT/1336 , 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        peopleLab.frame=CGRectMake(SCREEN_WIDTH/3*2-10*SCREEN_WIDTH/750,YuSuanImg.bottom+20*SCREEN_WIDTH/750 , SCREEN_WIDTH/3, 44*SCREEN_WIDTH/750);
        rencaiBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, lineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_HEIGHT/1336);

       PeiTaoFuWuView.frame=CGRectMake(0, FuWuView.bottom+16*SCREEN_WIDTH/750, SCREEN_WIDTH, 290*SCREEN_HEIGHT/1336);

        GongChengImg.frame=CGRectMake(95*SCREEN_WIDTH/750, PeiTaoFuWulineView.bottom+36*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        GongChengLab.frame=CGRectMake(15*SCREEN_WIDTH/750 ,GongChengImg.bottom+20*SCREEN_WIDTH/750 ,SCREEN_WIDTH/3 ,44*SCREEN_WIDTH/750);
        GongChengBtn.frame = CGRectMake(0, PeiTaoFuWulineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_HEIGHT/1336);
//
        LawImg.frame=CGRectMake(330*SCREEN_WIDTH/750,  PeiTaoFuWulineView.bottom+36*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        LawLab.frame=CGRectMake(SCREEN_WIDTH/3,LawImg.bottom+20*SCREEN_WIDTH/750 , SCREEN_WIDTH/3, 44*SCREEN_WIDTH/750);
        LawBtn.frame = CGRectMake(SCREEN_WIDTH/3, PeiTaoFuWulineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_HEIGHT/1336);
//
        ShowImg.frame=CGRectMake(560*SCREEN_WIDTH/750,PeiTaoFuWulineView.bottom+36*SCREEN_HEIGHT/1336 , 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        ShowLab.frame=CGRectMake(SCREEN_WIDTH/3*2-10*SCREEN_WIDTH/750,ShowImg.bottom+20*SCREEN_WIDTH/750 , SCREEN_WIDTH/3, 44*SCREEN_WIDTH/750);
        ShowBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, PeiTaoFuWulineView.bottom, SCREEN_WIDTH/3, 180*SCREEN_HEIGHT/1336);

        ShareView.frame=CGRectMake(0, PeiTaoFuWuView.bottom+16*SCREEN_WIDTH/750, 364*SCREEN_WIDTH/750, 140*SCREEN_HEIGHT/1336);
        ShareImg.frame=CGRectMake(70*SCREEN_WIDTH/750, 33*SCREEN_WIDTH/750 , 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        ShareLab.frame=CGRectMake(20*SCREEN_WIDTH/750+ShareImg.right ,36*SCREEN_HEIGHT/1336 ,SCREEN_WIDTH/3 ,76*SCREEN_WIDTH/750);
        tuijianyouliBtn.frame = CGRectMake(0, 0, ShareView.frame.size.width, ShareView.frame.size.height);
//
       HelpView.frame=CGRectMake(ShareView.right+16*SCREEN_WIDTH/750, PeiTaoFuWuView.bottom+16*SCREEN_WIDTH/750, 364*SCREEN_WIDTH/750, 140*SCREEN_HEIGHT/1336);
        HelpImg.frame=CGRectMake(70*SCREEN_WIDTH/750, 33*SCREEN_WIDTH/750 , 76*SCREEN_HEIGHT/1336, 76*SCREEN_HEIGHT/1336);
        HelpLab.frame=CGRectMake(20*SCREEN_WIDTH/750+HelpImg.right ,36*SCREEN_HEIGHT/1336 ,SCREEN_WIDTH/3 ,76*SCREEN_WIDTH/750);
        HelpBtn.frame = CGRectMake(0, 0, HelpView.frame.size.width, HelpView.frame.size.height);
        
    
        
    }
//    if (isPhoneXSMax){
//        self.cycleScrollView.frame=CGRectMake(0, SafeAreaTopHeight-Nav_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/1336*370);
//        FuWuView.frame=CGRectMake(0, self.cycleScrollView.bottom, SCREEN_WIDTH,  290*SCREEN_HEIGHT/1336);
//        PeiTaoFuWuView.frame=CGRectMake(0, FuWuView.bottom+16*SCREEN_WIDTH/750, SCREEN_WIDTH, 290*SCREEN_HEIGHT/1336);
//        ShareView.frame=CGRectMake(0, PeiTaoFuWuView.bottom+16*SCREEN_WIDTH/750, 364*SCREEN_WIDTH/750, 140*SCREEN_HEIGHT/1336);
//         HelpView.frame=CGRectMake(ShareView.right+16*SCREEN_WIDTH/750, PeiTaoFuWuView.bottom+16*SCREEN_WIDTH/750, 364*SCREEN_WIDTH/750, 140*SCREEN_HEIGHT/1336);
//    }
//

}

#pragma mark – Network

- (void)getDataFromServer
{
    [DZNetworkingTool postWithUrl:kHomeData params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict = responseObject[@"data"];
            NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:0];
            self.lunboArray = dict[@"bannerList"];
            for (NSDictionary *bannerDic in self.lunboArray) {
                [imgArray addObject:bannerDic[@"image"]];
                [titleArray addObject:bannerDic[@"title"]];
                
            }
            self.cycleScrollView.imageURLStringsGroup = imgArray;
//            self.cycleScrollView.titlesGroup = titleArray;
            
            NSDictionary *gongdiDict = dict[@"index_menus"][1];
            if ([gongdiDict[@"nwes"] intValue] == 0) {
//                self.numLabel2.hidden = YES;
            }else{
//                self.numLabel2.hidden = NO;
//                self.numLabel2.text = [NSString stringWithFormat:@"%@",gongdiDict[@"nwes"]];
            }
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    } IsNeedHub:NO];
}
#pragma mark - XibFunction
//材料预算
- (void)cailiaoyusuan:(UIButton*)sender {
//    self.numLabel1.hidden = YES;NewCaiLiaoViewController
//    self.hidesBottomBarWhenPushed = YES;
//    CaiLiaoYuSuanViewController *viewController = [CaiLiaoYuSuanViewController new];
//    [self.navigationController pushViewController:viewController animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    self.hidesBottomBarWhenPushed = YES;
    NewCaiLiaoViewController *viewController = [NewCaiLiaoViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//工地考勤
- (void)gongdikaoqin:(UIButton*)sender {
//    self.numLabel2.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    GongDiKaoQinViewController *viewController = [GongDiKaoQinViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//人才服务
- (void)rencaifuwu:(UIButton*)sender {
//    self.numLabel3.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    RenCaiFuWuViewController *viewController = [RenCaiFuWuViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//工程服务
- (void)gongchengfuwu:(UIButton*)sender {
    
//    self.numLabel4.hidden = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    GongchengfuwuViewController  *viewController = [[GongchengfuwuViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
//法律法规
- (void)law:(UIButton*)sender {
    
    [MTool showMessage:@"正在建设中！"inView:nil];
}
//装修展示
- (void)Show:(UIButton*)sender {
    
     [MTool showMessage:@"正在建设中！"inView:nil];
    
}
//帮助与反馈
- (void)Help:(UIButton*)sender {
    
    [MTool showMessage:@"正在建设中！"inView:nil];
    
}
//积分兑换
- (IBAction)jifenduihuan:(id)sender {
//    self.numLabel5.hidden = YES;
   
    self.hidesBottomBarWhenPushed = YES;
     JiFenStoreViewController *viewController = [ JiFenStoreViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//推荐有礼
- (void)tuijianyouli:(UIButton*)sender {
//    self.numLabel6.hidden = YES;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSString *phone = [User getUser].mobile;
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"推荐有礼" thumImage:[UIImage imageNamed:@"AppIcon"]];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@?group=%@&token=%@",kShareRegister,@(1),phone];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObject
                                    currentViewController:self
                                               completion:^(id data, NSError *error) {
                                                   if (error) {
                                                       NSLog(@"************Share fail with error %@*********", error);
                                                   } else {
                                                       [DZTools showOKHud:@"分享成功" delay:2];
                                                   }
                                               }];
    }];
    
    
}
#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dict = self.lunboArray[index];
    if ([dict[@"to_type"] integerValue] == 1) {
        self.hidesBottomBarWhenPushed = YES;
        WebViewViewController *viewController=[[WebViewViewController alloc]init];
        viewController.urlStr = dict[@"to_url"];
        viewController.titleStr = dict[@"title"];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"to_type"] integerValue] == 2) {
        self.hidesBottomBarWhenPushed = YES;
        StoreDetailViewController *viewController=[[StoreDetailViewController alloc]init];
        viewController.seller_id = [dict[@"to_url"] integerValue];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}


@end
