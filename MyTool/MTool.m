//
//  MTool.m
//  YoungDrill
//
//  Created by zh_mac on 2018/7/3.
//  Copyright © 2018年 czg. All rights reserved.
//

#import "MTool.h"
#import "MBProgressHUD.h"
//#import "ViewController.h"
#import "MAlertView.h"




static UIView *hudView = nil;
static CGRect oldframe;
static NSString *token;

/** 当前网络状态 */
static AFNetworkReachabilityStatus NOW_NETWORK_STATUS;

/**赛事与球员信息*/
static NSMutableDictionary *TEAM_AND_PLAYER_INFO;
/**场地信息，用于计算场地坐标与大小*/
static NSMutableDictionary *SINGLE_FIELD_INFO;

static NSInteger ForgetPasswordTimeIndex;


static NSInteger BottomBarButtonIndex;

static NSString *messageCountString;

#define DESKEY @"3b38e11ffd65698aedeb5ffc"

@interface MTool ()

@end



@implementation MTool


+(NSString *)getHostUrl{
    NSString* res = @"http://star.cjqc.com/";

#ifndef  __OFFICIAL_SERVER_DEBUG__
    res = @"http://192.168.90.240/";
#else
    //    res = @"https://s.cjqc.com";
#endif
    return res;
}




+ (void)setNetworkStatus:(AFNetworkReachabilityStatus)sender {
    NOW_NETWORK_STATUS = sender;
}

+ (AFNetworkReachabilityStatus)getNetWorkStatus {
    return NOW_NETWORK_STATUS;
}

+ (NSMutableDictionary *)getSingleFieldInfo {
    return SINGLE_FIELD_INFO;
}

+ (void)setSingleFieldInfo:(NSMutableDictionary *)sender {
    SINGLE_FIELD_INFO = [NSMutableDictionary dictionaryWithDictionary:sender];
}


+ (NSMutableDictionary *)getTeamAndPlayerInfo {
    return TEAM_AND_PLAYER_INFO;
}

+ (void)setTeamAndPlayerInfo:(NSMutableDictionary *)sender {
    TEAM_AND_PLAYER_INFO = [NSMutableDictionary dictionaryWithDictionary:sender];
}


+ (NSInteger)getForgetPasswordTimeIndex {
    return ForgetPasswordTimeIndex;
}

+ (void)setForgetPasswordTimeIndex:(NSInteger)sender {
    ForgetPasswordTimeIndex = sender;
}


+ (NSInteger)getBottomBarButtonIndex {
    return BottomBarButtonIndex;
}
+ (void)setBottomBarButtonIndex:(NSInteger)sender {
    BottomBarButtonIndex = sender;
}


+ (NSString *)getMsgCountStr {
    return messageCountString;
}
+ (void)setMsgCountStr :(NSString *)sender {
    messageCountString = sender;
}

//存储版本信息 处理是否必须升级
+ (BOOL)storeVersionInfo:(NSDictionary *)dic{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:dic];
    if (personData) {
        [myDefault setObject:personData forKey:@"versionInfomation"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}
//获取版本信息 处理是否必须升级
+ (NSDictionary *)getVersionInfo{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"versionInfomation"];
    if (personData) {
        return  (id)[NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}
/**
 *  @author chenglibin
 *
 *  十六进制颜色转换成
 *
 *  @param stringToConvert // 例如： @"#123456"
 
 *
 *  @return UIColor
 */



//存储是否显示红点   3个元素  0 个人中心 1设置  2关于我们
+ (BOOL)storeShowRedArray:(NSArray *)array{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:array];
    if (personData) {
        [myDefault setObject:personData forKey:@"versionShowRedPoint"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}
//获取是否显示红点 3个元素  0 个人中心 1设置  2关于我们
+ (NSArray *)getShowRedArray{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"versionShowRedPoint"];
    if (personData) {
        NSArray *array = (id)[NSKeyedUnarchiver unarchiveObjectWithData:personData];
        if (array.count != 3) {
            array = @[@0,@0,@0];
        }
        return array;
    }
    return @[@0,@0,@0];
}


//show 必须升级的弹框
//dic传 getVersionInfo获取
+ (void)showMustUpdateAlert:(NSDictionary *)dic{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现最新版本:%@",dic[@"versionName"]] message:[NSString stringWithFormat:@"%@",dic[@"noTegInfo"]] preferredStyle:UIAlertControllerStyleAlert];
    
    if (![dic[@"isMustUpdate"] boolValue]) {//非强制更新 添加一个取消按钮
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/mi-li-wang-wang/id1206732455?l=zh&ls=1&mt=8"]];
    }]];
//    AppDelegate *de = (id)[UIApplication sharedApplication].delegate;
//    UINavigationController *nc = (id)de.window.rootViewController;
//    [nc presentViewController:alertController animated:YES completion:nil];
}




