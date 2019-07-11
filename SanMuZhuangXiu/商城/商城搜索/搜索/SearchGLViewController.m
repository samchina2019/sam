//
//  SearchViewController.m
//  MegaMart
//
//  Created by benben on 2019/5/15.
//  Copyright © 2019 benben. All rights reserved.
//

#import "SearchGLViewController.h"
#import "MallSearchViewController.h"
#import "FileTool.h"
#import "InputView.h"
@interface SearchGLViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    InputView *_inputView;
    
    CGFloat _lastButtonX; //最后一个按钮的x
    CGFloat _lastButtonY;//最后一个按钮的y
    CGFloat _hotButtonH;//热搜的高度
}
@property (nonatomic, strong) NSMutableArray *searchHistoryArr;
@property (nonatomic, strong) NSMutableArray *hotSearchArr;
@property (nonatomic, strong) NSMutableArray *searchHistoryAllArr;
@property (nonatomic, strong) NSMutableArray *buttonArr; 

@property (nonatomic, strong) UIScrollView *buttonScrollView;
@property (nonatomic, strong) UITableView *lishiTableView;

@end

@implementation SearchGLViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadRemenData];

    [self loadLisiData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    self.searchHistoryArr = [NSMutableArray array];
    self.hotSearchArr = [NSMutableArray arrayWithObjects:@"补水面膜", @"高档护肤", @"曲奇饼干", @"高档护肤", nil];
    self.buttonArr = [NSMutableArray array];
    self.searchHistoryAllArr = [NSMutableArray array];
    
    [self setUpNavView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.buttonScrollView];

//    [self setUpHotButton];
}
#pragma mark-- nav
- (void)setUpNavView {
    
    InputView *input = [[InputView alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 120, 30) isEidt:YES];
    [input setSearchKeyword:^(NSString *_Nonnull keyword) {
        [self saveSearchKeyword];
    }];
    _inputView = input;
    [self.navigationItem setTitleView:input];
    
    UIButton *noticeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [noticeBtn setTitle:@"搜索" forState:(UIControlStateNormal)];
    
    [noticeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noticeBtn.titleLabel setFont:[UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)]];
    [noticeBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [noticeBtn addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:noticeBtn];
}
#pragma mark – UI
- (void)setUpHotButton {

    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH - 24, 20)];
    [hotLabel setText:@"热门搜索"];
    [hotLabel setFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)]];
    [hotLabel setTextColor:TEXTCOLOR];
    [self.buttonScrollView addSubview:hotLabel];

    _lastButtonX = 12.0f;
    _lastButtonY = 40.0f;
    for (NSInteger i = 0; i < self.hotSearchArr.count; i++) {
        [self addButton:self.hotSearchArr[i]];
    }

    _lastButtonY += 40;

    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _lastButtonY + 10, SCREEN_WIDTH - 24, 20)];
    [historyLabel setText:@"历史搜索"];
    [historyLabel setFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)]];
    [historyLabel setTextColor:TEXTCOLOR];
    [self.buttonScrollView addSubview:historyLabel];

    UIButton *delete = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [delete setImage:[UIImage imageNamed:@"shanchu-hui"] forState:(UIControlStateNormal)];
    [delete setFrame:CGRectMake(SCREEN_WIDTH - 45, _lastButtonY , 40, 40)];
    [delete addTarget:self action:@selector(deleteHistory) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonScrollView addSubview:delete];

    _lastButtonY += 30;
    _lastButtonX = 12.0f;
    _hotButtonH = _lastButtonY;

    self.lishiTableView = [[UITableView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(historyLabel.frame) + 10, SCREEN_WIDTH - 24, self.buttonScrollView.bounds.size.height - CGRectGetMaxY(historyLabel.frame))];
    [self.buttonScrollView addSubview:self.lishiTableView];
    
    self.lishiTableView.tableFooterView = [[UIView alloc]init];

    self.lishiTableView.delegate = self;
    self.lishiTableView.dataSource = self;

//    [self getHistorySearchData];
    
    [self loadLisiData];
}

