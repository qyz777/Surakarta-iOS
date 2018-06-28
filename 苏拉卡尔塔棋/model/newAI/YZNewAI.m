//
//  YZNewAI.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/6/3.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZNewAI.h"
#import "YZChessPlace.h"
#import "YZWalkManager.h"
#import "YZFlyManager.h"
#import "YZChessValue.h"
#import "model.h"

NSString const *stepArrayKey = @"stepArrayKey";
NSString const *goKey = @"goKey";
NSString const *toKey = @"toKey";
NSString const *valueKey = @"valueKey";
NSString const *stepTypeKey = @"stepTypeKey";
NSString const *stepTypeWalk = @"stepTypeWalk";
NSString const *stepTypeFly = @"stepTypeFly";

@interface YZNewAI()

@property(nonatomic, assign)BOOL isNeedAgainThink;

@end

@implementation YZNewAI

- (NSDictionary *)stepDataWithChessPlace:(NSArray *)chessPlace {
    NSDictionary *step = [self stepWithChessPlace:chessPlace];
    if (step.count == 0) {
        self.isNeedAgainThink = true;
        step = [self stepWithChessPlace:chessPlace];
    }
    return step;
}


/**
 获得AI的下一步
 使用GCD为搜索树的第一层获得的所有节点开一条线程做并发队列
 每个线程中间使用信号量作为线程锁
 所有线程在一个GCD的group里，耗时任务结束后统一回到主线程回调

 @param chessPlace 棋盘
 @param block 下子回调
 */
- (void)stepWithChessPlace:(NSArray *)chessPlace block:(void(^)(NSDictionary *step))block {
    NSInteger chessNum = [YZChessValue chessNumWithChessPlace:chessPlace camp:self.camp];
    if (chessNum == 0) {
        return;
    }
    if (chessNum <= 5) {
        self.searchDepth = 5;
    }else {
        self.searchDepth = 3;
    }
    
    if (self.isFirst) {
        if (self.stepNum < 3) {
            block([self precedenceStrategyWithChessPlace:chessPlace]);
            return;
        }
    }
    
    NSArray *allStepArray = [self createStepsWithChessPlace:chessPlace camp:self.camp];
    NSMutableArray *shortPlace = chessPlace.mutableCopy;
    __block NSMutableDictionary *stepDict = @{}.mutableCopy;
    __block NSInteger maxValue = -9999999;
    
    NSDictionary *flyDict = [self flyStepWithChessPlace:chessPlace camp:self.camp];
    if (flyDict) {
        block(flyDict);
    }else {
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("qyz.alphaBeta", DISPATCH_QUEUE_CONCURRENT);
        
        for (NSDictionary *d in allStepArray) {
            __block NSArray *cPlace = shortPlace.copy;
            
            dispatch_semaphore_t signal = dispatch_semaphore_create(0);
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                BOOL isNeedContinue = true;
                YZChessPlace *goChess = d[goKey];
                YZChessPlace *toChess = d[toKey];
                cPlace = [self stepWithChess:goChess toChess:toChess chessPlace:cPlace.copy];
                //            如果不是一定会被吃子，模拟下子的位置会被吃，放弃，直接结束线程
                if (!self.isNeedAgainThink) {
                    if ([self isChessWillKilledWithChessPlace:chessPlace]) {
                        isNeedContinue = false;
                    }
                }
                if (isNeedContinue) {
                    NSMutableArray *cShortPlace = [self newChessPlace:cPlace];
                    NSInteger value = [self alphaBetaSearchWithDepth:self.searchDepth alpha:-20000 beta:20000 camp:-self.camp chessPlace:cShortPlace.copy];
                    if (value > maxValue) {
                        maxValue = value;
                        [stepDict setObject:[NSNumber numberWithInteger:value] forKey:valueKey];
                        [stepDict setObject:goChess forKey:goKey];
                        [stepDict setObject:toChess forKey:toKey];
                        [stepDict setObject:stepTypeWalk forKey:stepTypeKey];
                    }
                    if (value == maxValue) {
                        //                    添加随机情况
                        int r = arc4random() % 100;
                        if (r > 50) {
                            maxValue = value;
                            [stepDict setObject:[NSNumber numberWithInteger:value] forKey:valueKey];
                            [stepDict setObject:goChess forKey:goKey];
                            [stepDict setObject:toChess forKey:toKey];
                            [stepDict setObject:stepTypeWalk forKey:stepTypeKey];
                        }
                    }
                }
                cPlace = [self stepWithChess:toChess toChess:goChess chessPlace:cPlace.copy];
                
                dispatch_semaphore_signal(signal);
                dispatch_group_leave(group);
            });
            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (stepDict.count == 0) {
                self.isNeedAgainThink = true;
                [self stepWithChessPlace:chessPlace block:^(NSDictionary *step) {
                    block(step.copy);
                    return;
                }];
            }
            block(stepDict.copy);
            return;
        });
    }
}