//+ (void)requestMsgCount{
//    if (!userID) {
//        return;
//    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedHttpSessionManager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 20;
//    NSString *url = [NSString stringWithFormat:@"%@/jsp/app/news/cntNoReadNews.jsp",HTTP_HOST];
//
//    NSDictionary *dictionary = @{@"playerId":userID};
//    [manager GET:url parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if (![dic[@"success"] boolValue]) {
//            return;
//        }
//        if ([dic[@"data"] isKindOfClass:[NSNumber class]]) {
//            if (messageCountString) {
//                if (messageCountString.integerValue != [[NSString stringWithFormat:@"%@",dic[@"data"]] integerValue]) {
//                    messageCountString = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                    if (messageCountString.integerValue > 99) {
//                        messageCountString = @"99+";
//                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_NEWS object:nil];
//                }
//            }else{
//                if (messageCountString.integerValue > 99) {
//                    messageCountString = @"99+";
//                }
//                messageCountString = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_NEWS object:nil];
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
//}

+ (void)setToken:(NSString *)sender {
    token = [NSString stringWithFormat:@"%@", sender];
}

+ (NSString *)getToken {
    if (token) {
        if ([token length] > 0) {
            return token;
        }
    }
    return @"";
}

+ (CGFloat)getScreenWidth
{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    //    NSLog(@"当前分辨率：%fx%f",size_screen.height*scale_screen,size_screen.width *scale_screen);
    return size_screen.width *scale_screen;
}


+ (CGFloat)getScreenHeight
{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    return size_screen.height *scale_screen;
}

+ (BOOL)firstOpenApp
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    BOOL first = [[myDefault objectForKey:@"firstOpenApp"]boolValue];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"firstOpenApp"];
    [myDefault synchronize];
    return !first;
}

//提示框
+(void)showImage:(NSString *)image title:(NSString *)title inView:(UIView *)view withCGsize:(CGSize)size afterDelay:(CGFloat)timer
{
    if (!image||!view) {
        return;
    }
    
    if (hudView) {
        [hudView removeFromSuperview];
        hudView = nil;
    }
    hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    hudView.backgroundColor = [UIColor colorWithRed:(.0/255.0) green:(.0/255.0)  blue:(.0/255.0) alpha:.85];
    hudView.layer.cornerRadius = 5;
    hudView.layer.masksToBounds = YES;
    
    hudView.center = view.center;
    [view addSubview:hudView];
    hudView.hidden = NO;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(size.width/3, 45, size.width/3, size.height/3);
    imageView.image = [UIImage imageNamed:image];
    imageView.hidden = NO;
    [hudView addSubview:imageView];
    
    if (title&&title.length) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 32*size.width/45, size.width-40, 17)];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 1;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [hudView addSubview:label];
    }
    if (timer>0) {
        [self performSelector:@selector(hideImageView) withObject:nil afterDelay:timer];
    }
}

+ (void)hideImageView
{
    hudView.hidden = YES;
    [hudView removeFromSuperview];
    hudView = nil;
}

+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}

#pragma mark - 3des加解密
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        //        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *EncryptData = [[NSData alloc] initWithBase64EncodedString:plainText options:0];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *) [DESKEY UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding] /*autorelease]*/;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        //        result = [GTMBase64 stringByEncodingData:myData];
        result = [myData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(bufferPtr);
    bufferPtr = NULL;
    
    return result;
    
}




+ (void)showMessage:(NSString *)message inView:(UIView *)view
{
    if (!view)
    {
        AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        view = app.window;
    }

    MAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:@"MAlertView" owner:nil options:nil] objectAtIndex:0];
    [alertView showWithTitle:message inView:view];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
    // 7.0 系统的适配处理。
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    textSize = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:tdic
                                  context:nil].size;
    
    return textSize;
}


#pragma mark - 将YYYY-MM-dd HH:mm:ss时间转换为MM-dd HH:mm的时间格式
/**
 * @brief   将YYYY-MM-dd HH:mm:ss时间转换为MM-dd HH:mm的时间格式
 * @param   uiDate    YYYY-MM-dd HH:mm:ss时间
 * @return  NSString   MM-dd HH:mm 时间
 */
+ (NSString *)convertDateStringFromString:(NSString*)uiDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    NSDate *date=[formatter dateFromString:uiDate];
    
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}


+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    
    NSLog(@"data %@",date);
    return date;
}

+ (NSDate *)stringDateToDate:(NSString *)dateString {
//    @"2013-03-24 10:45:32"
    NSString *currentDateString = dateString;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    return [dateFormater dateFromString:currentDateString];
}

//1406702751547
+ (NSString *)dateAllStringFromString:(NSString *)timeString
{
    return [MTool dateStringFromString:timeString toFormat:@"YYYY-MM-dd HH:mm:ss"];
}



+ (NSString *)datePartStringFromString:(NSString *)timeString
{
    return [MTool dateStringFromString:timeString toFormat:@"YYYY-MM-dd"];
}

/**
 *  获取当前的13位的时间戳
 */
