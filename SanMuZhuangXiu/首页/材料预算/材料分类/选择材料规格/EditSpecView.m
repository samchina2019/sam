//
//  EditSpecView.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "EditSpecView.h"
#import "SpecCollectionViewCell.h"
#import "SelectSpecTableViewCell.h"

#import "GuigeModel.h"
#import "SpecGuigeModel.h"
@interface EditSpecView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *specIdArray;

@property (nonatomic, assign) BOOL isSelect;
@end
@implementation EditSpecView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"EditSpecView" owner:self options:nil][0];
        self.frame = frame;
    }
    self.dataArray = [NSMutableArray array];
    self.selectDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.specIdArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initTableView];
    
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tempArray removeAllObjects];
    if (_dataArray.count != 0) {
        for (GuigeModel *guigeModel in dataArray) {
            NSArray *array = guigeModel.data;
            SpecGuigeModel *model = [SpecGuigeModel mj_objectWithKeyValues:array[0]];
            //            [self.selectArray addObject:model];
            [self.tempArray addObject:model];
        }
        
    }
    [self.guigeView reloadData];
    //    [self.tableView reloadData];
}
- (NSMutableArray *)tempArray {
    if (!_tempArray) {
        _tempArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tempArray;
}

- (void)initTableView {
    self.guigeView.delegate = self;
    self.guigeView.dataSource = self;
    
    [self.guigeView registerNib:[UINib nibWithNibName:@"SpecCollectionViewCell" bundle:nil] forCellReuseIdentifier:@"SpecCollectionViewCell"];
    self.guigeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   
   
}
#pragma mark - <UITableViewDelegate和DataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
        return self.dataArray.count;
        
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
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

}

#pragma mark -- XibFunction

- (IBAction)cancelBtnCLick:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)sureAddBtnClick:(id)sender {
    if (self.tempArray.count==0) {
        [DZTools showNOHud:@"暂无规格" delay:2];
        return;
    }
    
    
    NSLog(@"%@", self.tempArray);
    if (self.selectDataArray.count == 0) {
        NSString *nameStr = @"";
        for (SpecGuigeModel *model in self.tempArray) {
            nameStr = [nameStr stringByAppendingFormat:@"%@ ", model.name];
        }
        NSDictionary *dict = @{
                               @"name": nameStr,
                               @"array": [self.tempArray mutableCopy],
                               @"number": @(1)
                               };
        [self.selectDataArray addObject:dict];
    } else {
        NSString *temoStr=@"";
        for (SpecGuigeModel *model in self.tempArray) {
            temoStr = [temoStr stringByAppendingFormat:@"%ld ", (long)model.stuff_spec_id];
        }
        
        BOOL isChong = NO;
        for (NSDictionary *temp in self.selectDataArray) {
            NSArray *array = temp[@"array"];
            NSString *selectStr=@"";
            for (SpecGuigeModel *model in array) {
                selectStr = [selectStr stringByAppendingFormat:@"%ld ", (long)model.stuff_spec_id];
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
//                nameStr = [nameStr stringByAppendingFormat:@"%@ ", model.name];
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
  self.sureBlock([self.selectDataArray copy]);
    self.deleteBlock();
    
  [self removeFromSuperview];
//  [self.tempArray removeAllObjects];
//  [self.selectDataArray removeAllObjects];
    
}

@end
