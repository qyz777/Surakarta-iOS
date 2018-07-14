//
//  YZChessView.m
//  苏腊卡尔塔棋
//
//  Created by 戚译中 on 2017/12/4.
//  Copyright © 2017年 777. All rights reserved.
//

#import "YZChessView.h"
#import "YZChessPlace.h"
#import "YZFlyAnimation.h"
#import "YZEmitter.h"
#import <objc/runtime.h>

@interface YZChessView()<CAAnimationDelegate>{
    NSArray *flyArray;
    NSArray *shortFlyArray;
}

@property(strong,nonatomic)CAEmitterLayer *emLayer;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) NSInteger blueTime;
@property (nonatomic, assign) NSInteger redTime;

@end

@implementation YZChessView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
        [self initChess];
        self.isAIType = false;
        self.blueTime = 0;
        self.redTime = 0;
        [self.closeBtn addTarget:self action:@selector(pressCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.backBtn addTarget:self action:@selector(pressBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = RGB(245, 245, 245);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.backBtn];
    [self addSubview:self.redTimeLabel];
    [self addSubview:self.blueTimeLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(180, 40));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(80);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(250, 40));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-150);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30, 30));
        make.top.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30, 30));
        make.top.equalTo(self).offset(30);
        make.left.equalTo(self).offset(30);
    }];
    
    [self.redTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.bottom.equalTo(self).offset(-80);
    }];
    
    [self.blueTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-50);
        make.bottom.equalTo(self).offset(-80);
    }];
}