+ (NSString *)getNow1970Date{
    
    NSDate *date = [NSDate date];
//    NSLog(@"%lf",[date timeIntervalSince1970] * 1000);
    return [NSString stringWithFormat:@"%.lf",[date timeIntervalSince1970] * 1000];
}
/**
 *  将13位时间转换为年月日
 */
+(NSString *)dateSub10String:(NSString *)timeString{
    return [[self dateAllStringFromString:timeString] substringToIndex:10];
}


#pragma mark - 将13位时间转换为想要的时间格式
/**
 * @brief   将13位时间转换为想要的时间格式
 * @param   timeString    13位时间
 * @param   toFormat    格式（如：YYYY-MM-dd HH:mm:ss）
 * @return  NSString 时间
 */
+ (NSString *)dateStringFromString:(NSString *)timeString toFormat:(NSString *)toFormat
{
    if (timeString.length >= 10)
    {
        NSTimeInterval timeInterval = [timeString doubleValue]/1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:toFormat];
        
        NSString *str = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        
        return str;
    } else {
        NSTimeInterval timeInterval = [timeString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:toFormat];
        
        NSString *str = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        
        return str;
    }
    return @"";
}

/**
 将日期转换为星期
 
 @param timeString 时间戳
 @return 星期
 */
+ (NSString *)getWeekWithTimeString:(NSString *)timeString{
    
    NSTimeInterval timeInterval;
    if (timeString.length >= 10){
        timeInterval = [timeString doubleValue]/1000;
    }else{
        timeInterval = [timeString doubleValue];
    }
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    return[weekdays objectAtIndex:theComponents.weekday];
    
    

}

+ (NSString*)compareTwoTime:(NSString *)timeStr time2:(NSString *)timeStr2{
    
    long long time1 = [timeStr longLongValue];
    long long time2 = [timeStr2 longLongValue];

    NSTimeInterval balance = time2 /1000- time1 /1000;
    
    NSString*timeString = [[NSString alloc]init];
    
    timeString = [NSString stringWithFormat:@"%f",balance /60];
    
    timeString = [timeString substringToIndex:timeString.length-7];
   
    return timeString;
    
    
   
}




+ (NSString *)dateToString:(NSDate *)sender {
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [sender timeIntervalSince1970] * 1000;
//    NSTimeInterval now = [sender timeIntervalSince1970];
    
    NSMutableString *stringTime = [NSMutableString stringWithFormat:@"%lld", (long long)now];
//    if ([stringTime length] < 13) {
//        while ([stringTime length] < 13) {
//            [stringTime appendString:@"0"];
//        }
//    }
    
    return stringTime;
}

+ (NSString *)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

//存储当前刷新状态
+ (BOOL)storeCurrentRefresh:(NSString *)refresh
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:refresh];
    if (personData) {
        [myDefault setObject:personData forKey:@"refresh"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}
//存储当前刷新时间间隔
+ (BOOL)storeCurrentRefreshTimeInterval:(NSString *)interval
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:interval];
    if (personData) {
        [myDefault setObject:personData forKey:@"timeInterval"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

+ (BOOL)getCurrentRefresh
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"refresh"];
    if (personData) {
        return  [[NSKeyedUnarchiver unarchiveObjectWithData:personData] boolValue];
    }
    return nil;
}

+ (NSInteger)getCurrentRefreshTimeInterval
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"timeInterval"];
    if (personData) {
        return  [[NSKeyedUnarchiver unarchiveObjectWithData:personData] integerValue];
    }
    return 0;
}

#pragma mark - 正则校验
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL) deptNumInputShouldNumber:(NSString *)str
{
     NSString *regex = @"[0-9]*";
     NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
     return ([pred evaluateWithObject:str]) ;
}



#pragma mark - 设置是否开启推送
/**
 * @brief   设置是否开启推送
 * @param   open    YES开启，NO不开启
 * @return  是否成功
 */