#pragma mark – Network
/// 获取历史数据
-(void)loadLisiData{

    [DZNetworkingTool postWithUrl: kMySearchHistory params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"][@"list"];
            [self.searchHistoryAllArr removeAllObjects];
            [self.searchHistoryArr removeAllObjects];
            for (NSDictionary *dict in array) {
                [self.searchHistoryAllArr addObject:dict];
                [self.searchHistoryArr addObject:dict[@"word"]];
            }
            [self.lishiTableView reloadData];
            
            [self.buttonScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.searchHistoryArr.count * 44 + self->_lastButtonX+20)];
            
        }else{
            [DZTools  showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools  showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
/// 获取热门数据
-(void)loadRemenData{
    NSDictionary *dict = @{
                           
                           };
    [DZNetworkingTool postWithUrl:kHotWord params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            
            [self.hotSearchArr removeAllObjects];
            
            for (NSDictionary *dict in array) {
                
                [self.hotSearchArr addObject:dict[@"word"]];
            }
            
            [self setUpHotButton];
            
            [self.buttonScrollView layoutIfNeeded];
            
        }else{
            [DZTools  showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools  showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchHistoryArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.text = self.searchHistoryArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    self.hidesBottomBarWhenPushed = YES;
    MallSearchViewController *vc = [[MallSearchViewController alloc]init];
    vc.wordStr = self.searchHistoryArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}

#pragma mark - Function

- (void)setUpHistoryButton {

    for (NSInteger i = 0; i < self.searchHistoryArr.count; i++) {
        [self addButton:self.searchHistoryArr[i]];
    }
}

- (void)addButton:(NSString *)key {

    CGFloat W = 0;
    CGFloat H = 28;

    CGRect rext = [key boundingRectWithSize:CGSizeMake(100000, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:13] } context:nil];

    W = rext.size.width + 20;

    if (_lastButtonX + W > SCREEN_WIDTH - 24) {
        _lastButtonX = 12.0f;
        _lastButtonY += H + 10;
    }
    if (W > SCREEN_WIDTH - 24) {
        W = SCREEN_WIDTH - 24;
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_lastButtonX, _lastButtonY, W, H)];

    [btn setTitle:key forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 

    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn.layer setCornerRadius:3];
    [btn addTarget:self action:@selector(btnDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonScrollView addSubview:btn];
    NSLog(@"%@", NSStringFromCGRect(btn.frame));

    _lastButtonX += W + 15;

    [self.buttonArr addObject:btn];
}

- (void)btnDidPress:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    MallSearchViewController *vc = [[MallSearchViewController alloc]init];
    vc.wordStr = sender.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
     self.hidesBottomBarWhenPushed = YES;
//    NSLog(@"%@", sender.titleLabel.text);
    
    
}



#pragma mark-- data

- (UIScrollView *)buttonScrollView {
    if (!_buttonScrollView) {
        _buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_buttonScrollView setDelegate:self];
    }
    return _buttonScrollView;
}

- (void)rightButtonTouchUpInside:(id)sender {
    [self saveSearchKeyword];
}

- (void)saveSearchKeyword {
    NSString *key = [_inputView getKeyword];

    [_inputView endEditing:YES];
    [self.view endEditing:YES];
    if (key.length == 0) {
        [DZTools showNOHud:@"请输入内容后再搜索" delay:2];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MallSearchViewController *vc = [[MallSearchViewController alloc]init];
    vc.wordStr = key;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
//    if (![self.searchHistoryArr containsObject:key]) {
//        [self.searchHistoryArr addObject:key];
//
//        [FileTool writeSearchHistory:key];
    
        [self.lishiTableView reloadData];
//    }
    [_inputView.inputView setText:@""];
}

- (void)getHistorySearchData {
    
    self.searchHistoryArr = [NSMutableArray arrayWithArray:[FileTool readSearchHistory]];
    [self.lishiTableView reloadData];
    
    [self.buttonScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.searchHistoryArr.count * 44 + _lastButtonX+20)];

}
//删除历史记录
- (void)deleteHistory {
    
    [FileTool deleteSearchHistory];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in self.searchHistoryAllArr) {
        [temp addObject:dict[@"id"]];
    }
    
    NSString *ids = [temp componentsJoinedByString:@","];
    NSDictionary *dict = @{
                         @"ids" : ids
                          };
    [DZNetworkingTool postWithUrl:kDelGoodsVisitHistory params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            
            [self.searchHistoryAllArr removeAllObjects];
            [self.searchHistoryArr removeAllObjects];
            [self.lishiTableView reloadData];
         
        }else{
             [DZTools   showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools   showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
    

    
    /// 不用
//    for (NSInteger i = self.hotSearchArr.count; i < self.buttonArr.count; i++) {
//        UIButton *btn = self.buttonArr[i];
//        [btn removeFromSuperview];
//    }
    
    _lastButtonX = 12.0f;
    _lastButtonY = _hotButtonH;
}
@end