- (NSDictionary *)stepWithChessPlace:(NSArray *)chessPlace {
    NSInteger chessNum = [YZChessValue chessNumWithChessPlace:chessPlace camp:self.camp];
    if (chessNum <= 6) {
        self.searchDepth = 5;
        self.isNeedAgainThink = YES;
    }else {
        self.searchDepth = 3;
    }
    
    if (self.isFirst) {
        if (self.stepNum < 3) {
            return [self precedenceStrategyWithChessPlace:chessPlace];
        }
    }else {
        if (self.stepNum < 3) {
            NSDictionary *d = [self laterStrategyWithChessPlace:chessPlace];
            if (d) {
                return d;
            }
        }
    }
    
//    拿到全部可以下子的位置，此处全部可以下子的的数组不包含可吃子的位置
    NSArray *allStepArray = [self createStepsWithChessPlace:chessPlace camp:self.camp];
    NSMutableDictionary *stepDict = @{}.mutableCopy;
    NSInteger maxValue = -9999999;
    for (NSDictionary *d in allStepArray) {
        YZChessPlace *goChess = d[goKey];
        YZChessPlace *toChess = d[toKey];
//        可以吃子，直接吃
        NSDictionary *flyDict = [self flyStepWithChessPlace:chessPlace camp:self.camp];
        if (flyDict) {
            return flyDict;
        }
        chessPlace = [self stepWithChess:goChess toChess:toChess chessPlace:chessPlace];
//        如果不是一定会被吃子，模拟下子的位置会被吃，放弃
        if (!self.isNeedAgainThink) {
            if ([self isChessWillKilledWithChessPlace:chessPlace]) {
                chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace];
                continue;
            }
        }
        
        NSMutableArray *shortPlace = [self newChessPlace:chessPlace];
        NSInteger value = [self alphaBetaSearchWithDepth:self.searchDepth alpha:-20000 beta:20000 camp:-self.camp chessPlace:shortPlace.copy];
        
        chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace];
    
        if (value > maxValue) {
            maxValue = value;
            [stepDict setObject:[NSNumber numberWithInteger:value] forKey:valueKey];
            [stepDict setObject:goChess forKey:goKey];
            [stepDict setObject:toChess forKey:toKey];
            [stepDict setObject:stepTypeWalk forKey:stepTypeKey];
        }
        if (value == maxValue) {
            int r = arc4random() % 100;
            if (r > 50) {
                maxValue = value;
                [stepDict setObject:[NSNumber numberWithInteger:value] forKey:valueKey];
                [stepDict setObject:goChess forKey:goKey];
                [stepDict setObject:toChess forKey:toKey];
                [stepDict setObject:stepTypeWalk forKey:stepTypeKey];
            }
        }
    }
    return stepDict.copy;
}

#pragma make - α-β Search
- (NSInteger)alphaBetaSearchWithDepth:(NSInteger)depth
                                alpha:(NSInteger)alpha
                                 beta:(NSInteger)beta
                                 camp:(NSInteger)camp
                           chessPlace:(NSArray *)chessPlace
{
    if (depth <= 0) {
        return [self valueWithChessPlace:chessPlace camp:camp] - [self valueWithChessPlace:chessPlace camp:-camp];
    }
    
    NSArray *allStepArray = [self createFlyStepWithChessPlace:chessPlace camp:camp];
    if (allStepArray.count == 0) {
        allStepArray = [self createStepsWithChessPlace:chessPlace camp:camp];
    }
    
    for (NSDictionary *d in allStepArray) {
        YZChessPlace *goChess = d[goKey];
        YZChessPlace *toChess = d[toKey];
        chessPlace = [self stepWithChess:goChess toChess:toChess chessPlace:chessPlace];
        NSInteger value = [self alphaBetaSearchWithDepth:depth - 1 alpha:-beta beta:-alpha camp:-camp chessPlace:chessPlace];
        chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace];
        if (value > alpha) {
            alpha = value;
        }
        if (value >= beta) {
            break;
        }
    }
    
    return alpha;
}


