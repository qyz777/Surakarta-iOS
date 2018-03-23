//
//  YZChessViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZChessViewController.h"
#import "YZChessView.h"
#import "YZChessPlace.h"
#import "YZWalkManager.h"
#import "YZFlyManager.h"
#import "YZSettings.h"
#import "YZNormalAI.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YZChessViewController ()<YZChessViewDelegate>{
    YZChessView *_kYZChessView;
//    棋盘
    NSMutableArray *placeArray;
//    储存棋盘，用于悔棋
    NSMutableArray *recordArray;
//    飞行数组
    NSMutableArray *flyPath;
//    有多个飞行数组组成
    NSMutableArray *finishFlyPath;
//    声音
    SystemSoundID sourceEatChess;
    SystemSoundID sourceGoChess;
//    AI下棋步数
    NSInteger AIStepNum;
//    双方下棋总步数
    NSInteger stepNumber;
}

@end

@implementation YZChessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initPriority];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPriority];
}


/**
 初始化界面
 这里的新建棋盘矩阵的过程中把每个点位的初始化数据为YZChessPlace，具体数据内容请查看YZChessPlace
 棋子的tag初始为1
 */
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    _kYZChessView = [[YZChessView alloc]init];
    stepNumber = 0;
    if (self.gameMode == chessGameModePVP) {
        _kYZChessView.isAIType = false;
    }else {
        _kYZChessView.isAIType = true;
        AIStepNum = 0;
    }
    _kYZChessView.chessDelegate = self;
    [self.view addSubview:_kYZChessView];
    placeArray = [YZChessPlace initPlace];
    recordArray = [[NSMutableArray alloc]init];
    [recordArray addObject:[YZChessPlace initPlace]];
    [self initAudio];
}

- (void)initPriority{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择先手" message:@"" preferredStyle: UIAlertControllerStyleAlert];
    if (self.gameMode == chessGameModePVP) {
        [alert addAction:[UIAlertAction actionWithTitle:@"红方" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_kYZChessView redChessGo];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"蓝方" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_kYZChessView blueChessGo];
        }]];
    }else {
        [alert addAction:[UIAlertAction actionWithTitle:@"AI先手" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_kYZChessView redChessGo];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"玩家先手" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_kYZChessView blueChessGo];
        }]];
    }
    [self presentViewController:alert animated:true completion:nil];
}

- (void)initAudio{
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eatChess.mp3" ofType:@""]]), &sourceEatChess);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"go.mp3" ofType:@""]]), &sourceGoChess);
}

#pragma make - AI协议
- (void)AIShouldGo{
    [self performSelector:@selector(AIGo) withObject:nil afterDelay:0.5];
}

- (void)AIGo{
    YZNormalAI *AI = [[YZNormalAI alloc]init];
    NSDictionary *dict = [AI dictWithChessPlace:placeArray.copy StepNum:AIStepNum];
    AIStepNum++;
    if (dict) {
        NSString *str = dict[@"type"];
        if ([str isEqualToString:@"fly"]) {
            [_kYZChessView setAIFlyWithDict:dict.copy];
        }else {
            [_kYZChessView setAIWalkWithDict:dict.copy];
        }
    }
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

#pragma make - 协议
- (void)closeBtnDidTouchUpInside{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

- (void)backBtnDidTouchUpInside{
    if (stepNumber - 1 > 0) {
        stepNumber--;
        AIStepNum--;
        NSMutableArray *chess = recordArray[recordArray.count - 1];
        [recordArray removeLastObject];
        [_kYZChessView resetChessPlaceWithArray:chess.copy];
        placeArray = chess.copy;
    }
}

- (void)chessBtnDidTouchWithTag:(NSInteger)tag{
    NSInteger x = 0;
    NSInteger y = 0;
    NSInteger camp = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = placeArray[i][j];
            if (p.tag == tag) {
                x = p.x;
                y = p.y;
                camp = p.camp;
            }
        }
    }
    
    //设置walk引擎
    NSArray *arrayWalk = [YZWalkManager walkEngine:x Y:y previousArray:placeArray.copy];
    [_kYZChessView setWalkEngineWithArray:arrayWalk];
    _kYZChessView.walkTag = tag;
    
    //设置飞行引擎
    finishFlyPath = [YZFlyManager flyManageWithX:x Y:y Camp:camp placeArray:placeArray];
    
    if (finishFlyPath.count > 0) {
        [_kYZChessView setFlyEngineWithArray:finishFlyPath.copy];
        [finishFlyPath removeAllObjects];
    }
}

