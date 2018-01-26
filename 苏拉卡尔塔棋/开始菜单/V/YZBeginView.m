//
//  YZBeginView.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZBeginView.h"

@implementation YZBeginView

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
    
    self.pvpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.pvpBtn setTitle:@"PVP" forState:UIControlStateNormal];
    self.pvpBtn.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.pvpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.pvpBtn];
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
    [self.pveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self.pvpBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];
    [self.pveBtn addTarget:self action:@selector(pressPveBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressPvpBtn{
    [self.beginViewDelegate userDidTouchPVPBtn];
}

- (void)pressPveBtn{
    
}

@end