/**
 评估函数
 
 @param chessPlace 棋盘
 @param camp 阵营
 @return 返回评估值
 */
- (NSInteger)valueWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp{
//    棋盘价值
    NSInteger chessValue = 0;
//    下子范围
    NSInteger walkRange = 0;
//    棋子攻击力
    NSInteger ATK = 0;
//    棋子数量
    NSInteger chessNum = [YZChessValue chessNumWithChessPlace:chessPlace camp:camp];
    
    NSInteger angle = [YZChessValue angleNeedPerchWithChessPlace:chessPlace camp:camp];
//    可吃子得分
    NSInteger killScore = 0;
    
    NSInteger endingPostionScore = [YZChessValue endingPostionValueWithChessPlace:chessPlace camp:camp];
    
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                if (angle != -1) {
                    if (chessNum <= 6) {
                        //                    进入残局
                        chessValue += [YZChessValue chessEndingValueWithChess:p];
                    }
                    if (chessNum >= 11) {
                        chessValue += [YZChessValue chessFirstValueWithChess:p];
                    }else {
                        chessValue += [YZChessValue anglePostionValueWithChessPlace:chessPlace chess:p angle:angle];
                    }
                }else {
                    if (chessNum <= 6) {
                        //                    进入残局
                        chessValue += [YZChessValue chessEndingValueWithChess:p];
                    }
                    if (chessNum >= 11) {
                        chessValue += [YZChessValue chessFirstValueWithChess:p];
                    }else {
                        chessValue += [YZChessValue chessValueWithChess:p];
                    }
                }
                walkRange += [YZChessValue chessWalkRangeWithChessPlace:chessPlace chess:p];
                ATK += [YZChessValue chessAttackWithChessPlace:chessPlace chess:p];
            }
            if (p.camp == self.camp) {
                killScore += [YZChessValue chessWillKillWithChessPlace:chessPlace camp:camp];
            }
        }
    }
//    [self networkPredictionWithChessPlace:chessPlace];
    NSInteger value = chessNum + walkRange + ATK + chessValue + killScore + endingPostionScore;
    return value;
}


/**
 用来生成可下棋子的位置
 
 @param chessPlace 棋盘
 @return 返回一个包含字典的数组 字典包含 [棋子] [棋子可以下的点]->NSArray
 */
- (NSArray *)createStepsWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    NSMutableArray *stepQueen = [[NSMutableArray alloc]init];
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                NSMutableArray *allCanStepArray = [YZWalkManager walkEngine:p.x Y:p.y previousArray:chessPlace];
                for (YZChessPlace *canStep in allCanStepArray) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:p forKey:goKey];
                    [dict setObject:canStep forKey:toKey];
                    [stepQueen addObject:dict.copy];
                }
            }
        }
    }
    return stepQueen.copy;
}

- (NSArray *)createFlyStepWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    NSMutableArray *stepQueen = [[NSMutableArray alloc]init];
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                NSMutableArray *allCanFlyArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (allCanFlyArray.count > 0) {
                    for (NSArray *af in allCanFlyArray) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:p forKey:goKey];
                        [dict setObject:af.lastObject forKey:toKey];
                        [stepQueen addObject:dict.copy];
                    }
                }
            }
        }
    }
    return stepQueen.copy;
}

- (void)networkPredictionWithChessPlace:(NSArray *)chessPlace {
    NSMutableArray<NSNumber *> *campArray = [[NSMutableArray alloc]init];
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == -1) {
                [campArray addObject:@(-1)];
            }else if (p.camp == 1) {
                [campArray addObject:@(1)];
            }else {
                [campArray addObject:@(0)];
            }
        }
    }
    MLMultiArray *feedArray = [[MLMultiArray alloc]initWithShape:@[@36] dataType:MLMultiArrayDataTypeInt32 error:nil];
    for (int i=0; i<campArray.count; i++) {
        [feedArray setObject:feedArray[i] atIndexedSubscript:i];
    }
    
    model *network = [model new];
    NSError *error = nil;
    modelOutput *networkOutput = [network predictionFromInput:feedArray error:&error];
    MLMultiArray *shortArray = networkOutput.Prediction;
    NSNumber *a = shortArray[0];
    if ([a integerValue] > 0 && [a integerValue] < 10000) {
        NSLog(@"%@",a);
    }
}