+ (BOOL)storeCurrentOpenAPN:(NSString *)open {
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:open];
    if (personData) {
        [myDefault setObject:personData forKey:@"isOpenAPN"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

#pragma mark - 得到是否开启推送
/**
 * @brief   得到是否开启推送
 * @return  YES开启，NO不开启
 */
+ (NSString *)getOpenAPN {
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"isOpenAPN"];
    if (personData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}


#pragma mark - 设置是否显示过引导页
/**
 * @brief   是否显示过引导页
 * @param   version    版本号，如果版本号与得到的版本号一至就是显示过，如果没有版本号或是与当前得到的版本号不一至就是没有显示过
 * @return  是否成功
 */
+ (BOOL)storeCurrentShowGuide:(NSString *)version {
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:version];
    if (personData) {
        [myDefault setObject:personData forKey:@"showGuide"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

#pragma mark - 分享

+ (void)WechatsharePictureWithShareType:(int)shareType title:(NSString *)title descr:(NSString *)descr Image:(UIImage *)image urlImg:(NSString *)urlImg{
//    WXMediaMessage *message = [[WXMediaMessage alloc] init];
//    message.title = title;
//    message.description = descr;
//    [message setThumbImage:image];
//
//    WXWebpageObject * webObject = [WXWebpageObject object];
//    webObject.webpageUrl = urlImg;
//    message.mediaObject = webObject;
//
//    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = shareType;
//
//    [WXApi sendReq:req];
}

#pragma mark - 得到是否显示过引导页
/**
 * @brief   是否显示过引导页
 * @return  版本号，如果版本号与得到的版本号一至就是显示过，如果没有版本号或是与当前得到的版本号不一至就是没有显示过
 */
+ (NSString *)getShowGuide {
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"showGuide"];
    if (personData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}

#pragma mark 存储当前登陆状态
+ (BOOL)storeCurrentLoginState:(NSString *)loginStr
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:loginStr];
    if (personData) {
        [myDefault setObject:personData forKey:@"loginState"];
        [myDefault synchronize];
        
        if ([loginStr isEqualToString:@"login"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFinisNotification" object:nil userInfo:nil];
        }else{
            messageCountString = @"0";
//            [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_NEWS object:nil];
        }
        return YES;
    }
    
    if ([loginStr isEqualToString:@"login"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFinisNotification" object:nil userInfo:nil];
    }else{
        messageCountString = @"0";
//        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_NEWS object:nil];
    }
    return NO;
}

+ (NSString *)getCurrentLastLoginState
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"loginState"];
    if (personData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}

#pragma mark 存储当前返回的信息
+ (BOOL)storeCurrentUserName:(NSString *)userName
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:userName];
    if (personData) {
        [myDefault setObject:personData forKey:@"userName"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}
+ (BOOL)storeCurrentUserPwd:(NSString *)userPwd
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:userPwd];
    if (personData) {
        [myDefault setObject:personData forKey:@"userPwd"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

+ (NSString *)getUserName
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"userName"];
    if (personData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}

+ (NSString *)getUserPwd
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"userPwd"];
    if (personData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}


+ (BOOL)storeNotificationState:(BOOL)b
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:b]];
    if (personData) {
        [myDefault setObject:personData forKey:@"NotificationState"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

+(BOOL)getNotificationState
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"NotificationState"];
    if (personData) {
        return  [[NSKeyedUnarchiver unarchiveObjectWithData:personData] boolValue];
    }
    return YES;
}

+ (BOOL)storeVoiceState:(BOOL)b
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:b]];
    if (personData) {
        [myDefault setObject:personData forKey:@"VoiceState"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

+(BOOL)getVoiceState
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"VoiceState"];
    if (personData) {
        return  [[NSKeyedUnarchiver unarchiveObjectWithData:personData] boolValue];
    }
    return YES;
}


//保存动效状态
+ (BOOL)storeDynamicState:(BOOL)b{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:b]];
    if (personData) {
        [myDefault setObject:personData forKey:@"dynamicState"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}
//获得动效状态
+(BOOL)getDynamicState{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"dynamicState"];
    if (personData) {
        return  [[NSKeyedUnarchiver unarchiveObjectWithData:personData] boolValue];
    }
    return YES;
}


//保存通过手机号搜索到我状态
+ (BOOL)storeSearchAddressBookState:(BOOL)b{
    
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:b]];
    if (personData) {
        [myDefault setObject:personData forKey:@"searchAddressBookState"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}
//获得通过手机号搜索到我状态
+(BOOL)getSearchAddressBookState{
    
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"searchAddressBookState"];
    if (personData) {
        return  [[NSKeyedUnarchiver unarchiveObjectWithData:personData] boolValue];
    }
    return YES;
}
//保存推荐通讯录朋友状态
+ (BOOL)storePushAddressBookState:(BOOL)b{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:b]];
    if (personData) {
        [myDefault setObject:personData forKey:@"pushAddressBookState"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}
//获得推荐通讯录朋友状态
+(BOOL)getPushAddressBookState{
    
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"pushAddressBookState"];
    if (personData) {
        return  [[NSKeyedUnarchiver unarchiveObjectWithData:personData] boolValue];
    }
    return YES;
}


+(BOOL)mainDataMessage:(NSDictionary *)curretnPersonDic
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:curretnPersonDic];
    if (personData) {
        [myDefault setObject:personData forKey:@"mainData"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

+ (NSMutableDictionary  *)getMainDataMessage
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"mainData"];
    if (personData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}



+(BOOL)storeCurrentMessage:(NSDictionary *)curretnPersonDic
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:curretnPersonDic];
    if (personData) {
        [myDefault setObject:personData forKey:@"login"];
        [myDefault synchronize];
        return YES;
    }
    return NO;
}

+ (NSMutableDictionary  *)getCurrentMessage
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSData *personData = [myDefault objectForKey:@"login"];
    if (personData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:personData];
    }
    return nil;
}


