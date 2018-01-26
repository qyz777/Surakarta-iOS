//
//  YZBeginViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZBeginViewController.h"
#import "YZBeginView.h"
#import "YZChessViewController.h"

@interface YZBeginViewController ()<YZBeginViewDelegate>

@end

@implementation YZBeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    YZBeginView *beginView = [[YZBeginView alloc]init];
    beginView.beginViewDelegate = self;
    [self.view addSubview:beginView];
}

- (void)userDidTouchPVPBtn{
    YZChessViewController *vc = [[YZChessViewController alloc]init];
    vc.gameMode = chessGameModePVP;
    [self.navigationController pushViewController:vc animated:true];
}

@end