/**
 棋子会不会被吃

 @param chessPlace 棋盘
 @return 是否被吃
 */
- (BOOL)isChessWillKilledWithChessPlace:(NSArray *)chessPlace {
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == -self.camp) {
                NSArray *flyArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (flyArray.count > 0) {
                    return true;
                }
            }
        }
    }
    return false;
}

- (BOOL)isChessWillKilledWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess{
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == -self.camp) {
                NSArray *flyArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (flyArray.count > 0) {
                    for (NSArray *fly in flyArray) {
                        YZChessPlace *f = fly.lastObject;
                        if (f.tag == chess.tag) {
                            return true;
                        }
                    }
                }
            }
        }
    }
    return false;
}


/**
 拿到棋子飞行的位置
 
 @param chessPlace 棋盘
 @param camp 阵营
 @return 返回一个字典 [价值] [棋子] [下棋子的位置] [类型]
 */
- (NSDictionary *)flyStepWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp{
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                NSArray *flyStepArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (flyStepArray.count > 0) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:@100 forKey:valueKey];
                    [dict setObject:p forKey:goKey];
                    [dict setObject:flyStepArray.firstObject forKey:toKey];
                    [dict setObject:stepTypeFly forKey:stepTypeKey];
                    return dict.copy;
                }
            }
        }
    }
    return nil;
}


/**
 用来模拟下子的方法，可以用来撤回下子
 
 @param goChess 棋子
 @param toChess 下棋子的位置
 @param chessPlace 棋盘
 @return 返回一个模拟下完棋子的棋盘
 */
- (NSArray *)stepWithChess:(YZChessPlace *)goChess toChess:(YZChessPlace *)toChess chessPlace:(NSArray *)chessPlace{
    YZChessPlace *pGo = [chessPlace[goChess.x][goChess.y] copy];
    YZChessPlace *pTo = [chessPlace[toChess.x][toChess.y] copy];
    
    pTo.tag = goChess.tag;
    pTo.camp = goChess.camp;
    
    pGo.tag = toChess.tag;
    pGo.camp = toChess.camp;
    
    chessPlace[goChess.x][goChess.y] = pGo;
    chessPlace[toChess.x][toChess.y] = pTo;
    
    goChess.tag = pGo.tag;
    goChess.camp = pGo.camp;
    
    toChess.tag = pTo.tag;
    toChess.camp = pTo.camp;
    
    return chessPlace;
}

// 先手策略
- (NSDictionary *)precedenceStrategyWithChessPlace:(NSArray *)chessPlace {
    if (self.camp == -1) {
        if (self.stepNum == 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[1][1] forKey:goKey];
            [dict setObject:chessPlace[2][2] forKey:toKey];
            return dict.copy;
        }
        if (self.stepNum == 1) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[1][0] forKey:goKey];
            [dict setObject:chessPlace[2][0] forKey:toKey];
            return dict.copy;
        }
        if (self.stepNum == 2) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[0][1] forKey:goKey];
            [dict setObject:chessPlace[1][1] forKey:toKey];
            return dict.copy;
        }
    }else {
        if (self.stepNum == 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[4][1] forKey:goKey];
            [dict setObject:chessPlace[3][2] forKey:toKey];
            return dict.copy;
        }
        if (self.stepNum == 1) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[4][0] forKey:goKey];
            [dict setObject:chessPlace[3][0] forKey:toKey];
            return dict.copy;
        }
        if (self.stepNum == 2) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[5][1] forKey:goKey];
            [dict setObject:chessPlace[4][1] forKey:toKey];
            return dict.copy;
        }
    }
    return nil;
}

