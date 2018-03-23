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
        make.top.equalTo(self).offset(240);
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
        make.top.equalTo(self.beginBtn.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    [self.settingBtn addTarget:self action:@selector(pressSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.pvpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.pvpBtn setTitle:@"PVP" forState:UIControlStateNormal];
    self.pvpBtn.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.pvpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.pvpBtn];
    self.pvpBtn.hidden = true;
    [self.pvpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self).offset(200);
        make.centerX.equalTo(self);
    }];
    [self.pvpBtn addTarget:self action:@selector(pressPvpBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.pveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.pveBtn setTitle:@"PVE" forState:UIControlStateNormal];
    self.pveBtn.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.pveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.pveBtn];
    self.pveBtn.hidden = true;
    [self.pveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self.pvpBtn.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    [self.pveBtn addTarget:self action:@selector(pressPveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.backBtn];
    self.backBtn.hidden = true;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self.pveBtn.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    [self.backBtn addTarget:self action:@selector(pressBackBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressBeginBtn{
    [UIView animateWithDuration:0.5f animations:^{
        self.beginBtn.hidden = true;
        self.settingBtn.hidden = true;
        self.pvpBtn.hidden = false;
        self.pveBtn.hidden = false;
        self.backBtn.hidden = false;
    }];
}

- (void)pressSettingBtn{
    [self.menuViewDelegate userDidTouchSettingBtn];
}

- (void)pressPvpBtn{
    [self.menuViewDelegate userDidTouchPVPBtn];
}

- (void)pressPveBtn{
    [self.menuViewDelegate userDidTouchPVEBtn];
}

- (void)pressBackBtn{
    [UIView animateWithDuration:0.5f animations:^{
        self.beginBtn.hidden = false;
        self.settingBtn.hidden = false;
        self.pvpBtn.hidden = true;
        self.pveBtn.hidden = true;
        self.backBtn.hidden = true;
    }];
}

@end
