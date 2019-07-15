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


@interface SelectSpecView () <UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UILabel*titLab;
    UIView*BGView;
    UIView*BGMiddleView;
    NSString*pinpainame;
    
    
}

@property (nonatomic, strong) NSDictionary *dict;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *specIdArray;
@property (nonatomic, strong) NSArray *PinPaiArray;
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

    [self CreateHeardView];
    [self GuigetableView];
    [self CreateMiddleView];
    [self XunazhongtableView];

    return self;
}

#pragma mark – UI


-(void)CreateHeardView{
    
    self.sureBtn.layer.cornerRadius=15.f;
    BGView=[[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-SafeAreaBottomHeight-50-637*SCREEN_WIDTH/750, SCREEN_WIDTH, SCREEN_WIDTH/750*210)];
    BGView.backgroundColor=[UIColor whiteColor];
    
    titLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/750*100)];
    titLab.font=[UIFont systemFontOfSize:18];
    titLab.textAlignment=NSTextAlignmentCenter;
    [BGView addSubview:titLab];
    
    UILabel*PinPaiLab=[[UILabel alloc]initWithFrame:CGRectMake(15, SCREEN_WIDTH/750*120, SCREEN_WIDTH/750*100, SCREEN_WIDTH/750*50)];
    PinPaiLab.text=@"品牌";
    PinPaiLab.font=[UIFont systemFontOfSize:16];
    [BGView addSubview:PinPaiLab];
    _xuanzefild=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/750*80+SCREEN_WIDTH/750*36, SCREEN_WIDTH/750*120, SCREEN_WIDTH/750*380, SCREEN_WIDTH/750*50)];
    _xuanzefild.placeholder=@"请选择品牌名称";
    _xuanzefild.layer.borderColor= [MTool colorWithHexString:@"#edeff2"].CGColor;
    _xuanzefild.layer.borderWidth= 1.0f;
    _xuanzefild.textAlignment=NSTextAlignmentCenter;
    _xuanzefild.font=[UIFont systemFontOfSize:14];
    
    UIImageView*rightview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/750*32, SCREEN_WIDTH/750*32)];
    _xuanzefild.backgroundColor = [MTool colorWithHexString:@"#f9f9f9"];
    [rightview setImage:[UIImage imageNamed:@"xiasanjiao"]];
    _xuanzefild.rightView=rightview;
    _xuanzefild.rightViewMode = UITextFieldViewModeAlways;
    
    [BGView addSubview:_xuanzefild];
    
    UIButton*PinPaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PinPaiBtn.frame = CGRectMake(0, SCREEN_WIDTH/750*120, SCREEN_WIDTH, SCREEN_WIDTH/750*50);
//    [PinPaiBtn addTarget:self action:@selector(selectPinpai:) forControlEvents:UIControlEventTouchUpInside];
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
    [self addSubview:BGView];
