//
//  YZSettingViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZSettingViewController.h"
#import "YZSettingTableView.h"
#import "YZSettings.h"

@interface YZSettingViewController ()<YZSettingTableViewDelegate>{
    YZSettingTableView *settingTableView;
}

@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation YZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    [YZSettings firstSetting];
    
    settingTableView = [[YZSettingTableView alloc]init];
    settingTableView.settingDelegate = self;
    [self.view addSubview:settingTableView];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = @"设置";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30, 30));
        make.top.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [self.closeBtn addTarget:self action:@selector(pressCloseBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressCloseBtn{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

#pragma make -协议
- (void)goSourceDidSwitch{
    [YZSettings changeSettingWithKey:@"goChessSource"];
}

- (void)eatSourceDidSwitch{
    [YZSettings changeSettingWithKey:@"eatChessSource"];
}

- (void)vibrationDidSwitch{
    [YZSettings changeSettingWithKey:@"vibrate"];
}

- (BOOL)switchStateWithSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [YZSettings isOnWithKey:@"goChessSource"];
        case 1:
            return [YZSettings isOnWithKey:@"eatChessSource"];
        case 2:
            return [YZSettings isOnWithKey:@"vibrate"];
        default:
            break;
    }
    return true;
}

@end
