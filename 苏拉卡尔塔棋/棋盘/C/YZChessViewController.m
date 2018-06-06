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
//#import "YZNormalAI.h"
#import "YZNewAI.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YZChessViewController ()<YZChessViewDelegate>{
//    储存棋盘，用于悔棋
    NSMutableArray *recordArray;
//    飞行数组
    NSMutableArray *flyPath;
//    有多个飞行数组组成
    NSMutableArray *finishFlyPath;
//    声音
    SystemSoundID sourceEatChess;
    SystemSoundID sourceGoChess;
//    双方下棋总步数
    NSInteger stepNumber;
}

@property(nonatomic, strong)YZChessView *chessView;
@property(nonatomic, strong)NSMutableArray *chessPlace;
@property(nonatomic, assign)NSInteger AIStepNum;
@property(nonatomic, strong)YZNewAI *AI;

@end

@implementation YZChessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPriority];
    [self initAI];
}


/**
 初始化界面
 这里的新建棋盘矩阵的过程中把每个点位的初始化数据为YZChessPlace，具体数据内容请查看YZChessPlace
 棋子的tag初始为1
 */
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.chessView = [[YZChessView alloc]init];
    stepNumber = 0;
//    判断游戏模式是人机还是人人
    if (self.gameMode == chessGameModePVP) {
        self.chessView.isAIType = false;
    }else {
        self.chessView.isAIType = true;
        self.AIStepNum = 0;
    }
//    判断AI在哪一方
    if ([YZSettings isOnWithKey:@"whoRed"]) {
        self.chessView.isAIRed = true;
    }else {
        self.chessView.isAIRed = false;
    }
    self.chessView.chessDelegate = self;
    [self.view addSubview:self.chessView];
    self.chessPlace = [YZChessPlace initPlace];
    recordArray = [[NSMutableArray alloc]init];
    [recordArray addObject:[YZChessPlace initPlace]];
    [self initAudio];
}

- (void)initPriority{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择先手" message:@"" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"红方" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.gameMode == chessGameModePVP) {
            [self.chessView redChessGo];
        }else {
            [self.chessView AIRedChessGo];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"蓝方" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.gameMode == chessGameModePVP) {
            [self.chessView blueChessGo];
        }else {
            [self.chessView AIBlueChessGo];
        }
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)initAudio{
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eatChess.mp3" ofType:@""]]), &sourceEatChess);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"go.mp3" ofType:@""]]), &sourceGoChess);
}

- (void)initAI {
    self.AI = [YZNewAI new];
//      判断AI是红方还是蓝方
    if ([YZSettings isOnWithKey:@"whoRed"]) {
        self.AI.camp = -1;
    }else {
        self.AI.camp = 1;
    }
}

#pragma make - AI协议
- (void)AIShouldGo{
    [self performSelector:@selector(AIGo) withObject:nil afterDelay:0.5];
}

- (void)AIGo{
    NSDictionary *dict = [self.AI stepDataWithChessPlace:self.chessPlace.copy];
    self.AIStepNum++;
    if (dict.count > 0) {
        NSString *str = dict[stepTypeKey];
        if ([str isEqualToString:@"stepTypeFly"]) {
            [self.chessView setAIFlyWithDict:dict];
        }else {
            [self.chessView setAIWalkWithDict:dict];
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
        self.AIStepNum--;
        NSMutableArray *chess = recordArray[recordArray.count - 1];
        [recordArray removeLastObject];
        [self.chessView resetChessPlaceWithArray:chess.copy];
        self.chessPlace = chess.copy;
    }
}

- (void)chessBtnDidTouchWithTag:(NSInteger)tag{
    NSInteger x = 0;
    NSInteger y = 0;
    NSInteger camp = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = self.chessPlace[i][j];
            if (p.tag == tag) {
                x = p.x;
                y = p.y;
                camp = p.camp;
            }
        }
    }
    
    //设置walk引擎
    NSArray *arrayWalk = [YZWalkManager walkEngine:x Y:y previousArray:self.chessPlace.copy];
    [self.chessView setWalkEngineWithArray:arrayWalk];
    self.chessView.walkTag = tag;
    
    //设置飞行引擎
    finishFlyPath = [YZFlyManager flyManageWithX:x Y:y Camp:camp placeArray:self.chessPlace];
    
    if (finishFlyPath.count > 0) {
        [self.chessView setFlyEngineWithArray:finishFlyPath.copy];
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
                YZChessPlace *p = self.chessPlace[i][j];
                if (p.tag == firstTag) {
                    shortCamp = p.camp;
                    p.tag = 0;
                    p.camp = 0;
                    self.chessPlace[i][j] = p;
                }
                if (p.tag == lastTag) {
                    m = i;
                    n = j;
                }
            }
        }
        YZChessPlace *shortP = self.chessPlace[m][n];
        shortP.tag = firstTag;
        shortP.camp = shortCamp;
        self.chessPlace[m][n] = shortP;
        
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
                YZChessPlace *p = self.chessPlace[i][j];
                if (p.tag == tag) {
                    shortCamp = p.camp;
                    p.tag = 0;
                    p.camp = 0;
                    self.chessPlace[i][j] = p;
                }
                if (p.frameX == x && p.frameY == y) {
                    m = i;
                    n = j;
                }
            }
        }
        YZChessPlace *shortP = self.chessPlace[m][n];
        shortP.tag = shortTag;
        shortP.camp = shortCamp;
        self.chessPlace[m][n] = shortP;
        
//        查看布局
//        for (NSArray *a in self.chessPlace) {
//            YZChessPlace *p1 = a[0];
//            YZChessPlace *p2 = a[1];
//            YZChessPlace *p3 = a[2];
//            YZChessPlace *p4 = a[3];
//            YZChessPlace *p5 = a[4];
//            YZChessPlace *p6 = a[5];
//            NSLog(@"%ld %ld %ld %ld %ld %ld",p1.camp,p2.camp,p3.camp,p4.camp,p5.camp,p6.camp);
//        }
//        NSLog(@"\n");
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
            YZChessPlace *pp = self.chessPlace[i][j];
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
            YZChessPlace *p = self.chessPlace[i][j];
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
