//
//  YZSettingTableView.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZSettingTableView.h"

@interface YZSettingTableView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(strong,nonatomic)UIView *bottomView;
@property(strong,nonatomic)UIPickerView *pickView;
@property(strong,nonatomic)UILabel *label;
@property(nonatomic)BOOL isPicked;

@end

@implementation YZSettingTableView

- (instancetype)init{
    self = [super init];
    [self initView];
    return self;
}

- (void)initView{
    self.frame = CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT - 80);
    self.backgroundColor = RGB(245, 245, 245);
    self.dataSource = self;
    self.delegate = self;
    self.userInteractionEnabled = true;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableFooterView = [UIView new];
    
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200)];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self.bottomView addSubview:self.pickView];
    self.isPicked = false;
    
    UIButton *pickBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.bottomView addSubview:pickBtn];
    [pickBtn setTitle:@"完成" forState:UIControlStateNormal];
    pickBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [pickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView).offset(0);
    }];
    [pickBtn addTarget:self action:@selector(pressPickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressPickBtn{
    [UIView animateWithDuration:0.2f animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
    }];
}

#pragma make - pickViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

#pragma make - pickViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (row) {
        case 0:
            return @"无";
        case 1:
            return @"特效1";
        case 2:
            return @"特效2";
        case 3:
            return @"特效3";
        default:
            break;
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (row) {
        case 0:
            self.label.text = @"无";
            [self.settingDelegate specialDidChangeWithType:@"无"];
            break;
        case 1:
            self.label.text = @"特效1";
            [self.settingDelegate specialDidChangeWithType:@"特效1"];
            break;
        case 2:
            self.label.text = @"特效2";
            [self.settingDelegate specialDidChangeWithType:@"特效2"];
            break;
        case 3:
            self.label.text = @"特效3";
            [self.settingDelegate specialDidChangeWithType:@"特效3"];
            break;
        default:
            break;
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.userInteractionEnabled = true;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section != 3 && indexPath.section != 5) {
        UISwitch *settingSwitch = [[UISwitch alloc]init];
        settingSwitch.on = [self.settingDelegate switchStateWithSection:indexPath.section];
        settingSwitch.tag = indexPath.section;
        [settingSwitch addTarget:self action:@selector(settingSwitchChange:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:settingSwitch];
        [settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-25);
        }];
    }else if (indexPath.section == 5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        self.label = [[UILabel alloc]init];
        self.label.text = _labelType;
        self.label.textColor = RGB(190, 190, 190);
        self.label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-25);
        }];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"走子声音";
            break;
        case 1:
            cell.textLabel.text = @"吃子声音";
            break;
        case 2:
            cell.textLabel.text = @"振动";
            break;
        case 3:
            cell.textLabel.text = @"特效";
            break;
        case 4:
            cell.textLabel.text = @"AI红方";
            break;
        case 5:
            cell.textLabel.text = @"关于我";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma make - tableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 14)];
    return view;
}

- (void)settingSwitchChange:(UISwitch*)settingSwitch{
    switch (settingSwitch.tag) {
        case 0:
            [self.settingDelegate goSourceDidSwitch];
            break;
        case 1:
            [self.settingDelegate eatSourceDidSwitch];
            break;
        case 2:
            [self.settingDelegate vibrationDidSwitch];
            break;
        case 4:
            [self.settingDelegate AIDidSwitch];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 3) {
        if (self.isPicked == true) {
            self.isPicked = false;
            [UIView animateWithDuration:0.2f animations:^{
                self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
            }];
        }else {
            self.isPicked = true;
            [UIView animateWithDuration:0.2f animations:^{
                self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 240);
            }];
        }

    }
    if (indexPath.section == 5) {
        if ([self.settingDelegate respondsToSelector:@selector(aboutMeDidClicked)]) {
            [self.settingDelegate aboutMeDidClicked];
        }
    }
}

@end