/** 存储当前用户信息 */
+(BOOL)storeCurrentUserModel:(User *)userModel{
    // 沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
    
    //存进沙盒 自定义对象的存储必须用NSKeyedArchiver，
    BOOL choose = [NSKeyedArchiver archiveRootObject:userModel toFile:path];
    return choose;
}

/** 获取当前用户信息 */
+ (User  *)getCurrentUserModel{
    // 取出对象沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

/** 获取当前用户ID */
//+ (NSString  *)getcoachId{
//    User *model = [self getCurrentUserModel];
//    return model.coachId;
//}

/** 获取当前教练ID */
//+ (NSString  *)getorgId{
//    User *model = [self getCurrentUserModel];
//    return model.orgId;
//}


/**
 获取当前机构名称
 
 @return 机构名称
 */
//+ (NSString  *)getorgName{
//    User *model = [self getCurrentUserModel];
//    return model.orgName;
//}




//清除当前信息
+ (void)removeCurrentMessage
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    [myDefault removeObjectForKey:@"login"];
}





/**
 * Retain a formated string with a real date string
 *
 * @param dateString a real date string, which can be converted to a NSDate object
 *
 * @return a string that will be x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
    // 把日期字符串格式化为日期对象
    NSDate *date = nil;
    if (dateString.length == 13)
    {
        NSTimeInterval timeInterval = [dateString doubleValue]/1000;
        date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        date = [MTool getNowDateFromatAnDate:date];
    } else {
        return @"";
    }
    
    NSDate *curDate = [NSDate date];
    curDate = [MTool getNowDateFromatAnDate:curDate];
//    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *curDateComps;// = [[NSDateComponents alloc] init];
    curDateComps = [calendar components:unitFlags fromDate:curDate];
    
    NSDateComponents *dateComps;// = [[NSDateComponents alloc] init];
    dateComps = [calendar components:unitFlags fromDate:date];
    
    

    if ([curDateComps day] == [dateComps day]) {
        return [MTool dateStringFromString:dateString toFormat:@"HH:mm"];
    } else {
        return [NSString stringWithFormat:@"%ld天前", (long)abs([MTool intervalSinceNow:dateString])];
    }
    
    return @"1小时前";
}


+ (int)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSince1970:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;
}


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}




/**
 * @brief   通过text view中的文字与宽度，计算出高度
 * @param   textView 要计算的textView
 * @return  CGSize  计算后的大小
 */
+ (CGSize)contentSizeHeightOfTextView:(UITextView *)textView {
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    
    return textViewSize;
}

/**
 * @brief   通过label中的文字与宽度，计算出高度
 * @param   label 要计算的label
 * @return  CGSize  计算后的大小
 */
+ (CGSize)contentSizeHeightOfLabel:(UILabel *)label {
    CGSize labelSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, FLT_MAX)];
    
    return labelSize;
}

/**
 * @brief   通过label中的文字与高度，计算出宽度
 * @param   label 要计算的label
 * @return  CGSize  计算后的大小
 */
+ (CGSize)contentSizeWidthOfLabel:(UILabel *)label {
    CGSize labelSize = [label sizeThatFits:CGSizeMake(FLT_MAX, label.frame.size.height)];
    
    return labelSize;
}


/**
 * @brief   复制View
 * @param   view 要复制的view
 * @return  UIView  复制的View
 */
+ (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}


/**
 * @brief   检查是否是数组，数组长度是否大于0
 * @param   id 要检查的对象
 * @return  BOOL
 */
+ (BOOL)checkingIsArray:(id)sender {
    
    if (sender) {
        if ([sender isKindOfClass:[NSArray class]] || [sender isKindOfClass:[NSMutableArray class]]) {
            if ([sender count] > 0) {
                return YES;
            }
        }
    }
    
    return NO;
}

/**
 * @brief   检查是否是string，长度是否大于0
 * @param   id 要检查的对象
 * @return  BOOL
 */
+ (BOOL)checkingIsString:(id)sender {
    if (sender) {
        if ([sender isKindOfClass:[NSString class]] ||[sender isKindOfClass:[NSMutableString class]]) {
            if ([sender length] > 0) {
                if ([sender isEqualToString:@"(null)"]) {
                    return NO;
                }
                return YES;
            }
        }
    }
    return NO;
}

/**
 * @brief   检查是否是Dic，长度是否大于0
 * @param   id 要检查的对象
 * @return  BOOL
 */
+ (BOOL)checkingIsDic:(id)sender {
    if (sender) {
        if ([sender isKindOfClass:[NSDictionary class]] ||[sender isKindOfClass:[NSMutableDictionary class]]) {
            if ([sender count] > 0) {
                return YES;
            }
        }
    }
    return NO;
}



/**
 * @brief   读取plist文件，得到内容为DIC
 * @param   fileName plist名
 * @return  NSMutableDictionary
 */
+ (NSMutableDictionary *)readPlistToDic:(NSString *)fileName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (data) {
        if ([data isKindOfClass:[NSMutableDictionary class]]) {
            return data;
        }
    }
    return nil;
}

