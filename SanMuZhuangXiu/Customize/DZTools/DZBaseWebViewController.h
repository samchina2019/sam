//
//  DZBaseWebViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZBaseWebViewController : DZBaseViewController

@property (nonatomic, strong) UIWebView *webView;
@property (strong, nonatomic) JSContext *context;

@end

NS_ASSUME_NONNULL_END
