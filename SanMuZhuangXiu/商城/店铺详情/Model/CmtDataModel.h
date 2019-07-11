//
//  CmtDataModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/15.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CmtDataModel : NSObject
@property(nonatomic,assign)int evalu_id;
@property(nonatomic,assign)int goods_id;
@property(nonatomic,assign)int user_id;
@property(nonatomic,strong)NSString *star;
@property(nonatomic,strong)NSString *cmt_content;
@property(nonatomic,strong)NSString *user_avatar;
@property(nonatomic,strong)NSString *createtime_text;
@property(nonatomic,strong)NSString *user_name;
@property(nonatomic,strong)NSArray *cmt_images;
@property(nonatomic,assign)int createtime;
@property(nonatomic,assign)int cmt_num;

@end

NS_ASSUME_NONNULL_END
