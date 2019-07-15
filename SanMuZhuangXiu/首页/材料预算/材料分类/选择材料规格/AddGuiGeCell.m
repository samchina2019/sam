//
//  AddGuiGETableViewCell.m
//  SanMuZhuangXiu
//
//  Created by apple on 2019/7/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AddGuiGeCell.h"
@interface AddGuiGeCell ()

@property (strong, nonatomic) UILabel       * NameLabel;//名称
@property (strong, nonatomic) UITextField      *guigefild;//规格

@property (strong, nonatomic) UITextField      *guigefild1;//规格1
@property (strong, nonatomic) UITextField      *guigefild2;//规格2
@property (strong, nonatomic) UITextField      *guigefild3;//规格3
@property (strong, nonatomic) UILabel       * DescribeLabel;//描述
@property (strong, nonatomic) UIImageView       * addImg;//描述
@property (strong, nonatomic) UIButton       * SureBtn;//描述



@end

@implementation AddGuiGeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}
-(void)initViews{
    
   
    _NameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150*SCREEN_WIDTH/750, 66*SCREEN_WIDTH/750)];
    _NameLabel.text=@"设置参数";
    _NameLabel.textColor=[MTool colorWithHexString:@"#7f8082"];

    _NameLabel.textAlignment=NSTextAlignmentRight;
    _NameLabel.font=[UIFont systemFontOfSize:16];
    [self addSubview:_NameLabel];
    _guigefild1=[[UITextField alloc]initWithFrame:CGRectMake(_NameLabel.right+36*SCREEN_WIDTH/750, 1, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66)];
    _guigefild1.placeholder=@"规格参数";
    _guigefild1.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
    _guigefild1.layer.borderWidth= 1.0f;
    _guigefild1.textAlignment=NSTextAlignmentCenter;
    _guigefild1.font=[UIFont systemFontOfSize:16];
    _guigefild1.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
    [self addSubview:_guigefild1];

    _guigefild2=[[UITextField alloc]initWithFrame:CGRectMake(_guigefild1.right+20*SCREEN_WIDTH/750, 1, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66)];
    _guigefild2.placeholder=@"规格参数";
    _guigefild2.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
    _guigefild2.layer.borderWidth= 1.0f;
    _guigefild2.textAlignment=NSTextAlignmentCenter;
    _guigefild2.font=[UIFont systemFontOfSize:16];
    _guigefild2.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
    [self addSubview:_guigefild2];

    _guigefild3=[[UITextField alloc]initWithFrame:CGRectMake(_NameLabel.right+36*SCREEN_WIDTH/750, _guigefild2.bottom+SCREEN_WIDTH/750*16, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66)];
    _guigefild3.placeholder=@"规格参数";
    _guigefild3.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
    _guigefild3.layer.borderWidth= 1.0f;
    _guigefild3.textAlignment=NSTextAlignmentCenter;
    _guigefild3.font=[UIFont systemFontOfSize:16];
   _guigefild3.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
    [self addSubview:_guigefild3];
    
    _addImg=[[UIImageView alloc]initWithFrame:CGRectMake(_guigefild1.right+30*SCREEN_WIDTH/750, _guigefild2.bottom+SCREEN_WIDTH/750*35, SCREEN_WIDTH/750*28, SCREEN_WIDTH/750*28)];
    [_addImg setImage: [UIImage imageNamed:@"cailiao_zengjiaguige"]];
     [self addSubview:_addImg];
    _DescribeLabel=[[UILabel alloc]initWithFrame:CGRectMake(_addImg.right+10*SCREEN_WIDTH/750, _guigefild2.bottom+SCREEN_WIDTH/750*16, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66)];
    _DescribeLabel.text=@"添加参数";
    [self addSubview:_DescribeLabel];

    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(_guigefild1.right+20*SCREEN_WIDTH/750, _guigefild2.bottom+SCREEN_WIDTH/750*16, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66);
     [self  addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    
}
-(void)addBtn:(UIButton*)sender{
    for (int i=0; i<2; i++) {
        UITextField*guigefild1= [[UITextField alloc]initWithFrame:CGRectMake(_guigefild1.right+20*SCREEN_WIDTH/750, _guigefild2.bottom+SCREEN_WIDTH/750*16, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66)];
            guigefild1.placeholder=@"规格参数";
            guigefild1.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
            guigefild1.layer.borderWidth= 1.0f;
            guigefild1.textAlignment=NSTextAlignmentCenter;
            guigefild1.font=[UIFont systemFontOfSize:16];
            guigefild1.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
        
        UITextField*guigefild2= [[UITextField alloc]initWithFrame:CGRectMake(_NameLabel.right+36*SCREEN_WIDTH/750, guigefild1.bottom+SCREEN_WIDTH/750*16, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66)];
        guigefild2.placeholder=@"规格参数";
        guigefild2.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
        guigefild2.layer.borderWidth= 1.0f;
        guigefild2.textAlignment=NSTextAlignmentCenter;
        guigefild2.font=[UIFont systemFontOfSize:16];
        guigefild2.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
        UITextField*guigefild3= [[UITextField alloc]initWithFrame:CGRectMake(_guigefild1.right+20*SCREEN_WIDTH/750, guigefild1.bottom+SCREEN_WIDTH/750*16, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*66)];
        guigefild3.placeholder=@"规格参数";
        guigefild3.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
        guigefild3.layer.borderWidth= 1.0f;
        guigefild3.textAlignment=NSTextAlignmentCenter;
        guigefild3.font=[UIFont systemFontOfSize:16];
        guigefild3.backgroundColor=[MTool colorWithHexString:@"#f9f9f9"];
        [self  addSubview:guigefild1];
        [self  addSubview:guigefild2];
        [self  addSubview:guigefild3];
        _addImg.hidden=YES;
        _DescribeLabel.hidden=YES;
        _addBtn.hidden=YES;
        self.tianjiaBlock();

    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
