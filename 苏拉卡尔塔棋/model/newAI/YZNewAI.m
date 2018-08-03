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
#import "YZAIStrategy.h"
#import "model.h"

@interface YZNewAI()

@property(nonatomic, assign)BOOL isNeedAgainThink;

@end

@implementation YZNewAI

- (NSDictionary *)stepDataWithChessPlace:(NSArray *)chessPlace {
    self.isNeedAgainThink = false;
    NSDictionary *step = [self stepWithChessPlace:chessPlace];
    if (step.count == 0) {
        self.isNeedAgainThink = true;
        step = [self stepWithChessPlace:chessPlace];
    }
    return step;
}

- (NSDictionary *)stepWithChessPlace:(NSArray *)chessPlace {
    NSInteger chessNum = [YZChessValue chessNumWithChessPlace:chessPlace camp:self.camp];
    NSInteger chessOtherNum = [YZChessValue chessNumWithChessPlace:chessPlace camp:-self.camp];
    if (chessNum <= 6 || chessOtherNum <= 6) {
        self.searchDepth = 5;
    }else {
        self.searchDepth = 3;
    }
    
//    先后手策略
    if (self.isFirst) {
        NSDictionary *d = [YZAIStrategy precedenceStrategyWithChessPlace:chessPlace camp:self.camp stepNum:self.stepNum];
        if (d) {
            if (self.stepNum == 4) {
                self.isNeedAgainThink = true;
            }
            return d;
        }
    }else {
        if (self.stepNum < 3) {
            NSDictionary *d = [YZAIStrategy laterStrategyWithChessPlace:chessPlace camp:self.camp stepNum:self.stepNum];
            if (d) {
                return d;
            }
        }
    }
    
//    常规策略
    NSDictionary *strategyDict = [YZAIStrategy strategyWithChessPlace:chessPlace camp:self.camp];
    if (strategyDict) {
        return strategyDict;
    }
    
//    个别顶点会被吃子时不能挡住的防守点位
    NSArray *willBeEatChess = [self chessWillKilledWithChessPlace:chessPlace];
    NSMutableArray<NSDictionary *> *badPosition = [NSMutableArray array];
    for (YZChessPlace *p in willBeEatChess) {
        [badPosition addObject:[YZAIStrategy chessWillKilledStrategyWithChessPlace:chessPlace chess:p]];
    }
    
//    需要防守的情况只有满12个棋子的时候有效
    NSInteger defendPosition = [YZAIStrategy defendStrategyWithChessPlace:chessPlace camp:self.camp];
    
//    拿到全部可以下子的位置，此处全部可以下子的的数组不包含可吃子的位置
    NSArray *walkArray = [self createStepsWithChessPlace:chessPlace camp:self.camp];
    NSArray *flyArray = [self flyStepWithChessPlace:chessPlace camp:self.camp];
    NSMutableArray *allStepArray = [NSMutableArray arrayWithArray:walkArray];
    [allStepArray addObjectsFromArray:flyArray];
    NSMutableDictionary *stepDict = @{}.mutableCopy;
    NSInteger maxValue = -9999999;
    for (NSDictionary *d in allStepArray) {
        YZChessPlace *goChess = d[goKey];
        YZChessPlace *toChess = nil;
        NSString *type = d[stepTypeKey];
        if (type == stepTypeFly) {
            NSArray *f = d[toKey];
            toChess = f.lastObject;
        }else {
            toChess = d[toKey];
        }
        
        if (defendPosition != -1 && chessNum == 12) {
            if ([YZAIStrategy isNeedDefendWithPosition:defendPosition x:toChess.x y:toChess.y]) {
                continue;
            }
        }
        
        if (!self.isNeedAgainThink) {
            for (NSDictionary *badD in badPosition) {
                NSInteger badX = [badD[@"x"] integerValue];
                NSInteger badY = [badD[@"y"] integerValue];
                if (toChess.x == badX && toChess.y == badY) {
                    continue;
                }
            }
        }
        
        chessPlace = [self stepWithChess:goChess toChess:toChess chessPlace:chessPlace];
//        如果不是一定会被吃子，模拟下子的位置会被吃，放弃
        if (!self.isNeedAgainThink && type == stepTypeWalk) {
            if ([self isChessWillKilledWithChessPlace:chessPlace from:goChess to:toChess]) {
                chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace];
                continue;
            }
        }
        
        if ((toChess.x == 0 && toChess.y == 0) || (toChess.x == 0 && toChess.y == 5) || (toChess.x == 5 && toChess.y == 0) || (toChess.x == 5 && toChess.y == 5)) {
            chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace];
            continue;
        }
        
        NSMutableArray *shortPlace = [self newChessPlace:chessPlace];
        NSInteger value = [self alphaBetaSearchWithDepth:self.searchDepth alpha:-20000 beta:20000 camp:-self.camp chessPlace:shortPlace.copy];
        
        NSInteger angleScore = [YZChessValue angleNeedPerchWithChessPlace:chessPlace camp:self.camp];
        value += angleScore * 2;
        
        if ((goChess.x == 0 && goChess.y == 0) || (goChess.x == 0 && goChess.y == 5) || (goChess.x == 5 && goChess.y == 0) || (goChess.x == 5 && goChess.y == 5)) {
            value += 50;
        }
        if (type == stepTypeFly) {
            value += 100;
        }
        
        if (self.stepNum < 3) {
            if (self.camp == -1) {
                if (goChess.x == 1 && toChess.x == 2 && toChess.y == 2) {
                    value += 50;
                }
                if (goChess.x == 1 && toChess.x == 2 && toChess.y == 3) {
                    value += 50;
                }
            }else {
                if (goChess.x == 4 && toChess.x == 3 && toChess.y == 2) {
                    value += 50;
                }
                if (goChess.x == 4 && toChess.x == 3 && toChess.y == 3) {
                    value += 50;
                }
            }
        }
        
        NSLog(@"%ld,%ld->%ld,%ld value:%ld",goChess.x,goChess.y,toChess.x,toChess.y,value);
        
        chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace];
    
        if (value > maxValue) {
            maxValue = value;
            [stepDict setObject:[NSNumber numberWithInteger:value] forKey:valueKey];
            [stepDict setObject:goChess forKey:goKey];
            if (type == stepTypeFly) {
                [stepDict setObject:d[toKey] forKey:toKey];
                [stepDict setObject:stepTypeFly forKey:stepTypeKey];
            }else {
                [stepDict setObject:toChess forKey:toKey];
                [stepDict setObject:stepTypeWalk forKey:stepTypeKey];
            }
        }
    }
    NSLog(@"————————————————");
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
        NSInteger value = -[self alphaBetaSearchWithDepth:depth - 1 alpha:-beta beta:-alpha camp:-camp chessPlace:chessPlace];
        chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace];
        if (value > alpha) {
            alpha = value;
        }
        if (value >= beta) {
            return beta;
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
    NSInteger chessOtherNum = [YZChessValue chessNumWithChessPlace:chessPlace camp:-self.camp];
//    占位角分数
    NSInteger angleScore = [YZChessValue angleNeedPerchWithChessPlace:chessPlace camp:camp];
//    可吃子得分
    NSInteger killScore = 0;
    
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                if (chessNum <= 6 || chessOtherNum <= 6) {
                    //                    进入残局
                    chessValue += [YZChessValue chessEndingValueWithChess:p];
                }else {
                    chessValue += [YZChessValue chessValueWithChess:p];
                }
                walkRange += [YZChessValue chessWalkRangeWithChessPlace:chessPlace chess:p];
                ATK += [YZChessValue chessAttackWithChessPlace:chessPlace chess:p];
                killScore += [YZChessValue chessWillKillWithChessPlace:chessPlace camp:camp];
            }
        }
    }
    NSInteger value = chessNum * 6 + walkRange * 2 + ATK + chessValue + killScore + angleScore;
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
                    [dict setObject:stepTypeWalk forKey:stepTypeKey];
                    [stepQueen addObject:dict.copy];
                }
            }
        }
    }
    return stepQueen.copy;
}


