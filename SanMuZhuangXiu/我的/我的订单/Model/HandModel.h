//
//  HandModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/6/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HandModel : NSObject
///状态
@property(nonatomic,assign)int status;
///内容
@property(nonatomic,strong)NSString *text;
///时间
@property(nonatomic,strong)NSString *time;
@end

NS_ASSUME_NONNULL_END
