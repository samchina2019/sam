//
//  ContactListViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/24.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactCell.h"

#import "ContactModel.h"
#import "DataModel.h"
#import "FriendsListModel.h"

#import <MessageUI/MessageUI.h>


@interface ContactListViewController ()<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray *resultData;
@property (nonatomic, assign) BOOL searchActive;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSArray *pipeiArray;
///选中的cell
@property (nonatomic, strong) ContactCell *selectCell;
@property (nonatomic, strong) NSArray *tableData;
///选中最后的结果
@property (nonatomic, strong) NSArray *finishData;
///选中的index
@property (nonatomic, assign) NSInteger index;
///选中的index
@property (nonatomic, assign) NSInteger section;
///排序数据
@property (nonatomic, strong) NSArray *tableIndexData;
///结果排序数据
@property (nonatomic, strong) NSMutableArray *resultIndexData;

@end

@implementation ContactListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
        [self refresh];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"添加手机联系人";
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
   
    self.tableView.tableFooterView = [UIView new];
 
}
#pragma mark – Network
- (void)refresh {
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    NSDictionary *params = @{@"phones":self.phoneStr};
    
    [DZNetworkingTool postWithUrl:kContactPipei params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            self.pipeiArray = [FriendsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
           //遍历需要搜索的所有内容，其中self.dataArray为存放总数据的数组
                [self.dataArray enumerateObjectsUsingBlock:^(ContactModel *contactModelmodel, NSUInteger aIdx, BOOL *_Nonnull stop) {
                    [DZTools hideHud];
                    [self.pipeiArray enumerateObjectsUsingBlock:^(FriendsListModel *usermodel, NSUInteger aIdx, BOOL *_Nonnull stop) {
                        if ([contactModelmodel.phone isEqualToString:usermodel.mobile]) {
                            contactModelmodel.userInfo = usermodel;
                        }
                    }];
                    if (contactModelmodel.userInfo == nil) {
                        contactModelmodel.userInfo = [[FriendsListModel alloc]init];
                        contactModelmodel.userInfo.status = @"2";
                    }
                    NSArray *tempArray = [self sringSectioncompositor:self.dataArray withSelector:@selector(name) isDeleEmptyArray:YES];
                    
                    self.tableData = tempArray[0];
                    self.tableIndexData = tempArray[1];
                }];
                    [self.tableView reloadData];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];// 放弃第一响应者
    if (searchBar.text.length == 0) {
        self.searchActive = NO;
        [self.tableView reloadData];
        return;
    }
    self.searchActive = YES;
    self.resultData = [NSMutableArray array];
    //遍历需要搜索的所有内容，其中self.dataArray为存放总数据的数组
        [self.dataArray enumerateObjectsUsingBlock:^(ContactModel *model, NSUInteger aIdx, BOOL *_Nonnull stop) {
            NSString *tempStr = model.phone;
            if ([tempStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].length > 0) {
                //把搜索结果存放self.resultArray数组
                [self.resultData addObject:model];
            }
        }];
    // 将耗时操作放到子线程
    dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSArray *tempArray = [self sringSectioncompositor:self.resultData withSelector:@selector(name) isDeleEmptyArray:YES];
        self.finishData = tempArray[0];
        self.tableIndexData = tempArray[1];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Scroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark - tableView View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.searchActive ? self.finishData.count : self.tableData.count;
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.searchActive ? self.resultIndexData : self.tableIndexData;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchActive ? [self.finishData[section] count] : [self.tableData[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    ContactModel *model = self.searchActive ? self.finishData[indexPath.section][indexPath.row] : self.tableData[indexPath.section][indexPath.row];
   
    cell.nameLabel.text = model.name;
    cell.phoneNumberLabel.text = model.phone;
    if (model.userInfo == nil) {
        model.userInfo = [[FriendsListModel alloc]init];
        model.userInfo.status = @"2";
    }
    if ([model.userInfo.status intValue] == 0) {
        cell.stateBtn.backgroundColor = [UIColor whiteColor];
        [cell.stateBtn setTitle:@"已添加" forState:UIControlStateNormal];
    }else if ([model.userInfo.status intValue] == 1) {
        cell.stateBtn.backgroundColor = UIColorFromRGB(0x3FAEE9);
        [cell.stateBtn setTitle:@"添加" forState:UIControlStateNormal];
    }else if ([model.userInfo.status intValue] == 2) {
        cell.stateBtn.backgroundColor = UIColorFromRGB(0x3FAEE9);
        [cell.stateBtn setTitle:@"邀请" forState:UIControlStateNormal];
    }
    return cell;
}

//返回当用户触摸到某个索引标题时列表应该跳至的区域的索引。
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //    [SVProgressHUD showImage:nil status:title];
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}
#pragma mark - Table View Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * tempLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    tempLab.text = self.searchActive ? self.resultIndexData[section] : _tableIndexData[section];
    tempLab.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    return tempLab;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactModel *model = self.searchActive ? self.finishData[indexPath.section][indexPath.row] : self.tableData[indexPath.section][indexPath.row];
    
    if ([model.userInfo.status intValue] == 0) {
        
    }else if ([model.userInfo.status intValue] == 1) {
       
            NSDictionary *params = @{
                                     @"friend_id":@(model.userInfo.user_id)
                                     };
            [DZNetworkingTool postWithUrl:kApplyFriend params:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                }else{
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                
            } IsNeedHub:NO];
        
    }else if ([model.userInfo.status intValue] == 2) {
        
        if ([MFMessageComposeViewController canSendText] == YES) {
            self.selectCell = [tableView cellForRowAtIndexPath:indexPath];
            self.index = indexPath.row;
            self.section = indexPath.section;
            MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
            //  设置代理<MFMessageComposeViewControllerDelegate>
            messageVC.messageComposeDelegate = self;
            //  发送To Who
            messageVC.recipients = @[model.phone];
            messageVC.body = model.userInfo.content;
            [self presentViewController:messageVC animated:YES completion:nil];
            
        }else{
            
            NSLog(@"此设备不支持");
        }
    }
}
//将传进来的对象按通讯录那样分组排序，每个section中也排序  dataarray是中存储的是一组对象，selector是属性名
- (NSArray *)sringSectioncompositor:(NSArray *)dataArray withSelector:(SEL)selector isDeleEmptyArray:(BOOL)isDele {
    
    //    UILocalizedIndexedCollation是苹果贴心为开发者提供的排序工具，会自动根据不同地区生成索引标题
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *indexArray = [NSMutableArray arrayWithArray:collation.sectionTitles];
    
    NSUInteger sectionNumber = indexArray.count;
    //建立每个section数组
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionNumber];
    for (int n = 0; n < sectionNumber; n++) {
        NSMutableArray *subArray = [NSMutableArray array];
        [sectionArray addObject:subArray];
    }
    
    for (ContactModel *model in dataArray) {

        NSInteger index = [collation sectionForObject:model collationStringSelector:selector];
        NSMutableArray *tempArray = sectionArray[index];
        [tempArray addObject:model];
    }
    for (NSMutableArray *tempArray in sectionArray) {
        //        根据SEL方法返回的string对数组元素排序
        NSArray *sorArray = [collation sortedArrayFromArray:tempArray collationStringSelector:selector];
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:sorArray];
    }
    
    //    是否删除空数组
    if (isDele) {
        [sectionArray enumerateObjectsWithOptions:NSEnumerationReverse
                                       usingBlock:^(NSArray *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                           if (obj.count == 0) {
                                               [sectionArray removeObjectAtIndex:idx];
                                               [indexArray removeObjectAtIndex:idx];
                                           }
                                       }];
    }
    //返回第一个数组为table数据源  第二个数组为索引数组
    return @[sectionArray, indexArray];
    
}
//将汉字转为拼音 是否支持全拼可选
- (NSString *)transformToPinyin:(NSString *)aString isQuanPin:(BOOL)quanPin {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    if (quanPin) {
        int count = 0;
        for (int i = 0; i < pinyinArray.count; i++) {
            for (int i = 0; i < pinyinArray.count; i++) {
                if (i == count) {
                    [allString appendString:@"#"];
                    //区分第几个字母
                }
                [allString appendFormat:@"%@", pinyinArray[i]];
            }
            [allString appendString:@","];
            count++;
        }
    }
    
    NSMutableString *initialStr = [NSMutableString new];
    //拼音首字母
    for (NSString *s in pinyinArray) {
        if (s.length > 0) {
            [initialStr appendString:[s substringToIndex:1]];
        }
    }
    [allString appendFormat:@"#%@", initialStr];
    [allString appendFormat:@",#%@", aString];
    return allString;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            self.selectCell.stateBtn.backgroundColor = [UIColor whiteColor];
            [self.selectCell.stateBtn setTitle:@"已邀请" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
   
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.index inSection: self.section ], nil]  withRowAnimation:UITableViewRowAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
