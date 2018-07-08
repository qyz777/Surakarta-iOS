//
//  YZAboutMeViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/7/8.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZAboutMeViewController.h"

@interface YZAboutMeViewController ()

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation YZAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    UILabel *github = [UILabel new];
    self.view.backgroundColor = [UIColor whiteColor];
    github.text = @"github:https://github.com/qyz777";
    [self.view addSubview:github];
    [github mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(100);
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"作者:qyizhong";
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(github.mas_bottom).offset(20);
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

@end
