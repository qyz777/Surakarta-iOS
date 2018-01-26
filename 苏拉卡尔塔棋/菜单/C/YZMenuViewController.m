//
//  YZMenuViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZMenuViewController.h"
#import "YZMenuView.h"
#import "YZBeginViewController.h"

@interface YZMenuViewController ()<YZMenuViewDelegate>

@end

@implementation YZMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    self.navigationController.navigationBar.hidden = true;
    self.view.backgroundColor = [UIColor whiteColor];
    YZMenuView *menuView = [[YZMenuView alloc]init];
    menuView.menuViewDelegate = self;
    [self.view addSubview:menuView];
}

#pragma make - YZMenuView协议
- (void)userDidTouchBeginBtn{
    YZBeginViewController *vc = [[YZBeginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