//    self.guigetableView.tableHeaderView=BGView;
    self.guigetableView.frame=CGRectMake(0, BGView.bottom, self.guigetableView.frame.size.width, self.guigetableView.frame.size.height);
    
}
-(void)GuigetableView {
    self.guigetableView=[[UITableView alloc]initWithFrame:CGRectMake(0, BGView.bottom, SCREEN_WIDTH, SCREEN_WIDTH/750*300) style:UITableViewStylePlain];
    self.guigetableView.delegate = self;
    self.guigetableView.dataSource = self;
    
    [self.guigetableView registerNib:[UINib nibWithNibName:@"SpecCollectionViewCell" bundle:nil] forCellReuseIdentifier:@"SpecCollectionViewCell"];
    self.guigetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.guigetableView];
    
    
}
-(void)CreateMiddleView{
    
    BGMiddleView=[[UIView alloc]initWithFrame:CGRectMake(0, self.guigetableView.bottom , SCREEN_WIDTH, SCREEN_WIDTH/750*127)];
    BGMiddleView.backgroundColor=[UIColor whiteColor];
    [self addSubview:BGMiddleView];
    
    UIButton*AddGuiGeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AddGuiGeBtn.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/750*250)/2,(SCREEN_WIDTH/750*127-SCREEN_WIDTH/750*60)/2, SCREEN_WIDTH/750*250, SCREEN_WIDTH/750*60);
    AddGuiGeBtn.backgroundColor=[MTool colorWithHexString:@"2e8cff"];
    [AddGuiGeBtn setTitle:@"添加规格" forState:UIControlStateNormal];
    [AddGuiGeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    AddGuiGeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [AddGuiGeBtn addTarget:self action:@selector(addGuigeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [BGMiddleView addSubview:AddGuiGeBtn];
}


-(void)XunazhongtableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,BGMiddleView.bottom,  SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-BGMiddleView.bottom-50) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor=[UIColor grayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    if (self.isFromGuanlian) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.hideTableViewHeight.constant = 0;
    } else {
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.hideTableViewHeight.constant = 120;
    }
 [self.tableView registerNib:[UINib nibWithNibName:@"SelectSpecTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectSpecTableViewCell"];
    NSLog(@"%@", [NSString stringWithFormat:@"aaaaaaa%f",BGMiddleView.bottom]);
    
}
#pragma mark - <UITableViewDelegate和DataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (tableView == self.guigetableView) {
         GuigeModel *guigeModel = self.dataArray[indexPath.row];
        NSArray *array=guigeModel.data;
        int number=(int)array.count;

        return 50*(1+number/4);
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
            titLab.text=[NSString stringWithFormat:@"%@",_name];

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

//关闭
- (void)closed:(UIButton*)sender {
    [self removeFromSuperview];
    self.deleteBlock();

}

//选择品牌
- (void)selectPinpai:(UIButton*)sender {
    
    UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    _PinPaiArray=_model.brand;
    for (int i=0; i<_PinPaiArray.count; i++) {
        NSDictionary*dic=_PinPaiArray[i];
        pinpainame=dic[@"name"];
        [sheet addButtonWithTitle:[NSString stringWithFormat:@"%@",pinpainame]];

    }
    [sheet showInView:self];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _PinPaiArray=_model.brand;
    for (int i=0; i<_PinPaiArray.count; i++) {
          if (buttonIndex==i+1) {
        NSDictionary*dic=_PinPaiArray[i];
        pinpainame=dic[@"name"];
        _xuanzefild.text=[NSString stringWithFormat:@"%@",pinpainame];
              self.pinpaiBlock(pinpainame);
          }
    }
}
- (IBAction)cancelBtnClick:(id)sender {
    self.deleteBlock();

    [self removeFromSuperview];
}
//添加规格
- (IBAction)addGuigeBtnClick:(id)sender {
    
     BGView.frame=CGRectMake(0, SCREEN_WIDTH/750*500, SCREEN_WIDTH, SCREEN_WIDTH/750*210);
     self.guigetableView.frame=CGRectMake(0, BGView.bottom, SCREEN_WIDTH, SCREEN_WIDTH/750*300);
      BGMiddleView.frame=CGRectMake(0, self.guigetableView.bottom , SCREEN_WIDTH, SCREEN_WIDTH/750*127);

     self.tableView.frame=CGRectMake(0,BGMiddleView.bottom,  SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-BGMiddleView.bottom-50);
    if (self.tempArray.count == 0) {
        [DZTools showNOHud:@"暂无规格" delay:2];
        return;
    }

    NSLog(@"%@", self.tempArray);
    if (self.selectDataArray.count == 0) {
        NSString *nameStr = @"";
        NSString *idStr = @"";

        for (SpecGuigeModel *model in self.tempArray) {
            nameStr = [nameStr stringByAppendingFormat:@"%@  ", model.name];
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
//addBtn
- (IBAction)addBtnCLicked1111:(id)sender {
//    self.tianjiaBlock();
//    [self removeFromSuperview];
    BGView.hidden=YES;
    self.guigetableView.hidden=YES;
    BGMiddleView.hidden=YES;
    if(!_AddGuiGeView){
        _AddGuiGeView=[[AddGuiGe alloc]init];

    }
    _AddGuiGeView.frame=CGRectMake(0, SCREEN_HEIGHT-SafeAreaBottomHeight-50-428*SCREEN_WIDTH/750, SCREEN_WIDTH, 428*SCREEN_WIDTH/750);
    _AddGuiGeView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_AddGuiGeView];
    [_AddGuiGeView.tableView reloadData];
    [_AddGuiGeView.ClosedBtn addTarget:self action:@selector(closed:) forControlEvents:UIControlEventTouchUpInside];
    
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
-(void)setModel:(StuffListModel *)model{
    _model=model;
}
@end
