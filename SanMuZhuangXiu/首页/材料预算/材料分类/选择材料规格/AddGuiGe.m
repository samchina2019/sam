//
//  AddGuiGe.m
//  SanMuZhuangXiu
//
//  Created by apple on 2019/7/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AddGuiGe.h"

@interface AddGuiGe () <UITableViewDelegate, UITableViewDataSource>
{
    UIView*BGView;
    UILabel*titLab;
    UITableView*guigetableView;
}

@end
@implementation AddGuiGe

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"AddGuiGe" owner:self options:nil][0];
        self.frame = frame;
    }
   
    
    return self;
}
#pragma mark – UI


-(void)CreateHeardView{
    
  
    BGView=[[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-SafeAreaBottomHeight-50-637*SCREEN_WIDTH/750, SCREEN_WIDTH, SCREEN_WIDTH/750*210)];
    BGView.backgroundColor=[UIColor whiteColor];
    
    titLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/750*100)];
    titLab.font=[UIFont systemFontOfSize:18];
    titLab.textAlignment=NSTextAlignmentCenter;
    [BGView addSubview:titLab];
    
    UIButton*ClosedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ClosedBtn.frame = CGRectMake( SCREEN_WIDTH-SCREEN_WIDTH/750*24-SCREEN_WIDTH/750*44, SCREEN_WIDTH/750*28, SCREEN_WIDTH/750*44, SCREEN_WIDTH/750*44);
    [ClosedBtn setImage:[UIImage imageNamed:@"clfl_ico_lose"] forState:UIControlStateNormal];
    [ClosedBtn addTarget:self action:@selector(closed:) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:ClosedBtn];
    
 
    
}
-(void)GuigetableView {
    guigetableView=[[UITableView alloc]initWithFrame:CGRectMake(0, BGView.bottom, SCREEN_WIDTH, SCREEN_WIDTH/750*300) style:UITableViewStylePlain];
   guigetableView.delegate = self;
   guigetableView.dataSource = self;
    
    [guigetableView registerNib:[UINib nibWithNibName:@"SpecCollectionViewCell" bundle:nil] forCellReuseIdentifier:@"SpecCollectionViewCell"];
    guigetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:guigetableView];
    
}
@end
