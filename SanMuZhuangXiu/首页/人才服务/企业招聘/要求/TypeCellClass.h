//
//  TypeCellClass.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeCellClass : NSObject

/**
 *  cell的className
 */
@property (nonatomic, strong)Class     className;

/**
 *  cell的注册ID
 */
@property (nonatomic, strong)NSString *registID;

@end
