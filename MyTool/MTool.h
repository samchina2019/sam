//
//  MTool.h
//  YoungDrill
//
//  Created by zh_mac on 2018/7/3.
//  Copyright © 2018年 czg. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "sys/utsname.h"
//#import <WXApi.h>
#import <AudioToolbox/AudioToolbox.h>
#import "User.h"







@interface MTool : NSObject



/**
 获取http请求地址

 @return http请求地址
 */
+(NSString *)getHostUrl;


+ (NSInteger)getForgetPasswordTimeIndex;

+ (void)setForgetPasswordTimeIndex:(NSInteger)sender;


+ (void)setToken:(NSString *)sender;
+ (NSString *)getToken;
+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;

+(void)showImage:(NSString *)image title:(NSString *)title inView:(UIView *)view withCGsize:(CGSize)size afterDelay:(CGFloat)timer;

+(void)showImage:(UIImageView *)avatarImageView;

+ (NSString *) md5:(NSString *)str;


+ (BOOL)firstOpenApp;

#pragma mark - 3des加解密
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;


+ (void)showMessage:(NSString *)message inView:(UIView *)view;


+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size;

#pragma mark - 将YYYY-MM-dd HH:mm:ss时间转换为MM-dd HH:mm的时间格式
/**
 * @brief   将YYYY-MM-dd HH:mm:ss时间转换为MM-dd HH:mm的时间格式
 * @param   uiDate    YYYY-MM-dd HH:mm:ss时间
 * @return  NSString   MM-dd HH:mm 时间
 */
+ (NSString *)convertDateStringFromString:(NSString*)uiDate;

+ (NSDate*)convertDateFromString:(NSString*)uiDate;

+ (NSDate *)stringDateToDate:(NSString *)dateString;

/**
 *  获取当前的13位的时间戳
 */
+ (NSString *)getNow1970Date;
/**
 *  将13位时间转换为  截止到日的
 */
+(NSString *)dateSub10String:(NSString *)timeString;

#pragma mark - 将13位时间转换为年月日时分秒
+ (NSString *)dateAllStringFromString:(NSString *)timeString;

+ (NSString *)datePartStringFromString:(NSString *)timeString;
#pragma mark - 将13位时间转换为想要的时间格式
/**
 * @brief   将13位时间转换为想要的时间格式
 * @param   timeString    13位时间
 * @param   toFormat    格式（如：YYYY-MM-dd HH:mm:ss）
 * @return  NSString 时间
 */
+ (NSString *)dateStringFromString:(NSString *)timeString toFormat:(NSString *)toFormat;


/**
 将日期转换为星期

 @param timeString 时间戳
 @return 星期
 */
+ (NSString *)getWeekWithTimeString:(NSString *)timeString;

+ (NSString*)compareTwoTime:(NSString *)timeStr time2:(NSString *)timeStr2;


+ (NSString *)dateToString:(NSDate *)sender;

+ (NSString *)DataTOjsonString:(id)object;

#pragma mark - 信息存储
//存储当前信息
+(BOOL)storeCurrentMessage:(NSDictionary *)curretnPersonDic;

//获取当前信息
+ (NSMutableDictionary  *)getCurrentMessage;

/** 存储当前信息 */
+(BOOL)storeCurrentUserModel:(User *)userModel;

/** 获取当前用户信息 */
+ (User  *)getCurrentUserModel;

/** 获取当前用户ID */
+ (NSString  *)getcoachId;


/** 获取当前教练ID */
+ (NSString  *)getorgId;

/**
 获取当前机构名称

 @return 机构名称
 */
+ (NSString  *)getorgName;



+ (void)requestMsgCount;

//清除当前信息
+ (void)removeCurrentMessage;

//存储用户名
+ (BOOL)storeCurrentUserName:(NSString *)userName;
//存储密码
+ (BOOL)storeCurrentUserPwd:(NSString *)userPwd;
//获取用户名
+ (NSString *)getUserName;
//存储密码
+ (NSString *)getUserPwd;

//保存新通知状态
+ (BOOL)storeNotificationState:(BOOL)b;
//获得新通知状态
+(BOOL)getNotificationState;
//保存声音状态
+ (BOOL)storeVoiceState:(BOOL)b;
//获得声音状态
+(BOOL)getVoiceState;
//保存动效状态
+ (BOOL)storeDynamicState:(BOOL)b;
//获得动效状态
+(BOOL)getDynamicState;
//保存通过手机号搜索到我状态
+ (BOOL)storeSearchAddressBookState:(BOOL)b;
//获得通过手机号搜索到我状态
+(BOOL)getSearchAddressBookState;
//保存推荐通讯录朋友状态
+ (BOOL)storePushAddressBookState:(BOOL)b;
//获得推荐通讯录朋友状态
+(BOOL)getPushAddressBookState;







