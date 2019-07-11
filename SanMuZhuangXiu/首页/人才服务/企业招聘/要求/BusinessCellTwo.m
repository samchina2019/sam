//
//  BusinessCellTwo.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BusinessCellTwo.h"
#import "ActivityTwoModel.h"

typedef enum : NSUInteger {
    
    kNormal,
    kSelected,
    
} ESelectedState;

@interface BusinessCellTwo ()

@property (nonatomic, strong)UILabel *businessLabel;

@end

@implementation BusinessCellTwo

- (void)setUpCell {
    
    self.layer.borderWidth  = 0.5;
    self.layer.cornerRadius = 5;
    
}

- (void)buildUpSubviews {
    
    self.businessLabel               = [[UILabel alloc] initWithFrame:self.bounds];
    self.businessLabel.textColor         = UIColorFromRGB(0x666666);
    self.businessLabel.backgroundColor   = [UIColor whiteColor];
    self.businessLabel.textAlignment = NSTextAlignmentCenter;
    self.businessLabel.font          = [UIFont systemFontOfSize:14];
    self.businessLabel.layer.borderColor = [UIColor blackColor].CGColor;
    [self addSubview:self.businessLabel];
    
}

- (void)loadContent {
    
    ActivityTwoModel *model = self.data;
    
    self.businessLabel.text = model.typeName;
    
    if (model.isSelected) {
        
        [self changToState:kSelected animation:NO];
        
    } else {
    
        [self changToState:kNormal animation:NO];
    
    }
}

- (void)changToState:(ESelectedState)state animation:(BOOL)animation {
    
    if (state == kNormal) {
        
        self.businessLabel.textColor =UIColorFromRGB(0x666666);
        self.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
        
    } else if (state == kSelected) {
        
        self.businessLabel.textColor = UIColorFromRGB(0x3FAEE9);
        self.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
    }
    
}


- (void)touchEvent {
    
    ActivityTwoModel *model = self.data;
    
    if (model.isSelected == YES) {
        
        model.isSelected = NO;
        [self changToState:kNormal animation:NO];
        
    } else if (model.isSelected == NO) {
    
        model.isSelected = YES;
        [self changToState:kSelected animation:NO];
    }
    
}


@end
