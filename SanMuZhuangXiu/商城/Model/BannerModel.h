//
//  BannerModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/27.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject
@property(nonatomic,assign)NSInteger banner_id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *image;
@end

NS_ASSUME_NONNULL_END