//存储当前刷新状态
+ (BOOL)storeCurrentRefresh:(NSString *)refresh;
//存储当前刷新时间间隔
+ (BOOL)storeCurrentRefreshTimeInterval:(NSString *)interval;

+ (BOOL)getCurrentRefresh;

+ (NSInteger)getCurrentRefreshTimeInterval;

#pragma mark - 正则校验
//校验手机号
+ (BOOL)isValidateMobile:(NSString *)mobile;

//在window上显示信息
+ (void)showMessageToWidow:(NSString *)message key:(NSInteger)key;
//删除window上显示的信息
+ (void)removeMessageForKey:(NSInteger)key;
//输入是否为数字
+(BOOL) deptNumInputShouldNumber:(NSString *)str;




#pragma mark - 设置是否开启推送
/**
 * @brief   设置是否开启推送
 * @param   open    YES开启，NO不开启
 * @return  是否成功
 */
+ (BOOL)storeCurrentOpenAPN:(NSString *)open;

#pragma mark - 得到是否开启推送
/**
 * @brief   得到是否开启推送
 * @return  YES开启，NO不开启
 */
+ (NSString *)getOpenAPN;


#pragma mark - 分享
+ (void)WechatsharePictureWithShareType:(int)shareType title:(NSString *)title descr:(NSString *)descr Image:(UIImage *)image urlImg:(NSString *)urlImg;



#pragma mark - 设置是否显示过引导页
/**
 * @brief   是否显示过引导页
 * @param   version    版本号，如果版本号与得到的版本号一至就是显示过，如果没有版本号或是与当前得到的版本号不一至就是没有显示过
 * @return  是否成功
 */
+ (BOOL)storeCurrentShowGuide:(NSString *)version;

#pragma mark - 得到是否显示过引导页
/**
 * @brief   是否显示过引导页
 * @return  版本号，如果版本号与得到的版本号一至就是显示过，如果没有版本号或是与当前得到的版本号不一至就是没有显示过
 */
+ (NSString *)getShowGuide;


#pragma mark 存储当前登陆状态
+ (BOOL)storeCurrentLoginState:(NSString *)loginStr;
+ (NSString *)getCurrentLastLoginState;


+ (NSString *)timeInfoWithDateString:(NSString *)dateString;
+ (int)intervalSinceNow:(NSString *)theDate;

/**
 * @brief   通过text view中的文字与宽度，计算出高度
 * @param   textView 要计算的textView
 * @return  CGSize  计算后的大小
 */
+ (CGSize)contentSizeHeightOfTextView:(UITextView *)textView;


/**
 * @brief   通过label中的文字与宽度，计算出高度
 * @param   label 要计算的label
 * @return  CGSize  计算后的大小
 */
+ (CGSize)contentSizeHeightOfLabel:(UILabel *)label;


/**
 * @brief   通过label中的文字与高度，计算出宽度
 * @param   label 要计算的label
 * @return  CGSize  计算后的大小
 */
+ (CGSize)contentSizeWidthOfLabel:(UILabel *)label;

/**
 * @brief   复制View
 * @param   view 要复制的view
 * @return  UIView  复制的View
 */
+ (UIView*)duplicate:(UIView*)view;
/**
 *  @author chenglibin
 *
 *  十六进制颜色转换成
 *
 *  @param stringToConvert // 例如： @"#123456"
 
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 * @brief   检查是否是数组，数组长度是否大于0
 * @param   id 要检查的对象
 * @return  BOOL
 */

+ (BOOL)checkingIsArray:(id)sender;


/**
 * @brief   检查是否是string，长度是否大于0
 * @param   id 要检查的对象
 * @return  BOOL
 */
+ (BOOL)checkingIsString:(id)sender;

/**
 * @brief   检查是否是Dic，长度是否大于0
 * @param   id 要检查的对象
 * @return  BOOL
 */
+ (BOOL)checkingIsDic:(id)sender;


/**
 * @brief   读取plist文件，得到内容为DIC
 * @param   fileName plist名
 * @return  NSMutableDictionary
 */
+ (NSMutableDictionary *)readPlistToDic:(NSString *)fileName;

/**
 * @brief   将DIC写入到plist文件
 * @param   fileName plist名
 * @param   dataDic DIC
 */
+ (void)pushDicToPlist:(NSMutableDictionary *)dataDic fileName:(NSString *)fileName;


/**
 * @brief   读取plist文件，得到内容为Array
 * @param   fileName plist名
 * @return  NSMutableArray
 */
+ (NSMutableArray *)readPlistToArray:(NSString *)fileName;

/**
 * @brief   将Array写入到plist文件
 * @param   fileName plist名
 * @param   dataArray array
 */
