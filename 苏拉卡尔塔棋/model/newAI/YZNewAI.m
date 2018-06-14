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
    NSArray *allStepArray = [self createStepsWithChessPlace:chessPlace];
    NSMutableArray *shortPlace = chessPlace.mutableCopy;
    __block NSMutableDictionary *stepDict = @{}.mutableCopy;
    __block NSMutableDictionary *flyStep = @{}.mutableCopy;
    __block NSInteger maxValue = 0;
    
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
//            可以吃子，下面的节点不用跑了，直接结束线程
            NSDictionary *flyDict = [self flyStepWithChessPlace:cPlace chess:goChess];
            if (flyDict) {
                flyStep = flyDict.mutableCopy;
                isNeedContinue = false;
            }
            cPlace = [self stepWithChess:goChess toChess:toChess chessPlace:cPlace.copy];
//            如果不是一定会被吃子，模拟下子的位置会被吃，放弃，直接结束线程
            if (!self.isNeedAgainThink) {
                if ([self chessWillKilledWithChessPlace:chessPlace]) {
                    isNeedContinue = false;
                }
            }
            if (isNeedContinue) {
                NSInteger value = [self alphaBetaSearchWithDepth:4 alpha:-20000 beta:20000 camp:self.camp chessPlace:cPlace.copy];
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
        if (flyStep.count > 0) {
            block(flyStep.copy);
        }else {
            if (stepDict.count == 0) {
                self.isNeedAgainThink = true;
                [self stepWithChessPlace:chessPlace block:^(NSDictionary *step) {
                    block(step.copy);
                }];
            }
            block(stepDict.copy);
        }
    });
}

- (NSDictionary *)stepWithChessPlace:(NSArray *)chessPlace {
//    拿到全部可以下子的位置，此处全部可以下子的的数组不包含可吃子的位置
    NSArray *allStepArray = [self createStepsWithChessPlace:chessPlace];
    NSMutableDictionary *stepDict = @{}.mutableCopy;
    NSInteger maxValue = 0;
    for (NSDictionary *d in allStepArray) {
        YZChessPlace *goChess = d[goKey];
        YZChessPlace *toChess = d[toKey];
//        可以吃子，直接吃
        NSDictionary *flyDict = [self flyStepWithChessPlace:chessPlace chess:goChess];
        if (flyDict) {
            return flyDict;
        }
        chessPlace = [self stepWithChess:goChess toChess:toChess chessPlace:chessPlace.copy];
//        如果不是一定会被吃子，模拟下子的位置会被吃，放弃
        if (!self.isNeedAgainThink) {
            if ([self chessWillKilledWithChessPlace:chessPlace]) {
                chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace.copy];
                continue;
            }
        }
        NSInteger value = [self alphaBetaSearchWithDepth:4 alpha:-20000 beta:20000 camp:_camp chessPlace:chessPlace.copy];
        chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace.copy];
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
    NSArray *allStepArray = [self createStepsWithChessPlace:chessPlace];
    for (NSDictionary *d in allStepArray) {
        YZChessPlace *goChess = d[goKey];
        YZChessPlace *toChess = d[toKey];
        chessPlace = [self stepWithChess:goChess toChess:toChess chessPlace:chessPlace.copy];
        NSInteger value = [self alphaBetaSearchWithDepth:depth - 1 alpha:-beta beta:-alpha camp:-camp chessPlace:chessPlace.copy];
        chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace.copy];
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
- (NSInteger)valueWithChessPlace:(NSArray *)chessPlace camp:(NSInteger) camp{
//    棋盘价值
    NSInteger chessValue = 0;
//    下子范围
    NSInteger walkRange = 0;
//    棋子攻击力
    NSInteger ATK = 0;
//    棋子数量
    NSInteger chessNum = [YZChessValue chessNumWithChessPlace:chessPlace camp:camp];
//    坏子得分 —— 负数
    NSInteger badScore = 0;
//    坏棋位得分 —— 负数
    NSInteger badPosition = [YZChessValue badPositionWithChessPlace:chessPlace camp:camp];
    
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                if (chessNum <= 6) {
//                    进入残局
                    chessValue += [YZChessValue chessEndingValueWithChess:p];
                }else {
                    chessValue += [YZChessValue chessValueWithChess:p];
                }
                walkRange += [YZChessValue chessWalkRangeWithChessPlace:chessPlace chess:p];
                ATK += [YZChessValue chessAttackWithChessPlace:chessPlace chess:p];
            }else if (p.camp == -camp) {
                badScore += [YZChessValue badStepScoreWithChessPlace:chessPlace chess:p];
            }
        }
    }
//    [self networkPredictionWithChessPlace:chessPlace];
    NSInteger value = chessNum * 3 + walkRange + ATK + chessValue + badScore + badPosition;
    return value;
}


/**
 用来生成可下棋子的位置
 
 @param chessPlace 棋盘
 @return 返回一个包含字典的数组 字典包含 [棋子] [棋子可以下的点]->NSArray
 */
- (NSArray *)createStepsWithChessPlace:(NSArray *)chessPlace {
    NSMutableArray *stepQueen = [[NSMutableArray alloc]init];
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == self.camp) {
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
- (BOOL)chessWillKilledWithChessPlace:(NSArray *)chessPlace {
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


/**
 拿到棋子飞行的位置
 
 @param chessPlace 棋盘
 @param chess 棋子
 @return 返回一个字典 [价值] [棋子] [下棋子的位置] [类型]
 */
- (NSDictionary *)flyStepWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess{
    NSArray *flyStepArray = [YZFlyManager flyManageWithX:chess.x Y:chess.y Camp:chess.camp placeArray:chessPlace.mutableCopy];
    if (flyStepArray.count > 0) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@100 forKey:valueKey];
        [dict setObject:chess forKey:goKey];
        [dict setObject:flyStepArray.firstObject forKey:toKey];
        [dict setObject:stepTypeFly forKey:stepTypeKey];
        return dict.copy;
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
    NSInteger shortTag = goChess.tag;
    NSInteger shortCamp = goChess.camp;
    
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = chessPlace[i][j];
            if (toChess.frameX == p.frameX && toChess.frameY == p.frameY) {
                toChess.tag = shortTag;
                toChess.camp = shortCamp;
                chessPlace[i][j] = toChess;
            }
            if (goChess.frameX == p.frameX && goChess.frameY == p.frameY) {
                goChess.tag = 0;
                goChess.camp = 0;
                chessPlace[i][j] = goChess;
            }
        }
    }
    return chessPlace;
}

@end
