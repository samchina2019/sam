//
//  SetPeopleViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SetPeopleViewController.h"
#import "PeopleViewCell.h"
#define Localized(key) NSLocalizedString(key, @"")
#import "DataModel.h"
#import "FriendsListModel.h"
@interface SetPeopleViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *peopleTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) NSMutableArray *resultData;

@property (nonatomic, strong) NSArray *tableIndexData;

@property (nonatomic, strong) NSMutableArray *resultIndexData;

@property (nonatomic, assign) BOOL searchActive;

@end

@implementation SetPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setCenterTitleView];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.peopleTableView setTableFooterView:view];
    [self.peopleTableView registerNib:[UINib nibWithNibName:@"PeopleViewCell" bundle:nil] forCellReuseIdentifier:@"PeopleViewCell"];
}
- (void)loadData {
    [DZNetworkingTool postWithUrl:kFriendsList
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"][@"friend_list"];

                [self.dataArray removeAllObjects];

                for (NSDictionary *dict in array) {
                    FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                NSArray *tempArray = [self sringSectioncompositor:self.dataArray withSelector:@selector(nickname) isDeleEmptyArray:YES];
                self.tableData = tempArray[0];
                self.tableIndexData = tempArray[1];
                [self.peopleTableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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

    for (DataModel *model in dataArray) {
        //        根据SEL方法返回的字符串判断对象应该处于哪个分区
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

#pragma mark - Scroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
     [searchBar resignFirstResponder];// 放弃第一响应者
    if (searchBar.text.length == 0) {
        self.searchActive = NO;
        [self.peopleTableView reloadData];
        return;
    }
    self.searchActive = NO;
    self.resultData = [NSMutableArray array];
    self.resultIndexData = [NSMutableArray array];
    NSDictionary *dict = @{
                           @"phone":searchBar.text
                           };
    [DZNetworkingTool postWithUrl:kSearchFriend params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            
            [self.dataArray removeAllObjects];
            
            for (NSDictionary *dict in array) {
                FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            NSArray *tempArray = [self sringSectioncompositor:self.dataArray withSelector:@selector(nickname) isDeleEmptyArray:YES];
            self.tableData = tempArray[0];
            self.tableIndexData = tempArray[1];
           
            [self.peopleTableView reloadData];
        }else{
            self.tableData = nil;
            self.tableIndexData = nil;

            [self.peopleTableView reloadData];
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
  
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

- (void)setCenterTitleView {
    UISearchBar *mSearchBar = [[UISearchBar alloc] init];
    [mSearchBar sizeToFit];
    mSearchBar.delegate = self;
    //设置占位字
    mSearchBar.placeholder = @"搜索";

    mSearchBar.frame = CGRectMake(0, 0, ViewWidth - 100, 30);

    self.navigationItem.titleView = mSearchBar;
}

#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.searchActive ? self.resultData.count : self.tableData.count;
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.searchActive ? self.resultIndexData : self.tableIndexData;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchActive ? [self.resultData[section] count] : [self.tableData[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PeopleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleViewCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;

    FriendsListModel *model = self.searchActive ? self.resultData[indexPath.section][indexPath.row] : self.tableData[indexPath.section][indexPath.row];
    cell.nameLabel.text = model.nickname;
    cell.phoneNumberLabel.text = model.mobile;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    cell.addToCartsBlock = ^(PeopleViewCell *cell) {
        NSDictionary *dict = @{
            @"group_id": @(self.group_id),
            @"group_user_ids": @(model.user_id)

        };
        [DZNetworkingTool postWithUrl:kAddGroupUser
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    [self.navigationController popViewControllerAnimated:YES];

                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }

            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            IsNeedHub:NO];

        //
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