+ (void)pushArrayToPlist:(NSMutableArray *)dataArray fileName:(NSString *)fileName;



/**
 * @brief   文件是否存在
 * @param   path 路径
 * @param   isCreate 如果不存在，是否创建  YES创建、NO不创建
 * @param   BOOL
 */
+ (BOOL)fileExists:(NSString *)path isCreate:(BOOL)isCreate;


/**
 * @brief   文件是否存在在Documents目录下
 * @param   name 文件名
 * @param   isCreate 如果不存在，是否创建  YES创建、NO不创建
 * @param   BOOL
 */
+ (BOOL)fileExistsForName:(NSString *)name isCreate:(BOOL)isCreate;


/**
 * @param sender 地区信息数组
 * @param province 要查询的省
 * @return NSDictionary 省信息
 */
+ (NSDictionary *)getProvince:(NSArray *)sender province:(NSString *)province;

/**
 * @param sender 地区信息数组
 * @param city 要查询的市
 * @return NSDictionary 市信息
 */
+ (NSDictionary *)getCity:(NSArray *)sender city:(NSString *)city;

//+ (void)cityMessageMark:(struct CityMessage)city toCityMessage:(struct CityMessage)sender;


/**
 * @brief   将信息写入到plist
 * @param   sender 信息DIC
 */
+ (void)pushDicToPlist:(NSMutableDictionary *)sender name:(NSString *)name;

/**
 * @brief   得到plist信息
 * @return  NSString 文件名
 */
+ (NSDictionary *)getDicFromPlist:(NSString *)name;



/**
 * @brief   打电话
 * @return  phoneNum 电话号码
 */
+ (void)callPhone:(NSString *)phoneNum;


+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;



/**
 * @brief   设置view圆角
 * @param   radius 圆角度数
 * @param   corners 哪个角需要圆
 * UIRectCornerTopLeft
 * UIRectCornerTopRight
 * UIRectCornerBottomLeft
 * UIRectCornerBottomRight
 * UIRectCornerAllCorners
 * @param   view
 */

+ (void)setViewRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners view:(id)view;

/**
 * @brief   设置圆角
 * @param   radius 圆角度数
 * @param   view
 */
+ (void)setViewRadius:(CGFloat)radius view:(id)view;


/**
 * @brief   描边
 * @param   borderWidth 边宽度
 * @param   color 颜色
 * @param   view
 */
+ (void)setViewBorder:(CGFloat)borderWidth color:(UIColor *)color view:(id)view;

/**
 * @brief   描边并加圆角
 * @param   borderWidth 边宽度
 * @param   color 颜色
 * @param   radius 圆角度数
 * @param   view
 */
+(void)setViewRadiusAndBorder:(CGFloat)borderWidth color:(UIColor *)color radius:(CGFloat)radius view:(id)view;


/**
 * @brief   描边并加圆角 圆角4 颜色153/153/153 线宽0.5
 * @param   view
 */
+ (void)setViewRadiusAndBorder:(id)view;

/**
 * @brief   设置UITextField左边距
 * @param   textField textField
 * @param   leftWidth 距离
 */
