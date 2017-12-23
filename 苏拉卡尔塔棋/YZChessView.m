//
//  YZChessView.m
//  苏腊卡尔塔棋
//
//  Created by 戚译中 on 2017/12/4.
//  Copyright © 2017年 777. All rights reserved.
//

#import "YZChessView.h"

@implementation YZChessView

- (instancetype)init{
    self = [super init];
    [self initView];
    return self;
}

- (void)initView{
    self.backgroundColor = RGB(211, 211, 211);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //建立棋子
    for (int i=0; i<12; i++) {
        if (i<6) {
            UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [redBtn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            redBtn.frame = CGRectMake(0, 0, 25, 25);
            redBtn.center = CGPointMake(CENTERX-75+i*30, CENTERY-75);
            [self addSubview:redBtn];
            
            UIButton *blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [blueBtn setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
            blueBtn.frame = CGRectMake(0, 0, 25, 25);
            blueBtn.center = CGPointMake(CENTERX-75+i*30, CENTERY+75);
            [self addSubview:blueBtn];
        }else{
            UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [redBtn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            redBtn.frame = CGRectMake(0, 0, 25, 25);
            redBtn.center = CGPointMake(CENTERX-75+(i-6)*30, CENTERY-45);
            [self addSubview:redBtn];
            
            UIButton *blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [blueBtn setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
            blueBtn.frame = CGRectMake(0, 0, 25, 25);
            blueBtn.center = CGPointMake(CENTERX-75+(i-6)*30, CENTERY+45);
            [self addSubview:blueBtn];
        }
    }
    
    self.label = [[UILabel alloc]init];
    self.label.userInteractionEnabled = true;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"蓝方先手";
    self.label.font = [UIFont systemFontOfSize:30.0f];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(180, 40));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(80);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel)];
    [self.label addGestureRecognizer:tap];
    
    self.popView = [[UIView alloc]init];
    self.popView.hidden = true;
    self.popView.backgroundColor = [UIColor grayColor];
    self.popView.alpha = 0;
    [self addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 150));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(SCREEN_HEIGHT-150);
    }];
    self.popView.transform = CGAffineTransformConcat(CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 150), CGAffineTransformScale(CGAffineTransformIdentity, 1, 0.5));
    
    self.pickView = [[UIPickerView alloc]init];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self.popView addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
        make.centerX.equalTo(self.popView);
        make.top.equalTo(self.popView).offset(40);
    }];
    
    self.selectPickViewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.selectPickViewBtn setTintColor:[UIColor blackColor]];
    [self.selectPickViewBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.selectPickViewBtn addTarget:self action:@selector(pressSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:self.selectPickViewBtn];
    [self.selectPickViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
        make.centerX.equalTo(self.popView);
        make.top.equalTo(self.popView).offset(0);
    }];
}

- (void)pressSelectBtn{
    [UIView animateWithDuration:0.3 animations:^{
        self.popView.transform = CGAffineTransformConcat(CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 75), CGAffineTransformScale(CGAffineTransformIdentity, 1, 0.5));
        self.popView.alpha = 0;
    }completion:^(BOOL finished) {
        self.popView.hidden = true;
    }];
}

- (void)tapLabel{
    if (self.popView.isHidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.popView.hidden = false;
            self.popView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            self.popView.alpha = 0.7;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.popView.transform = CGAffineTransformConcat(CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 75), CGAffineTransformScale(CGAffineTransformIdentity, 1, 0.5));
            self.popView.alpha = 0;
        }completion:^(BOOL finished) {
            self.popView.hidden = true;
        }];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    switch (row) {
        case 0:
            str = @"红方先手";
            break;
        case 1:
            str = @"蓝方先手";
            break;
        default:
            break;
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (row) {
        case 0:
            self.label.text = @"红方先手";
            break;
        case 1:
            self.label.text = @"蓝方先手";
            break;
        default:
            break;
    }
}

