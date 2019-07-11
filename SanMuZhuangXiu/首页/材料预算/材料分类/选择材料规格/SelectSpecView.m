//
//  SelectSpecView.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SelectSpecView.h"

#import "SpecCollectionViewCell.h"
#import "SelectSpecTableViewCell.h"

#import "GuigeModel.h"
#import "SpecGuigeModel.h"


@interface SelectSpecView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dict;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *specIdArray;
@end
@implementation SelectSpecView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SelectSpecView" owner:self options:nil][0];
        self.frame = frame;
    }
    self.dataArray = [NSMutableArray array];

    self.specIdArray = [NSMutableArray arrayWithCapacity:0];

    [self initTableView];

    return self;
}

#pragma mark – UI

- (void)initTableView {
    self.sureBtn.layer.cornerRadius=15.f;
    self.guigetableView.delegate = self;
    self.guigetableView.dataSource = self;

    [self.guigetableView registerNib:[UINib nibWithNibName:@"SpecCollectionViewCell" bundle:nil] forCellReuseIdentifier:@"SpecCollectionViewCell"];
    self.guigetableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.isFromGuanlian) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.hideTableViewHeight.constant = 0;
    } else {
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.hideTableViewHeight.constant = 120;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectSpecTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectSpecTableViewCell"];
    
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/750*210)];
    BGView.backgroundColor=[UIColor whiteColor];
    
    UILabel*titLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/750*100)];
    titLab.text=@"水泥";
    titLab.font=[UIFont systemFontOfSize:18];
    titLab.textAlignment=NSTextAlignmentCenter;
    [BGView addSubview:titLab];
    
    UILabel*PinPaiLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/750*30, SCREEN_WIDTH/750*120, SCREEN_WIDTH/750*100, SCREEN_WIDTH/750*50)];
    PinPaiLab.text=@"品牌";
    PinPaiLab.font=[UIFont systemFontOfSize:16];
    [BGView addSubview:PinPaiLab];
    _xuanzefild=[[UITextField alloc]initWithFrame:CGRectMake(PinPaiLab.right+SCREEN_WIDTH/750*36, SCREEN_WIDTH/750*120, SCREEN_WIDTH/750*380, SCREEN_WIDTH/750*50)];
    _xuanzefild.placeholder=@"请选择品牌名称";
    _xuanzefild.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
    _xuanzefild.layer.borderWidth= 1.0f;
    _xuanzefild.font=[UIFont systemFontOfSize:14];

    UIImageView*rightview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/750*32, SCREEN_WIDTH/750*32)];
    _xuanzefild.backgroundColor = [MTool colorWithHexString:@"#f9f9f9"];
    [rightview setImage:[UIImage imageNamed:@"xiasanjiao"]];
    _xuanzefild.rightView=rightview;
    _xuanzefild.rightViewMode = UITextFieldViewModeAlways;

    [BGView addSubview:_xuanzefild];
    
    UIButton*PinPaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PinPaiBtn.frame = CGRectMake(0, SCREEN_WIDTH/750*120, SCREEN_WIDTH, SCREEN_WIDTH/750*50);
    [PinPaiBtn addTarget:self action:@selector(selectPinpai:) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:PinPaiBtn];
    
    UIButton*ClosedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ClosedBtn.frame = CGRectMake( SCREEN_WIDTH-SCREEN_WIDTH/750*24-SCREEN_WIDTH/750*44, SCREEN_WIDTH/750*28, SCREEN_WIDTH/750*44, SCREEN_WIDTH/750*44);
    [ClosedBtn setImage:[UIImage imageNamed:@"clfl_ico_lose"] forState:UIControlStateNormal];
    [ClosedBtn addTarget:self action:@selector(closed:) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:ClosedBtn];

    //分割线 clfl_ico_lose
    UIView*lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 209*SCREEN_WIDTH/750 , SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [MTool colorWithHexString:@"#edeff2"];
    [BGView addSubview:lineView];
    self.guigetableView.tableHeaderView=BGView;
}