/**
 * @brief   将DIC写入到plist文件
 * @param   fileName plist名
 * @param   dataDic DIC
 */
+ (void)pushDicToPlist:(NSMutableDictionary *)dataDic fileName:(NSString *)fileName {
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    //输入写入
    [dataDic writeToFile:filename atomically:YES];
    
//    //那怎么证明我的数据写入了呢？读出来看看
//    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
//    NSLog(@"%@", data1);
}





/**
 * @brief   读取plist文件，得到内容为Array
 * @param   fileName plist名
 * @return  NSMutableArray
 */
+ (NSMutableArray *)readPlistToArray:(NSString *)fileName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    if (data) {
        if ([data isKindOfClass:[NSMutableArray class]]) {
            return data;
        }
    }
    return nil;
}

/**
 * @brief   将Array写入到plist文件
 * @param   fileName plist名
 * @param   dataArray array
 */
+ (void)pushArrayToPlist:(NSMutableArray *)dataArray fileName:(NSString *)fileName {
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    //输入写入
    [dataArray writeToFile:filename atomically:YES];
    
//    //那怎么证明我的数据写入了呢？读出来看看
//    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filename];
//    NSLog(@"%@", data1);
}


/**
 * @brief   文件是否存在
 * @param   path 路径
 * @param   isCreate 如果不存在，是否创建  YES创建、NO不创建
 * @param   BOOL
 */
+ (BOOL)fileExists:(NSString *)path isCreate:(BOOL)isCreate{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath:path]) {//如果文件存在
        NSLog(@"文件已经存在");
        return YES;
    } else {
        if (isCreate) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
    }
    return NO;
}


/**
 * @brief   文件是否存在在Documents目录下
 * @param   name 文件名
 * @param   isCreate 如果不存在，是否创建  YES创建、NO不创建
 * @param   BOOL
 */
+ (BOOL)fileExistsForName:(NSString *)name isCreate:(BOOL)isCreate {
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:name];
    
    return [MTool fileExists:filename isCreate:isCreate];
}


/**
 * @brief   将信息写入到plist
 * @param   sender 信息DIC
 */
+ (void)pushDicToPlist:(NSMutableDictionary *)sender name:(NSString *)name{
    [MTool fileExistsForName:[NSString stringWithFormat:@"%@.plist", name] isCreate:YES];
    [MTool pushDicToPlist:sender fileName:name];
}

/**
 * @brief   得到plist信息
 * @return  NSString 文件名
 */
+ (NSDictionary *)getDicFromPlist:(NSString *)name {
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    if (data) {
        if ([data isKindOfClass:[NSMutableDictionary class]]) {
            return data;
        }
    }
    return nil;
}


/**
 * @param sender 地区信息数组
 * @param province 要查询的省
 * @return NSDictionary 省信息
 */
+ (NSDictionary *)getProvince:(NSArray *)sender province:(NSString *)province {
    for (NSDictionary *temp in sender) {
        if ([MTool checkingIsDic:temp]) {
            if ([[temp objectForKey:@"name"] isEqualToString:province] || [[temp objectForKey:@"code"] isEqualToString:province]) {
                return temp;
            }
        }
    }
    return nil;
}

/**
 * @param sender 地区信息数组
 * @param city 要查询的市
 * @return NSDictionary 市信息
 */
+ (NSDictionary *)getCity:(NSArray *)sender city:(NSString *)city {
    for (NSDictionary *temp in sender) {
        if ([MTool checkingIsDic:temp]) {
            if ([[temp objectForKey:@"name"] isEqualToString:city]) {
                return temp;
            }
        }
    }
    return nil;
}



+ (void)callPhone:(NSString *)phoneNum {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
}



+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}



//+(NSString *)identifier
//{
//    NSString *key = @"com.app.keychain.uuid";
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil];
//
//    NSString *strUUID = [keychainItem objectForKey:(__bridge id)kSecValueData];
//
//    if (strUUID.length <= 0) {
//        strUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//
//        [keychainItem setObject:@"uuid" forKey:(__bridge id)kSecAttrAccount];
//        [keychainItem setObject:strUUID forKey:(__bridge id)kSecValueData];
//    }
//
//    return strUUID;
//}


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
+ (void)setViewRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners view:(id)view {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:((UIView *)view).bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = ((UIView *)view).bounds;
    maskLayer.path = maskPath.CGPath;
    ((UIView *)view).layer.mask = maskLayer;
}


/**
 * @brief   设置圆角
 * @param   radius 圆角度数
 * @param   view
 */
+ (void)setViewRadius:(CGFloat)radius view:(id)view {
    ((UIView *)view).layer.cornerRadius = radius;
    ((UIView *)view).layer.masksToBounds = YES;
}






/**
 * @brief   描边
 * @param   borderWidth 边宽度
 * @param   color 颜色
 * @param   view
 */
