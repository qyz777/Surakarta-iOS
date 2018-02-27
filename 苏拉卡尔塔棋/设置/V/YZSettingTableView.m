//
//  YZSettingTableView.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZSettingTableView.h"

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
    
    self.tableFooterView = [UIView new];
}

#pragma make - tableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        default:
            break;
    }
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
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
        default:
            break;
    }
}

@end
