//
//  CaiLiaoFenLeiViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import "StuffListModel.h"
@class CaiLiaoFenLeiViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol  CaiLiaoFenLeiViewControllerDelegate <NSObject>
@required
-(NSMutableArray *)CaiLiaoFenLeiView:(CaiLiaoFenLeiViewController *)cailiaoController ;

@end
@interface CaiLiaoFenLeiViewController : DZBaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *cailiaodanScollView;
@property (weak, nonatomic) IBOutlet UITextField *gongchengDizhiText;
@property (weak, nonatomic) IBOutlet UITextField *cailiaodanNameText;

@property(nonatomic,strong)NSString *stuffCartId;
@property(nonatomic,strong)NSMutableArray *selectedCailiao;

@property (nonatomic, strong) StuffListModel* stufflistModel;
//是否k来自编辑
@property(nonatomic,assign)BOOL isFromEdit;
//block
@property (nonatomic,copy) void (^change)(NSArray* stuffArray);
//代理
@property(nonatomic,weak)id<CaiLiaoFenLeiViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