+ (void)setViewBorder:(CGFloat)borderWidth color:(UIColor *)color view:(id)view {
    ((UIView *)view).layer.borderColor = color.CGColor;
    ((UIView *)view).layer.borderWidth = borderWidth;
}

/**
 * @brief   描边并加圆角
 * @param   borderWidth 边宽度
 * @param   color 颜色
 * @param   radius 圆角度数
 * @param   view
 */
+ (void)setViewRadiusAndBorder:(CGFloat)borderWidth color:(UIColor *)color radius:(CGFloat)radius view:(id)view {
    ((UIView *)view).layer.cornerRadius = radius;
    ((UIView *)view).layer.masksToBounds = YES;
    ((UIView *)view).layer.borderColor = color.CGColor;
    ((UIView *)view).layer.borderWidth = borderWidth;
}

/**
 * @brief   描边并加圆角 圆角4 颜色153/153/153 线宽0.5
 * @param   view
 */
+ (void)setViewRadiusAndBorder:(id)view {
    ((UIView *)view).layer.cornerRadius = 4;
    ((UIView *)view).layer.masksToBounds = YES;
    ((UIView *)view).layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
    ((UIView *)view).layer.borderWidth = 0.5;
}

/**
 * @brief   设置UITextField左边距
 * @param   textField textField
 * @param   leftWidth 距离
 */
+ (void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth {
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}


/**
 * @brief   播放按键音
 * @param   soundName 声音名
 */
+ (void)playSound:(NSString *)soundName {
    
    if (![MTool getVoiceState]) {//声音关了
        return;
    }
    
//    NSString *playSound = [userinfo whetherPlayingMusic];
//    if ([playSound length] > 0) {
//        if ([playSound integerValue] != 1) {
//            return;
//        }
//    } else {
//        [userinfo setWhetherToPlaySound:@"1"];
//    }
    NSString *path = [[NSBundle mainBundle]pathForResource:@"chack.wav" ofType:nil];
    if ([MTool checkingIsString:soundName]) {
        path = [[NSBundle mainBundle]pathForResource:soundName ofType:nil];
    }
    

    NSURL *url = [NSURL fileURLWithPath:path];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    if (error == kAudioServicesNoError){
        NSLog(@"sadfasfdsf ");
    }else {
        NSLog(@"Failed to create sound ");
    }
    
    AudioServicesPlaySystemSound(soundID);
}


#pragma mark -手机别名
+(NSString *)phoneName
{
    return [[UIDevice currentDevice] name];
}


#pragma mark -手机系统版本
/**
 *  手机系统版本
 *
 *  @return e.g. 8.0
 */
+(NSString *)phoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark -手机型号
//这个方法只能获取到iPhone、iPad这种信息，无法获取到是iPhone 4、iPhpone5这种具体的型号。
/**
 *  手机型号
 *
 *  @return e.g. iPhone
 */
+(NSString *)phoneModel{
    return [[UIDevice currentDevice] model];
}


#pragma mark - 设备版本
//这个代码可以获取到具体的设备版本（已更新到iPhone 6s、iPhone 6s Plus），缺点是：采用的硬编码。具体的对应关系可以参考：https://www.theiphonewiki.com/wiki/Models
//这个方法可以通过AppStore的审核，放心用吧。
/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
+ (NSString *)DeviceVersion {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}


/**
 * @brief   提示框展示纯文字类型
 * @param   text 文字
 * @param   showTime 显示时间
 */
+ (void)showText:(NSString *)text showTime:(NSInteger)showTime{
    
    UIView *view = [[UIApplication sharedApplication].windows firstObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:20];
    
    //这个是提示框的背景View
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.68];
    [hud hideAnimated:YES afterDelay:showTime];
}



/**
 * @brief   提示框展示纯文字类型
 * @param   text 文字
 */
+ (void)showText:(NSString *)text{
    [self showText:text showTime:2];
}




/**
 * @brief   把Button的图标放在文字的右边  前提是文字跟图片有值   多加了3像素的间隙
 * @param
 */
+ (void)rightButtonImg:(UIButton *)button{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = button.titleLabel.font;
    
    CGFloat textW = [button.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width + button.imageView.bounds.size.width + 3;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, textW, 0, -textW);
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.bounds.size.width, 0, button.imageView.bounds.size.width);
}


/**
 * @brief   给要视图裁圆 切增加阴影  (masksToBounds= NO的情况下)
 * @param   view        需要加效果的视图
 * @param   isSquare    方的阴影还是圆的
 */
+ (void)addShadow:(UIView *)view shadowColor:(UIColor *)color isSquare:(BOOL)isSquare{
    
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOpacity = 1.0;
    view.layer.shadowRadius = 8;
    
    if (isSquare) {
        CGMutablePathRef squarePath = CGPathCreateMutable();
        CGPathAddRect(squarePath, NULL, view.bounds);
        view.layer.shadowPath = squarePath; CGPathRelease(squarePath);
    }else{
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath, NULL, view.bounds);
        view.layer.shadowPath = circlePath; CGPathRelease(circlePath);
    }
}