+ (void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth;


/**
 * @brief   播放按键音
 * @param   soundName 声音名
 */
+ (void)playSound:(NSString *)soundName;



/**
 * @brief   获取赛事与球员信息
 * @return   NSMutableDictionary 赛事与球员信息
 */
+ (NSMutableDictionary *)getTeamAndPlayerInfo;
/**
 * @brief   设置赛事与球员信息
 * @param   sender 赛事与球员信息
 */
+ (void)setTeamAndPlayerInfo:(NSMutableDictionary *)sender;



/**
 * @brief   获取场地地信息
 * @return   NSMutableDictionary 场地地信息
 */
+ (NSMutableDictionary *)getSingleFieldInfo;
/**
 * @brief   设置场地地信息
 * @param   sender 场地地信息
 */
+ (void)setSingleFieldInfo:(NSMutableDictionary *)sender;

/**
 * @brief   设置当前网络状态
 * @param   sender 网络状态
 */
+ (void)setNetworkStatus:(AFNetworkReachabilityStatus)sender;
/**
 * @brief   获取当前网络状态
 * @return   AFNetworkReachabilityStatus 网络状态
 */
+ (AFNetworkReachabilityStatus)getNetWorkStatus;


#pragma mark - 设备版本
//这个代码可以获取到具体的设备版本（已更新到iPhone 6s、iPhone 6s Plus），缺点是：采用的硬编码。具体的对应关系可以参考：https://www.theiphonewiki.com/wiki/Models
//这个方法可以通过AppStore的审核，放心用吧。
/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
+ (NSString *)DeviceVersion;

#pragma mark - 创建控件
+ (NSInteger)getBottomBarButtonIndex;
+ (void)setBottomBarButtonIndex:(NSInteger)sender;



+(BOOL)mainDataMessage:(NSDictionary *)curretnPersonDic;

+ (NSMutableDictionary  *)getMainDataMessage;


/**
 * @brief   提示框展示纯文字类型
 * @param   text 文字
 */
+ (void)showText:(NSString *)text;

/**
 * @brief   提示框展示纯文字类型
 * @param   text 文字
 * @param   showTime 显示时间
 */
+ (void)showText:(NSString *)text showTime:(NSInteger)showTime;


/**
 * @brief   把Button的图标放在文字的右边  前提是文字跟图片有值   多加了3像素的间隙
 * @param
 */
+ (void)rightButtonImg:(UIButton *)button;

/**
 * @brief   给要视图裁圆 切增加阴影  (masksToBounds= NO的情况下)
 * @param   view        需要加效果的视图
 * @param   isSquare    方的阴影还是圆的
 */
+ (void)addShadow:(UIView *)view shadowColor:(UIColor *)color isSquare:(BOOL)isSquare;

/**
 * @brief   给要视图裁圆 切增加阴影  (masksToBounds=YES 的情况下)
 * @param   view        需要加效果的视图
 * @param   corner      裁圆的角度
 * @param   superView   view的父视图
 * @param   shadowColor 阴影颜色
 * @param   isSquare    方的阴影还是圆的
 */
+ (void)addShadow:(UIView *)view cornerValue:(CGFloat)corner superView:(UIView*)superView shadowColor:(UIColor *)color isSquare:(BOOL)isSquare frame:(CGRect)frame;
//根据文字跟最大宽计算出控件该有的高度
+ (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
//根据文字跟最大宽计算出
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 * @brief  快速创建Lable
 * @param   left 左边距离
 * @param   top 顶部距离
 * @param   width 宽度
 * @param   heigh 高度
  * @param   title 文字
 */

+(UILabel *)quickCreateLabelWithleft:(CGFloat)left top:(CGFloat)top width:(CGFloat)width heigh:(CGFloat)heigh title:(NSString *)title;
/**
 * @brief  快速创建UITextField
 * @param   frame 位置大小
 
 */
+(UITextField*)CreateTextFieldWithFrame:(CGRect)frame withCapacity:(NSString *)placeholder withSecureTextEntry:(BOOL)isSecoure withTargrt:(id)t withTag:(NSInteger)tag;



/**
 *  登陆与否的处理
 *  未登录返回NO 跳转到登陆界面  登陆返回YES
 */
+ (BOOL)loginHandle:(UIViewController *)fromVC;

/**
 *  登陆与否的处理
 *  未登录返回NO 跳转到登陆界面  登陆返回YES
 *  loginSucceedBlock   跳转到登陆界面  登陆成功后的回调 (方便 继续因未登录被终止的操作)
 */
+ (BOOL)loginHandle:(UIViewController *)fromVC loginSucceedBlock:(void(^)(BOOL loginSucceed))loginSucceedBlock;



//判断是否以字母开头
+(BOOL)MatchLetter:(NSString *)str;
//是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
+(BOOL)isChineseFirst:(NSString *)firstStr;
//判断是否以数字开头
+ (BOOL)isPureInt:(NSString*)string;



/**
 获取字符串字符长度

 @param text 字符串
 @return 字符长度
 */
+(NSUInteger)textLength: (NSString *) text;


/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;



+ (NSString *)getMsgCountStr ;
+ (void)setMsgCountStr :(NSString *)sender ;



//存储版本信息 处理是否必须升级
+ (BOOL)storeVersionInfo:(NSDictionary *)dic;
//获取版本信息 处理是否必须升级
+ (NSDictionary *)getVersionInfo;

/**
 *  @author chenglibin
 *
 *  十六进制颜色转换成
 *
 *  @param stringToConvert // 例如： @"#123456"
 
 *
 *  @return UIColor
 */


+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
//存储是否显示红点   3个元素  0 个人中心 1设置  2关于我们
+ (BOOL)storeShowRedArray:(NSArray *)array;
//获取是否显示红点 3个元素  0 个人中心 1设置  2关于我们
+ (NSArray *)getShowRedArray;

//show 必须升级的弹框
//dic传 getVersionInfo获取 
+ (void)showMustUpdateAlert:(NSDictionary *)dic;

/**
 *  腾讯云 IM 登陆   先从自己后台拿到参数   然后登陆   腾讯云 IM 登陆
 */
+ (void)TIMLogin;






+ (UIImageView *)setTableViewBGViewNeedCount:(NSInteger)count;

+(UINavigationController *)getCurrentNav;





// 提示信息
+ (UIViewController *)showHitMsg:(NSString *)msg;


@end