/**
 棋子吃子完以后的协议
 
 @param firstTag 吃子的tag
 @param lastTag 被吃子的tag
 */
- (void)chessBtnDidEatWithFirstTag:(NSInteger)firstTag lastTag:(NSInteger)lastTag{
    stepNumber++;
    
    if ([YZSettings isOnWithKey:@"vibrate"]) {
        AudioServicesPlaySystemSound(1519);
    }
    if ([YZSettings isOnWithKey:@"eatChessSource"]) {
        AudioServicesPlaySystemSound(sourceEatChess);
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self saveChessPlace];
        
        NSInteger shortCamp = 0;
        int m = 0,n = 0;
        for (int i=0; i<6; i++) {
            for (int j=0; j<6; j++) {
                YZChessPlace *p = placeArray[i][j];
                if (p.tag == firstTag) {
                    shortCamp = p.camp;
                    p.tag = 0;
                    p.camp = 0;
                    placeArray[i][j] = p;
                }
                if (p.tag == lastTag) {
                    m = i;
                    n = j;
                }
            }
        }
        YZChessPlace *shortP = placeArray[m][n];
        shortP.tag = firstTag;
        shortP.camp = shortCamp;
        placeArray[m][n] = shortP;
        
        [self whoWinGame];
    });
}

/**
 棋子经过walk引擎然后改矩阵
 
 @param tag 需要移动棋子的tag值
 @param x x坐标
 @param y y坐标
 */
- (void)walkBtnDidTouchWithTag:(NSInteger)tag frameX:(CGFloat)x frameY:(CGFloat)y{
    stepNumber++;
    
    if ([YZSettings isOnWithKey:@"goChessSource"]) {
        AudioServicesPlaySystemSound(sourceGoChess);
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self saveChessPlace];
        
        NSInteger shortTag = tag;
        NSInteger shortCamp = 0;
        int m = 0;
        int n = 0;
        for (int i=0; i<6; i++) {
            for (int j=0; j<6; j++) {
                YZChessPlace *p = placeArray[i][j];
                if (p.tag == tag) {
                    shortCamp = p.camp;
                    p.tag = 0;
                    p.camp = 0;
                    placeArray[i][j] = p;
                }
                if (p.frameX == x && p.frameY == y) {
                    m = i;
                    n = j;
                }
            }
        }
        YZChessPlace *shortP = placeArray[m][n];
        shortP.tag = shortTag;
        shortP.camp = shortCamp;
        placeArray[m][n] = shortP;
    });
}


/**
 临时存储棋盘供悔棋使用
 */
- (void)saveChessPlace{
    NSMutableArray *xArray = [[NSMutableArray alloc]init];
    for (int i=0; i<6; i++) {
        NSMutableArray *yArray = [[NSMutableArray alloc]init];
        for (int j=0; j<6; j++) {
            YZChessPlace *p = [[YZChessPlace alloc]init];
            YZChessPlace *pp = placeArray[i][j];
            p.x = pp.x;
            p.y = pp.y;
            p.frameX = pp.frameX;
            p.frameY = pp.frameY;
            p.camp = pp.camp;
            p.tag = pp.tag;
            [yArray addObject:p];
        }
        [xArray addObject:yArray];
    }
    [recordArray addObject:xArray];
}


/**
 判断哪一方赢了
 */
- (void)whoWinGame{
    int red = 0;
    int blue = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = placeArray[i][j];
            if (p.camp == -1) {
                red++;
            }
            if (p.camp == 1) {
                blue++;
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (red == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"结果" message:@"蓝方获胜" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }]];
            [self presentViewController:alert animated:true completion:nil];
        }
        if (blue == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"结果" message:@"红方获胜" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }]];
            [self presentViewController:alert animated:true completion:nil];
        }
    });
}

@end