/**
 * @brief   给要视图裁圆 切增加阴影  (masksToBounds=YES 的情况下)
 * @param   view        需要加效果的视图
 * @param   corner      裁圆的角度
 * @param   superView   view的父视图
 * @param   shadowColor 阴影颜色
 * @param   isSquare    方的阴影还是圆的
 * @param   frame       这是因为有的XIB 布局的空间 阴影错位
 */
+ (void)addShadow:(UIView *)view cornerValue:(CGFloat)corner superView:(UIView*)superView shadowColor:(UIColor *)color isSquare:(BOOL)isSquare frame:(CGRect)frame{
    
    view.layer.cornerRadius =corner;
    view.layer.masksToBounds = YES;
    
    CALayer *subLayer=[CALayer layer];
    
    CGRect fixframe;
    if (frame.size.width) {
        fixframe = frame;
    }else{
      fixframe = view.layer.frame;
    }
    
    subLayer.frame=  fixframe;
    subLayer.cornerRadius = corner;
    
    subLayer.backgroundColor=[UIColor clearColor].CGColor;
    
    subLayer.shadowColor= color.CGColor;
    
    subLayer.shadowOpacity=1;
    
    subLayer.shadowRadius= 6;
    subLayer.shadowOffset = CGSizeMake(0, 1);
    
    if (isSquare) {
        CGMutablePathRef squarePath = CGPathCreateMutable();
        CGPathAddRect(squarePath, NULL, view.bounds);
        subLayer.shadowPath = squarePath; CGPathRelease(squarePath);
    }else{
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath, NULL, view.bounds);
        subLayer.shadowPath = circlePath; CGPathRelease(circlePath);
    }
    [superView.layer insertSublayer:subLayer below:view.layer];
}

//根据文字跟最大宽计算出控件该有的高度
+ (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    return [self sizeWithText:text font:font maxSize:maxSize].height;;
    
}

//根据文字跟最大宽计算出
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    NSString *string = [NSString stringWithFormat:@"%@",text];
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}



/**
 * @brief  快速创建Lable
 * @param   left 左边距离
 * @param   top 顶部距离
 * @param   width 宽度
 * @param   heigh 高度
 * @param   title 文字
 */

+(UILabel *)quickCreateLabelWithleft:(CGFloat)left top:(CGFloat)top width:(CGFloat)width heigh:(CGFloat)heigh title:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, width, heigh)];
    label.text = title;
//    label.backgroundColor = [UIColor orangeColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:8];
    return label;
    
}
/**
 * @brief  快速创建UITextField
 * @param   frame 位置大小
 
 */
+(UITextField*)CreateTextFieldWithFrame:(CGRect)frame withCapacity:(NSString *)placeholder withSecureTextEntry:(BOOL)isSecoure withTargrt:(id)t withTag:(NSInteger)tag {
    UITextField * qcTextfield = [[UITextField alloc]initWithFrame:frame];
    [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];
    //qcTextfield.background = [UIImage imageNamed:image];
    qcTextfield.backgroundColor = [UIColor clearColor];
    //qcTextfield.clearButtonMode = UITextFieldViewModeAlways;
    qcTextfield.returnKeyType = UIReturnKeyDefault;
    qcTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    qcTextfield.secureTextEntry = isSecoure;
    qcTextfield.placeholder = placeholder;
    qcTextfield.delegate = t;
    qcTextfield.tag = tag;
    return qcTextfield;
    
}



/**
 *  @author chenglibin
 *
 *  十六进制颜色转换成
 *
 *  @param stringToConvert // 例如： @"#123456"
 
 *
 *  @return UIColor
 */


+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    NSInteger r = (hex >> 16) & 0xFF;
    NSInteger g = (hex >> 8) & 0xFF;
    NSInteger b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

//判断是否以字母开头
+(BOOL)MatchLetter:(NSString *)str
{
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}
//是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
+(BOOL)isChineseFirst:(NSString *)firstStr
{
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
}
//判断是否以数字开头
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 获取字符串字符长度
 
 @param text 字符串
 @return 字符长度
 */
+(NSUInteger)textLength: (NSString *) text{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
}




/*
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}



+ (UIImageView *)setTableViewBGViewNeedCount:(NSInteger)count{
    if (count) {
        return nil;
    }else{
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"超级榜_暂无内容"]];
        imgView.contentMode = UIViewContentModeCenter;
        return imgView;
    }
}

+(UINavigationController *)getCurrentNav
{
    AppDelegate *de = (id)[UIApplication sharedApplication].delegate;
    UITabBarController *nc = (id)de.window.rootViewController;
    UINavigationController *rootNav = (UINavigationController *)[nc.viewControllers objectAtIndex:nc.selectedIndex];
    return rootNav;
    
}







+ (UIViewController *)showHitMsg:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    return alertController;
}




@end
