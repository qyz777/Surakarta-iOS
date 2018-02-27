//
//  YZMenuViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZMenuViewController.h"
#import "YZMenuView.h"
#import "YZChessViewController.h"
#import "YZSettingViewController.h"

@interface YZMenuViewController ()<YZMenuViewDelegate>

@end

@implementation YZMenuViewController{
    YZMenuView *menuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    menuView.beginBtn.hidden = false;
    menuView.settingBtn.hidden = false;
    menuView.pvpBtn.hidden = true;
    menuView.pveBtn.hidden = true;
}

- (void)initView{
    self.navigationController.navigationBar.hidden = true;
    self.view.backgroundColor = [UIColor whiteColor];
    YZMenuView *menuView = [[YZMenuView alloc]init];
    menuView.menuViewDelegate = self;
    [self.view addSubview:menuView];
}

#pragma make - YZMenuView协议
- (void)userDidTouchPVPBtn{
    YZChessViewController *vc = [[YZChessViewController alloc]init];
    [self presentViewController:vc animated:true completion:^{
        
    }];
}

- (void)userDidTouchPVEBtn{
    
}

- (void)userDidTouchSettingBtn{
    YZSettingViewController *vc = [[YZSettingViewController alloc]init];
    [self presentViewController:vc animated:true completion:^{
        
    }];
}

@end
