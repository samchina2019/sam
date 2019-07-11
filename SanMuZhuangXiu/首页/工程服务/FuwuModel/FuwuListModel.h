//
//  FuwuListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FuwuListModel : NSObject
@property(nonatomic,assign)int lookId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *note;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *createtime;

@end

NS_ASSUME_NONNULL_END
