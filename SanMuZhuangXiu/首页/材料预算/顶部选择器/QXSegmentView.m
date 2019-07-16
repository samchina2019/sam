//
//  QXSegmentedControl.m
//  YoungDrill
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 czg. All rights reserved.
//

#import "QXSegmentView.h"
@interface QXSegmentView()

@property (nonatomic, strong) UIView    *lineView;


@end

@implementation QXSegmentView


- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArr{
    
    self = [super initWithFrame:frame];
    if (self) {
//        CGFloat btnWidth = frame.size.width/titleArr.count < 80 ? frame.size.width/titleArr.count:80;
        CGFloat btnWidth=(SCREEN_WIDTH-142*SCREEN_WIDTH/750)/titleArr.count;
        for (NSInteger i = 0; i < titleArr.count; i++) {
            UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.frame = CGRectMake(btnWidth*i, 0, btnWidth, 42);
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [titleBtn addTarget:self action:@selector(titleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [titleBtn setTitleColor: [MTool colorWithHexString:@"#a9abc0"] forState:UIControlStateNormal];
            if (i == 0) {
                titleBtn.selected = YES;
               [titleBtn setTitleColor: [MTool colorWithHexString:@"#26292c"] forState:UIControlStateNormal];
                titleBtn.titleLabel.font = [UIFont systemFontOfSize:21];
            }
            titleBtn.tag = 100+i;
            [self addSubview:titleBtn];
        }
        
//        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 42, btnWidth, 2)];
//        _lineView.backgroundColor = [UIColor blueColor];
//        [self addSubview:_lineView];
    }
    return self;
}



- (void)setTitleArray:(NSArray *)titleArray{
    for (NSInteger i = 100; i < 100+titleArray.count; i++) {
        UIButton * otherBtn = (UIButton *)[self viewWithTag:i];
        [otherBtn setTitle:titleArray[i-100] forState:UIControlStateNormal];
    }
}


- (void)titleBtnClicked:(UIButton *)sender{
    if (!sender.selected) {
        //未选中到选中状态
        [sender setTitleColor: [MTool colorWithHexString:@"#26292c"] forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:21];
        
        for (NSInteger i = 100; i < 103; i++) {
            UIButton * otherBtn = (UIButton *)[self viewWithTag:i];
            if (i != sender.tag) {
                otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [otherBtn setTitleColor: [MTool colorWithHexString:@"#a9abc0"] forState:UIControlStateNormal];
                otherBtn.selected = NO;
            }
        }
//        self.lineView.frame = CGRectMake(20+(80 + 20)*(sender.tag-100), 42, 80, 2);
        self.segmentClickBlock(sender.tag-100);
    }

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
