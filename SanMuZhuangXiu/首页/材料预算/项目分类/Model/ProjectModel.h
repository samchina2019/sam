//
//  ProjectModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectModel : NSObject

@property(nonatomic,assign)NSInteger stuff_work_id;

@property(nonatomic,assign)NSInteger project_id;
//名称
@property(nonatomic,strong)NSString *name;
//图标
@property(nonatomic,strong)NSString *image;

@property(nonatomic,strong)NSString *status;




@end

NS_ASSUME_NONNULL_END