- (void)initChess {
//    新建棋盘
    for (int i=0; i<12; i++) {
        if (i<6) {
            UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [redBtn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            redBtn.frame = CGRectMake(0, 0, 25, 25);
            redBtn.center = CGPointMake(CENTERX-75+i*30, CENTERY-75);
            redBtn.tag = i + 1;
            redBtn.userInteractionEnabled = false;
            [redBtn addTarget:self action:@selector(pressChessBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:redBtn];
            
            UIButton *blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [blueBtn setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
            blueBtn.frame = CGRectMake(0, 0, 25, 25);
            blueBtn.center = CGPointMake(CENTERX-75+i*30, CENTERY+75);
            blueBtn.tag = i + 19;
            blueBtn.userInteractionEnabled = false;
            [blueBtn addTarget:self action:@selector(pressChessBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:blueBtn];
        }else{
            UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [redBtn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            redBtn.frame = CGRectMake(0, 0, 25, 25);
            redBtn.center = CGPointMake(CENTERX-75+(i-6)*30, CENTERY-45);
            redBtn.tag = i + 1;
            redBtn.userInteractionEnabled = false;
            [redBtn addTarget:self action:@selector(pressChessBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:redBtn];
            
            UIButton *blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [blueBtn setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
            blueBtn.frame = CGRectMake(0, 0, 25, 25);
            blueBtn.center = CGPointMake(CENTERX-75+(i-6)*30, CENTERY+45);
            blueBtn.tag = i + 7;
            blueBtn.userInteractionEnabled = false;
            [blueBtn addTarget:self action:@selector(pressChessBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:blueBtn];
        }
    }
}

- (void)pressChessBtn:(UIButton*)btn{
    [self.chessDelegate chessBtnDidTouchWithTag:btn.tag];
}

- (void)pressCloseBtn{
    dispatch_source_cancel(self.timer);
    [self.chessDelegate closeBtnDidTouchUpInside];
}

- (void)pressBackBtn{
    [self.chessDelegate backBtnDidTouchUpInside];
}

- (void)startTime {
    dispatch_resume(self.timer);
}

// 交换攻击
- (void)changeCampColorRed:(BOOL)isRed {
    for (UIButton *btn in self.subviews) {
        if (btn.tag > 0 && btn.tag <= 12) {
            btn.userInteractionEnabled = isRed;
        }
        if (btn.tag > 12 && btn.tag <= 24) {
            btn.userInteractionEnabled = !isRed;
        }
    }
}

- (void)redChessGo{
    self.isRedChess = true;
    [self changeCampColorRed:true];
}

- (void)blueChessGo{
    self.isRedChess = false;
    [self changeCampColorRed:false];
}

#pragma make - AI
- (void)closeUserClick {
    for (UIButton *btn in self.subviews) {
        if (btn.tag > 0 && btn.tag <= 12) {
            btn.userInteractionEnabled = false;
        }
        if (btn.tag > 12 && btn.tag <= 24) {
            btn.userInteractionEnabled = false;
        }
    }
}

- (void)AIRedChessGo {
    self.isRedChess = true;
    if (self.isAIRed) {
        [self closeUserClick];
        [self.chessDelegate AIShouldGo];
    }else {
        [self changeCampColorRed:true];
    }
}

- (void)AIBlueChessGo {
    self.isRedChess = false;
    if (self.isAIRed) {
        [self changeCampColorRed:false];
    }else {
        [self closeUserClick];
        [self.chessDelegate AIShouldGo];
    }
}

- (void)setAIWalkWithDict:(NSDictionary*)dict{
    YZChessPlace *p = dict[toKey];
    YZChessPlace *whoGo = dict[goKey];
    UIButton *shortBtn;
    for (UIButton *b in self.subviews) {
        if (b.tag == whoGo.tag) {
            shortBtn = b;
            [UIView animateWithDuration:0.3f animations:^{
                b.center = CGPointMake(p.frameX, p.frameY);
            }completion:^(BOOL finished) {
                self.emLayer = [YZEmitter yzEmitterLayer];
                [shortBtn.layer addSublayer:self.emLayer];
                [self startSpecalAnimationWithTag:shortBtn.tag];
            }];
        }
    }
    self.messageLabel.text = [NSString stringWithFormat:@"%ld号 (%ld,%ld) 走向 (%ld,%ld)",(long)whoGo.tag,(long)whoGo.x,(long)whoGo.y,(long)p.x,(long)p.y];
    [self.chessDelegate walkBtnDidTouchWithTag:shortBtn.tag frameX:shortBtn.center.x frameY:shortBtn.center.y];
    if (self.isRedChess) {
        [self AIBlueChessGo];
    }else{
        [self AIRedChessGo];
    }
}

- (void)setAIFlyWithDict:(NSDictionary*)dict{
    YZChessPlace *whoGo = dict[goKey];
    self.walkTag = whoGo.tag;
    NSArray *AIFlyArray = dict[toKey];
    for (UIButton *b in self.subviews) {
        if (b.tag == whoGo.tag) {
            [self bringSubviewToFront:b];
            CAKeyframeAnimation *animation = [YZFlyAnimation animationWithChessCenter:b.center chessArray:AIFlyArray];
            animation.delegate = self;
            [b.layer addAnimation:animation forKey:nil];
            shortFlyArray = AIFlyArray;
            break;
        }
    }
}

- (void)setWalkEngineWithArray:(NSArray *)array{
    for (UIButton *btn in self.subviews) {
        if (btn.tag<0) {
            [btn removeFromSuperview];
        }
    }
    for (YZChessPlace *p in array) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 25, 25);
        btn.center = CGPointMake(p.frameX, p.frameY);
        btn.tag = -1;
        [btn setBackgroundImage:[UIImage imageNamed:@"圆叉"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressWalkBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)pressWalkBtn:(UIButton*)btn{
    UIButton *shortBtn;
    for (UIButton *b in self.subviews) {
        if (b.tag == self.walkTag) {
            shortBtn = b;
//            移动棋子
            [UIView animateWithDuration:0.3f animations:^{
                b.center = btn.center;
            }completion:^(BOOL finished) {
                self.emLayer = [YZEmitter yzEmitterLayer];
                [shortBtn.layer addSublayer:self.emLayer];
                [self startSpecalAnimationWithTag:shortBtn.tag];
            }];
        }
    }
    [self.chessDelegate walkBtnDidTouchWithTag:shortBtn.tag frameX:shortBtn.center.x frameY:shortBtn.center.y];
    for (UIButton *b in self.subviews) {
        if (b.tag<0) {
            [b removeFromSuperview];
        }
    }
    if (self.isRedChess) {
        if (self.isAIType) {
            [self AIBlueChessGo];
        }else {
            [self blueChessGo];
        }
    }else{
        if (self.isAIType) {
            [self AIRedChessGo];
        }else {
            [self redChessGo];
        }
    }
}

- (void)setFlyEngineWithArray:(NSArray*)array{
    for (UIButton *btn in self.subviews) {
        if (btn.tag == -2) {
            [btn removeFromSuperview];
        }
    }
    flyArray = array;
    
    for (NSArray *array in flyArray) {
        YZChessPlace *p = array.lastObject;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 25, 25);
        btn.center = CGPointMake(p.frameX, p.frameY);
        btn.tag = -2;
        [btn setBackgroundImage:[UIImage imageNamed:@"圆叉"] forState:UIControlStateNormal];
        objc_setAssociatedObject(btn, "firstObject", array, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [btn addTarget:self action:@selector(flyEatChess:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)resetChessPlaceWithArray:(NSArray*)array{
    for (UIButton *btn in self.subviews) {
        if (btn.tag > 0) {
            [btn removeFromSuperview];
        }
    }
    
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = array[i][j];
            if (p.camp == -1) {
                UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [redBtn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
                redBtn.frame = CGRectMake(0, 0, 25, 25);
                redBtn.center = CGPointMake(p.frameX, p.frameY);
                redBtn.tag = p.tag;
                [redBtn addTarget:self action:@selector(pressChessBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:redBtn];
            }
            if (p.camp == 1) {
                UIButton *blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [blueBtn setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
                blueBtn.frame = CGRectMake(0, 0, 25, 25);
                blueBtn.center = CGPointMake(p.frameX, p.frameY);
                blueBtn.tag = p.tag;
                [blueBtn addTarget:self action:@selector(pressChessBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:blueBtn];
            }
        }
    }
    
    if (self.isRedChess) {
        if (self.isAIType) {
            [self performSelector:@selector(AIBlueChessGo) withObject:nil afterDelay:1];
        }else {
            [self blueChessGo];
        }
    }else{
        if (self.isAIType) {
            [self performSelector:@selector(AIRedChessGo) withObject:nil afterDelay:1];
        }else {
            [self redChessGo];
        }
    }
}

- (void)flyEatChess:(UIButton*)btn{
    NSArray *array = objc_getAssociatedObject(btn, "firstObject");
    for (UIButton *b in self.subviews) {
        if (b.tag == self.walkTag) {
            [self bringSubviewToFront:b];
            CAKeyframeAnimation *animation = [YZFlyAnimation animationWithChessCenter:b.center chessArray:array];
            animation.delegate = self;
            [b.layer addAnimation:animation forKey:nil];
            shortFlyArray = array;
            break;
        }
    }
}

- (void)flyEatWillEndWithTag:(NSInteger)tag{
    for (UIButton *btn in self.subviews) {
        if (btn.tag < 0 || btn.tag == tag) {
            [UIView animateWithDuration:0.1f animations:^{
                btn.alpha = 0;
            }completion:^(BOOL finished) {
                [btn removeFromSuperview];
            }];
        }
    }
}

#pragma mark - timer
- (void)startRedTime {
    self.redTime++;
    self.redTimeLabel.text = [self handleTime:self.redTime];
}

- (void)startBlueTime {
    self.blueTime++;
    self.blueTimeLabel.text = [self handleTime:self.blueTime];
}

- (NSString *)handleTime:(NSInteger)time {
    NSInteger minute = time / 60;
    NSInteger second = time % 60;
    NSString *mStr = @"";
    NSString *sStr = @"";
    
    if (minute > 9) {
        mStr = [NSString stringWithFormat:@"%ld",minute];
    }else {
        mStr = [NSString stringWithFormat:@"0%ld",minute];
    }
    if (second > 9) {
        sStr = [NSString stringWithFormat:@"%ld",second];
    }else {
        sStr = [NSString stringWithFormat:@"0%ld",second];
    }
    return [NSString stringWithFormat:@"%@:%@",mStr,sStr];
}

#pragma mark -特效
- (void)startSpecalAnimationWithTag:(NSInteger)tag{
    CGRect frame;
    for (UIButton *btn in self.subviews) {
        if (btn.tag == tag) {
            frame = btn.frame;
            break;
        }
    }
    self.emLayer.beginTime = CACurrentMediaTime();
    self.emLayer.birthRate = 1;
    self.emLayer.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    [self performSelector:@selector(stopSpecalAnimationWithTag:) withObject:[NSNumber numberWithInteger:tag] afterDelay:0.05];
}

- (void)stopSpecalAnimationWithTag:(NSNumber*)numTag{
    NSInteger tag = [numTag integerValue];
    for (UIButton *btn in self.subviews) {
        if (btn.tag == tag) {
            self.emLayer.birthRate = 0;
            [btn.layer removeAllAnimations];
            break;
        }
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        YZChessPlace *to = shortFlyArray.lastObject;
        for (UIButton *btn in self.subviews) {
            if (btn.tag == self.walkTag) {
                btn.center = CGPointMake(to.frameX, to.frameY);
                [btn.layer removeAllAnimations];
            }
        }
        self.messageLabel.text = [NSString stringWithFormat:@"%ld号 Attack %ld号",self.walkTag,to.tag];
        [self flyEatWillEndWithTag:to.tag];
        [self.chessDelegate chessBtnDidEatWith:self.walkTag toTag:to.tag];
        if (self.isRedChess) {
            if (self.isAIType) {
                [self AIBlueChessGo];
            }else {
                [self blueChessGo];
            }
        }else{
            if (self.isAIType) {
                [self AIRedChessGo];
            }else {
                [self redChessGo];
            }
        }
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    for (UIButton *btn in self.subviews) {
        if (btn.tag < 0) {
            [btn removeFromSuperview];
        }
        if (btn.tag > 0) {
            btn.userInteractionEnabled = false;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIButton *btn in self.subviews) {
        if (btn.tag < 0) {
            [btn removeFromSuperview];
        }
    }
}

#pragma make - setter
- (void)setIsAIType:(BOOL)isAIType{
    _isAIType = isAIType;
    if (_isAIType) {
        self.titleLabel.text = @"人机对决";
    }
}

#pragma mark - getter
- (dispatch_source_t)timer {
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.isRedChess) {
                    [self startRedTime];
                }else {
                    [self startBlueTime];
                }
            });
        });
    }
    return _timer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"人人对决";
        _titleLabel.font = [UIFont systemFontOfSize:30.0f];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _messageLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)redTimeLabel {
    if (!_redTimeLabel) {
        _redTimeLabel = [UILabel new];
        _redTimeLabel.textColor = [UIColor redColor];
        _redTimeLabel.textAlignment = NSTextAlignmentCenter;
        _redTimeLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        _redTimeLabel.text = @"00:00";
    }
    return _redTimeLabel;
}

- (UILabel *)blueTimeLabel {
    if (!_blueTimeLabel) {
        _blueTimeLabel = [UILabel new];
        _blueTimeLabel.textColor = [UIColor blueColor];
        _blueTimeLabel.textAlignment = NSTextAlignmentCenter;
        _blueTimeLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        _blueTimeLabel.text = @"00:00";
    }
    return _blueTimeLabel;
}

#pragma mark - 贝塞尔曲线棋盘 一个格子30
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
    UIBezierPath *circle1Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:60 startAngle:0 endAngle:-M_PI_2*3 clockwise:false];
    [RGB(0, 139, 69) setStroke];
    circle1Path.lineWidth = 1;
    [circle1Path stroke];
    //曲线-左上-小
    UIBezierPath *circle2Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:30 startAngle:0 endAngle:-M_PI_2*3 clockwise:false];
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