- (NSDictionary *)laterStrategyWithChessPlace:(NSArray *)chessPlace {
    if (self.camp == -1) {
        if (self.stepNum == 0) {
            YZChessPlace *p1 = chessPlace[3][0];
            YZChessPlace *p2 = chessPlace[3][2];
            if (p1.camp == 1 || p2.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][1] forKey:goKey];
                [dict setObject:chessPlace[2][2] forKey:toKey];
                return dict.copy;
            }
            YZChessPlace *p3 = chessPlace[3][5];
            YZChessPlace *p4 = chessPlace[3][3];
            if (p3.camp == 1 || p4.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][4] forKey:goKey];
                [dict setObject:chessPlace[2][3] forKey:toKey];
                return dict.copy;
            }
        }
        if (self.stepNum == 1) {
            YZChessPlace *p1 = chessPlace[3][0];
            YZChessPlace *p2 = chessPlace[3][2];
            if (p1.camp == 1 && p2.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][0] forKey:goKey];
                [dict setObject:chessPlace[2][1] forKey:toKey];
                return dict.copy;
            }
            YZChessPlace *p3 = chessPlace[3][5];
            YZChessPlace *p4 = chessPlace[3][3];
            if (p3.camp == 1 && p4.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][5] forKey:goKey];
                [dict setObject:chessPlace[2][4] forKey:toKey];
                return dict.copy;
            }
        }
        if (self.stepNum == 2) {
            YZChessPlace *p1 = chessPlace[4][1];
            YZChessPlace *p2 = chessPlace[4][4];
            YZChessPlace *p3 = chessPlace[5][1];
            YZChessPlace *p4 = chessPlace[5][4];
            if (p1.camp == 1 && p3.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[0][1] forKey:goKey];
                [dict setObject:chessPlace[1][1] forKey:toKey];
                return dict.copy;
            }
            if (p2.camp == 1 && p4.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[0][4] forKey:goKey];
                [dict setObject:chessPlace[1][4] forKey:toKey];
                return dict.copy;
            }
        }
    }else {
        if (self.stepNum == 0) {
            YZChessPlace *p1 = chessPlace[2][0];
            YZChessPlace *p2 = chessPlace[2][2];
            if (p1.camp == -1 || p2.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][1] forKey:goKey];
                [dict setObject:chessPlace[3][2] forKey:toKey];
                return dict.copy;
            }
            YZChessPlace *p3 = chessPlace[2][5];
            YZChessPlace *p4 = chessPlace[2][3];
            if (p3.camp == -1 || p4.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][4] forKey:goKey];
                [dict setObject:chessPlace[3][3] forKey:toKey];
                return dict.copy;
            }
        }
        if (self.stepNum == 1) {
            YZChessPlace *p1 = chessPlace[2][0];
            YZChessPlace *p2 = chessPlace[2][2];
            if (p1.camp == -1 && p2.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][0] forKey:goKey];
                [dict setObject:chessPlace[3][1] forKey:toKey];
                return dict.copy;
            }
            YZChessPlace *p3 = chessPlace[2][5];
            YZChessPlace *p4 = chessPlace[2][3];
            if (p3.camp == -1 && p4.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][5] forKey:goKey];
                [dict setObject:chessPlace[3][4] forKey:toKey];
                return dict.copy;
            }
        }
        if (self.stepNum == 2) {
            YZChessPlace *p1 = chessPlace[1][1];
            YZChessPlace *p2 = chessPlace[1][4];
            YZChessPlace *p3 = chessPlace[0][1];
            YZChessPlace *p4 = chessPlace[0][4];
            if (p1.camp == -1 && p3.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[5][1] forKey:goKey];
                [dict setObject:chessPlace[4][1] forKey:toKey];
                return dict.copy;
            }
            if (p2.camp == -1 && p4.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[5][4] forKey:goKey];
                [dict setObject:chessPlace[4][4] forKey:toKey];
                return dict.copy;
            }
        }
    }
    return nil;
}

- (NSMutableArray *)newChessPlace:(NSArray *)chessPlace {
    NSMutableArray *newChessPlace = [NSMutableArray array];
    for (NSArray *array in chessPlace) {
        NSMutableArray *xArray = [NSMutableArray array];
        for (YZChessPlace *p in array) {
            [xArray addObject:p.copy];
        }
        [newChessPlace addObject:xArray];
    }
    return newChessPlace;
}

@end
