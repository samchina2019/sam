//
//  DZBaseCollectionView.m
//  HOOLA
//
//  Created by 犇犇网络 on 2018/8/21.
//  Copyright © 2018年 Darius. All rights reserved.
//

#import "DZBaseCollectionView.h"

@implementation DZBaseCollectionView

/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
