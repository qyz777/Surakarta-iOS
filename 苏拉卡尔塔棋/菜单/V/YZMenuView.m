//
//  YZMenuView.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZMenuView.h"

@implementation YZMenuView

- (instancetype)init{
    self = [super init];
    [self initView];
    return self;
}

- (void)initView{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImage *image = [UIImage imageNamed:@"菜单"];
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    backgroundLayer.contents = (__bridge id _Nullable)(image.CGImage);
    [self.layer addSublayer:backgroundLayer];
    
    self.beginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.beginBtn setTitle:@"开始" forState:UIControlStateNormal];
    self.beginBtn.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.beginBtn];
    [self.beginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self).offset(200);
        make.centerX.equalTo(self);
    }];
    [self.beginBtn addTarget:self action:@selector(pressBeginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.settingBtn.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.settingBtn];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self.beginBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];
    [self.settingBtn addTarget:self action:@selector(pressSettingBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressBeginBtn{
    [self.menuViewDelegate userDidTouchBeginBtn];
}

- (void)pressSettingBtn{
    
}

@end