/**
 用来生成可吃子的位置

 @param chessPlace 棋盘
 @param camp 阵营
 @return 飞行数组
 */
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
                        [dict setObject:stepTypeFly forKey:stepTypeKey];
                        [stepQueen addObject:dict.copy];
                    }
                }
            }
        }
    }
    return stepQueen.copy;
}


/**
 棋子会不会被吃

 @param chessPlace 棋盘
 @return 被吃的棋子
 */
- (NSArray *)chessWillKilledWithChessPlace:(NSArray *)chessPlace {
    NSMutableArray *fly = [NSMutableArray array];
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == -self.camp) {
                NSArray *flyArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                for (NSArray *f in flyArray) {
                    [fly addObject:f.lastObject];
                }
            }
        }
    }
    return fly.copy;
}


/**
 棋子会不会被吃

 @param chessPlace 棋盘
 @param from 棋子
 @param to 棋子
 @return 是否被吃
 */
- (BOOL)isChessWillKilledWithChessPlace:(NSArray *)chessPlace from:(YZChessPlace *)from to:(YZChessPlace *)to {
    if ((from.x == 0 && from.y == 0) || (from.x == 0 && from.y == 5) || (from.x == 5 && from.y == 0) || (from.x == 5 && from.y == 5)) {
        return false;
    }
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == -self.camp) {
                NSArray *flyArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (flyArray.count > 0) {
                    for (NSArray *fly in flyArray) {
                        YZChessPlace *f = fly.lastObject;
                        if (f.tag == to.tag) {
                            NSMutableArray *newChessPlace = [self newChessPlace:chessPlace];
                            newChessPlace = [[self stepWithChess:p toChess:f chessPlace:newChessPlace] mutableCopy];
                            NSArray *steps = [self createFlyStepWithChessPlace:newChessPlace camp:self.camp];
                            for (NSDictionary *d in steps) {
                                YZChessPlace *goChess = d[goKey];
                                if (goChess.tag == from.tag) {
                                    newChessPlace = [[self stepWithChess:f toChess:p chessPlace:newChessPlace] mutableCopy];
                                    return false;
                                }
                            }
                            newChessPlace = [[self stepWithChess:f toChess:p chessPlace:newChessPlace] mutableCopy];
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
 @return 返回一个飞行数组
 */
- (NSArray<NSDictionary *> *)flyStepWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    NSMutableArray *flyArray = [NSMutableArray array];
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                NSArray *flyStepArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (flyStepArray.count > 0) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:p forKey:goKey];
                    [dict setObject:flyStepArray.firstObject forKey:toKey];
                    [dict setObject:stepTypeFly forKey:stepTypeKey];
                    [flyArray addObject:dict.copy];
                }
            }
        }
    }
    return flyArray;
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


/**
 深拷贝一个新的棋盘

 @param chessPlace 棋盘
 @return 新棋盘
 */
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
