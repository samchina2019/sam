//
//  JianQunDaKaViewController.h
//  SanMuZhuangXiu
//
//  Created by benben on 2019/2/27.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import <MAMapKit/MAMapKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface JianQunDaKaViewController : DZBaseViewController
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *gongchengLabel;
@property (weak, nonatomic) IBOutlet UITextField *gongdiNameText;
@property (weak, nonatomic) IBOutlet UIButton *baocunBtn;
///xibFunction
- (IBAction)JianqunClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
