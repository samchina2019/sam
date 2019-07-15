//
//  AddGuiGe.m
//  SanMuZhuangXiu
//
//  Created by apple on 2019/7/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AddGuiGe.h"
#import "AddGuiGeCell.h"
@interface AddGuiGe () <UITableViewDelegate, UITableViewDataSource>
{
    UIView*BGView;
    UILabel*titLab;
   
}
@property (strong, nonatomic) UILabel       * NameLabel;//名称
@property (strong, nonatomic) UITextField      *guigefild1;//规格1
@property (assign,nonatomic) NSInteger     tagNum;//标记值

@end
@implementation AddGuiGe

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self CreateHeardView];
        [self GreatetableView];
    }
   
    
    return self;
}
#pragma mark – UI


-(void)CreateHeardView{
    
  
    BGView=[[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH/750*120)];
    BGView.backgroundColor=[UIColor whiteColor];
    
    titLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/750*120)];
    titLab.text=@"水泥";
    titLab.font=[UIFont systemFontOfSize:16];
    titLab.textAlignment=NSTextAlignmentCenter;
    [BGView addSubview:titLab];
    [self addSubview:BGView];
    
    _ClosedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ClosedBtn.frame = CGRectMake( SCREEN_WIDTH-SCREEN_WIDTH/750*24-SCREEN_WIDTH/750*44, SCREEN_WIDTH/750*38, SCREEN_WIDTH/750*44, SCREEN_WIDTH/750*44);
    [_ClosedBtn setImage:[UIImage imageNamed:@"clfl_ico_lose"] forState:UIControlStateNormal];
//    [ClosedBtn addTarget:self action:@selector(closed:) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:_ClosedBtn];
    
    _NameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,BGView.bottom, 150*SCREEN_WIDTH/750, 66*SCREEN_WIDTH/750)];
    _NameLabel.text=@"添加规格";
    _NameLabel.textColor=[MTool colorWithHexString:@"#7f8082"];
    _NameLabel.textAlignment=NSTextAlignmentRight;
    _NameLabel.font=[UIFont systemFontOfSize:16];
    [self addSubview:_NameLabel];
    _guigefild1=[[UITextField alloc]initWithFrame:CGRectMake(_NameLabel.right+36*SCREEN_WIDTH/750, BGView.bottom, SCREEN_WIDTH/750*525, SCREEN_WIDTH/750*66)];
    _guigefild1.placeholder=@"请输入新规格";
    _guigefild1.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
    _guigefild1.layer.borderWidth= 1.0f;
    _guigefild1.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
    _guigefild1.textAlignment=NSTextAlignmentCenter;
    _guigefild1.font=[UIFont systemFontOfSize:16];
    [self addSubview:_guigefild1];
    
}
-(void)GreatetableView {
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _guigefild1.bottom+SCREEN_WIDTH/750*40, SCREEN_WIDTH, SCREEN_WIDTH/750*152) style:UITableViewStylePlain];
   _tableView.delegate = self;
   _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"SpecCollectionViewCell" bundle:nil] forCellReuseIdentifier:@"SpecCollectionViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
}

#pragma mark - <UITableViewDelegate和DataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (_tagNum==1000) {
         return 228*SCREEN_WIDTH/750;
    }
    else{
        return 152*SCREEN_WIDTH/750;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellId = @"AddGuiGeCell";
    AddGuiGeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[AddGuiGeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tianjiaBlock = ^() {
        self.tagNum=1000;
        [self.tableView reloadData];
    };
       return cell;
   
}

@end