#pragma mark - <UITableViewDelegate和DataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (tableView == self.guigetableView) {

        return 50;
    } else {
        return 40;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.guigetableView) {
        return self.dataArray.count;

    } else {
        return self.selectDataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.guigetableView) {

        SpecCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecCollectionViewCell"];
        if (self.dataArray.count != 0) {

            GuigeModel *guigeModel = self.dataArray[indexPath.row];

            cell.nameLabel.text = guigeModel.spec_name;
            NSMutableArray *temp = [NSMutableArray array];

            NSArray *array = guigeModel.data;
            for (NSDictionary *dict in array) {
                SpecGuigeModel *model = [SpecGuigeModel mj_objectWithKeyValues:dict];
                [temp addObject:model];
            }
            cell.dataArray = [temp mutableCopy];

            if (guigeModel.data.count == 0) {
                cell.collectionHeight.constant = 50;

            } else {

                cell.collectionHeight.constant = ceil(((guigeModel.data.count - 1) / 4 + 1) * 30 + 5 * floorf((guigeModel.data.count - 1) / 4));
            }
            [cell.collectionView reloadData];
        }

        cell.cellBlock = ^(SpecGuigeModel *model) {
            [self.tempArray replaceObjectAtIndex:indexPath.row withObject:model];

        };

        return cell;
    } else {
        SelectSpecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectSpecTableViewCell"];

        if (self.selectDataArray.count != 0) {
            NSDictionary *dict = self.selectDataArray[indexPath.row];

            cell.nameLabel.text = [NSString stringWithFormat:@"%@:%@", self.name,dict[@"name"]];
            cell.numberBtn.currentNumber = [dict[@"number"] intValue];
        }

        cell.deleteBlock = ^{
            [self.selectDataArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        };
        __weak typeof(SelectSpecTableViewCell *) weakself = cell;
        cell.numBlock = ^(NSInteger num) {
            weakself.numberBtn.currentNumber = num;

            if (num == 0) {
                NSDictionary *dict = @{
                    @"title": @"spce"
                };
                [self.selectDataArray removeObjectAtIndex:indexPath.row];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"xuanzeSpec" object:nil userInfo:dict];
            } else {
//                数量的变化
                NSDictionary *temp = self.selectDataArray[indexPath.row];
                NSString *name = temp[@"name"];
                NSArray *array = temp[@"array"];

                NSDictionary *dict = @{
                    @"name": name,
                    @"array": array,
                    @"stuff_spec_id":temp[@"stuff_spec_id"],
                    @"number": @(num)
                    
                };
                [self.selectDataArray replaceObjectAtIndex:indexPath.row withObject:dict];
            }

            [self.tableView reloadData];

        };
        return cell;
    }
}

#pragma mark - XibFunction
- (IBAction)cancelBtnClick:(id)sender {
    [self removeFromSuperview];
}
//添加规格
- (IBAction)addGuigeBtnClick:(id)sender {
    
    if (self.tempArray.count == 0) {
        [DZTools showNOHud:@"暂无规格" delay:2];
        return;
    }

    NSLog(@"%@", self.tempArray);
    if (self.selectDataArray.count == 0) {
        NSString *nameStr = @"";
        NSString *idStr = @"";

        for (SpecGuigeModel *model in self.tempArray) {
            nameStr = [nameStr stringByAppendingFormat:@"%@ ", model.name];
            idStr = [idStr stringByAppendingFormat:@"%ld", (long)model.stuff_spec_id];
        }
        NSDictionary *dict = @{
            @"name": nameStr,
            @"array": [self.tempArray mutableCopy],
            @"number": @(1)

        };
        [self.selectDataArray addObject:dict];
        
    } else {
        
        NSString *temoStr = @"";
        for (SpecGuigeModel *model in self.tempArray) {
            temoStr = [temoStr stringByAppendingFormat:@"%ld ", (long) model.stuff_spec_id];
        }

        BOOL isChong = NO;
        for (NSDictionary *temp in self.selectDataArray) {
            NSArray *array = temp[@"array"];
            NSString *selectStr = @"";
            for (SpecGuigeModel *model in array) {
                selectStr = [selectStr stringByAppendingFormat:@"%ld ", (long) model.stuff_spec_id];
            }
            if ([selectStr isEqualToString:temoStr]) {
                isChong = YES;
                return;
            }
        }
        if (!isChong) {
            NSString *nameStr = @"";
            NSMutableArray *array = [NSMutableArray array];
            for (SpecGuigeModel *model in self.tempArray) {
                [array addObject:model.name];
            }
            nameStr = [array componentsJoinedByString:@""];
            NSDictionary *dict = @{
                @"name": nameStr,
                @"array": [self.tempArray mutableCopy],
                @"number": @(1)
            };
            [self.selectDataArray addObject:dict];
        }
    }

    [self.tableView reloadData];
}
//确认添加
- (IBAction)sureBtnClick:(id)sender {
    if (self.selectDataArray.count == 0) {
        [DZTools showNOHud:@"暂无选择规格" delay:2];
        return;
    }
    self.sureBlock(self.selectDataArray);
    self.deleteBlock();

    [self removeFromSuperview];
}
//关闭
- (void)closed:(UIButton*)sender {
    [self removeFromSuperview];
}
//选择品牌
- (void)selectPinpai:(UIButton*)sender {
    self.addpinpaiBlock();
}

#pragma mark – 懒加载
- (NSMutableArray *)selectDataArray {
    if (!_selectDataArray) {
        _selectDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectDataArray;
}

- (NSMutableArray *)tempArray {
    if (!_tempArray) {
        _tempArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tempArray;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArray;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;

    [self.tempArray removeAllObjects];
    if (_dataArray.count != 0) {
        for (GuigeModel *guigeModel in dataArray) {
            NSArray *array = guigeModel.data;
            SpecGuigeModel *model = [SpecGuigeModel mj_objectWithKeyValues:array[0]];
            [self.tempArray addObject:model];
        }
    }
    [self.guigetableView reloadData];
}
@end