//棋盘一个格子30
- (void)drawRect:(CGRect)rect{
    //绘制棋盘
    UIBezierPath *bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:CGPointMake(CENTERX-75, CENTERY-75)];
    [bezierPath addLineToPoint:CGPointMake(CENTERX+75, CENTERY-75)];
    [bezierPath addLineToPoint:CGPointMake(CENTERX+75, CENTERY+75)];
    [bezierPath addLineToPoint:CGPointMake(CENTERX-75, CENTERY+75)];
    [bezierPath addLineToPoint:CGPointMake(CENTERX-75, CENTERY-75)];
    [UIColor.orangeColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    //横线-1,2,3,4
    UIBezierPath *bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint:CGPointMake(CENTERX-75, CENTERY-45)];
    [bezier2Path addLineToPoint:CGPointMake(CENTERX+75, CENTERY-45)];
    [UIColor.purpleColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
    
    UIBezierPath *bezier3Path = UIBezierPath.bezierPath;
    [bezier3Path moveToPoint:CGPointMake(CENTERX-75, CENTERY-15)];
    [bezier3Path addLineToPoint:CGPointMake(CENTERX+75, CENTERY-15)];
    [RGB(0, 139, 69) setStroke];
    bezier3Path.lineWidth = 1;
    [bezier3Path stroke];
    
    UIBezierPath *bezier4Path = UIBezierPath.bezierPath;
    [bezier4Path moveToPoint:CGPointMake(CENTERX-75, CENTERY+15)];
    [bezier4Path addLineToPoint:CGPointMake(CENTERX+75, CENTERY+15)];
    [RGB(0, 139, 69) setStroke];
    bezier4Path.lineWidth = 1;
    [bezier4Path stroke];
    
    UIBezierPath *bezier5Path = UIBezierPath.bezierPath;
    [bezier5Path moveToPoint:CGPointMake(CENTERX-75, CENTERY+45)];
    [bezier5Path addLineToPoint:CGPointMake(CENTERX+75, CENTERY+45)];
    [UIColor.purpleColor setStroke];
    bezier5Path.lineWidth = 1;
    [bezier5Path stroke];
    
    //竖线-1,2,3,4
    UIBezierPath *bezier6Path = UIBezierPath.bezierPath;
    [bezier6Path moveToPoint:CGPointMake(CENTERX-45, CENTERY-75)];
    [bezier6Path addLineToPoint:CGPointMake(CENTERX-45, CENTERY+75)];
    [UIColor.purpleColor setStroke];
    bezier6Path.lineWidth = 1;
    [bezier6Path stroke];
    
    UIBezierPath *bezier7Path = UIBezierPath.bezierPath;
    [bezier7Path moveToPoint:CGPointMake(CENTERX-15, CENTERY-75)];
    [bezier7Path addLineToPoint:CGPointMake(CENTERX-15, CENTERY+75)];
    [RGB(0, 139, 69) setStroke];
    bezier7Path.lineWidth = 1;
    [bezier7Path stroke];
    
    UIBezierPath *bezier8Path = UIBezierPath.bezierPath;
    [bezier8Path moveToPoint:CGPointMake(CENTERX+15, CENTERY-75)];
    [bezier8Path addLineToPoint:CGPointMake(CENTERX+15, CENTERY+75)];
    [RGB(0, 139, 69) setStroke];
    bezier8Path.lineWidth = 1;
    [bezier8Path stroke];
    
    UIBezierPath *bezier9Path = UIBezierPath.bezierPath;
    [bezier9Path moveToPoint:CGPointMake(CENTERX+45, CENTERY-75)];
    [bezier9Path addLineToPoint:CGPointMake(CENTERX+45, CENTERY+75)];
    [UIColor.purpleColor setStroke];
    bezier9Path.lineWidth = 1;
    [bezier9Path stroke];
    
    //曲线-左上-大
    UIBezierPath *circle1Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:60 startAngle:0 endAngle:M_PI_2 clockwise:false];
    [RGB(0, 139, 69) setStroke];
    circle1Path.lineWidth = 1;
    [circle1Path stroke];
    //曲线-左上-小
    UIBezierPath *circle2Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:30 startAngle:0 endAngle:M_PI_2 clockwise:false];
    [UIColor.purpleColor setStroke];
    circle2Path.lineWidth = 1;
    [circle2Path stroke];
    
    //曲线-右上-大
    UIBezierPath *circle3Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX+75, CENTERY-75) radius:60 startAngle:M_PI endAngle:M_PI_2 clockwise:true];
    [RGB(0, 139, 69) setStroke];
    circle3Path.lineWidth = 1;
    [circle3Path stroke];
    //曲线-右上-小
    UIBezierPath *circle4Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX+75, CENTERY-75) radius:30 startAngle:M_PI endAngle:M_PI_2 clockwise:true];
    [UIColor.purpleColor setStroke];
    circle4Path.lineWidth = 1;
    [circle4Path stroke];
    
    //曲线-左下-大
    UIBezierPath *circle5Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX-75, CENTERY+75) radius:60 startAngle:0 endAngle:M_PI_2*3 clockwise:true];
    [RGB(0, 139, 69) setStroke];
    circle5Path.lineWidth = 1;
    [circle5Path stroke];
    //曲线-左下-小
    UIBezierPath *circle6Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX-75, CENTERY+75) radius:30 startAngle:0 endAngle:M_PI_2*3 clockwise:true];
    [UIColor.purpleColor setStroke];
    circle6Path.lineWidth = 1;
    [circle6Path stroke];
    
    //曲线-右下-大
    UIBezierPath *circle7Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX+75, CENTERY+75) radius:60 startAngle:-M_PI_2 endAngle:M_PI clockwise:true];
    [RGB(0, 139, 69) setStroke];
    circle7Path.lineWidth = 1;
    [circle7Path stroke];
    //曲线-右下-小
    UIBezierPath *circle8Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX+75, CENTERY+75) radius:30 startAngle:-M_PI_2 endAngle:M_PI clockwise:true];
    [UIColor.purpleColor setStroke];
    circle8Path.lineWidth = 1;
    [circle8Path stroke];
}

@end
