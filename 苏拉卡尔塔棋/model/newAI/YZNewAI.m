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

NSString const *stepArrayKey = @"stepArrayKey";
NSString const *goKey = @"goKey";
NSString const *toKey = @"toKey";
NSString const *valueKey = @"valueKey";
NSString const *stepTypeKey = @"stepTypeKey";
NSString const *stepTypeWalk = @"stepTypeWalk";
NSString const *stepTypeFly = @"stepTypeFly";

@implementation YZNewAI

- (NSDictionary *)stepDataWithChessPlace:(NSArray *)chessPlace {
    return [self stepWithChessPlace:chessPlace];
}

- (NSDictionary *)stepWithChessPlace:(NSArray *)chessPlace {
//    拿到全部可以下子的位置，此处全部可以下子的的数组不包含可吃子的位置
    NSArray *allStepArray = [self createStepsWithChessPlace:chessPlace];
    NSMutableDictionary *stepDict = @{}.mutableCopy;
    NSInteger maxValue = 0;
    for (NSDictionary *d in allStepArray) {
        YZChessPlace *goChess = d[goKey];
        YZChessPlace *toChess = d[toKey];
        NSDictionary *flyDict = [self flyStepWithChessPlace:chessPlace chess:goChess];
        if (flyDict) {
            return flyDict;
        }
        chessPlace = [self stepWithChess:goChess toChess:toChess chessPlace:chessPlace.copy];
        NSInteger value = [self alphaBetaSearchWithDepth:3 alpha:-20000 beta:20000 camp:_camp chessPlace:chessPlace.copy];
        chessPlace = [self stepWithChess:toChess toChess:goChess chessPlace:chessPlace.copy];
        if (value > maxValue) {
            maxValue = value;
            [stepDict setObject:[NSNumber numberWithInteger:value] forKey:valueKey];
            [stepDict setObject:goChess forKey:goKey];
            [stepDict setObject:toChess forKey:toKey];
            [stepDict setObject:stepTypeWalk forKey:stepTypeKey];
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
        NSInteger value = [self alphaBetaSearchWithDepth:depth - 1 alpha:-20000 beta:20000 camp:camp chessPlace:chessPlace.copy];
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
    NSInteger chessValue = 0;
    NSInteger walkRange = 0;
    NSInteger ATK = 0;
    NSInteger chessNum = [YZChessPlace chessNumWithChessPlace:chessPlace Camp:camp];
    NSInteger shortChessNum = [YZChessPlace chessNumWithChessPlace:chessPlace Camp:-camp];
    NSInteger willKilledNum = 0;
    
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                if (chessNum + shortChessNum <= 12 && chessNum <= 6 && shortChessNum <= 6) {
                    chessValue += [YZChessPlace chessEndingValueWith:p.x Y:p.y];
                }else {
                    chessValue += [YZChessPlace chessValueWithX:p.x Y:p.y];
                }
                walkRange += [YZChessPlace chessWalkRangeWithChessPlace:chessPlace X:p.x Y:p.y];
                ATK += [YZChessPlace chessAttackRangeWithChessPlace:chessPlace X:p.x Y:p.y Camp:camp];
                willKilledNum += [self willKilledChessNumWithChessPlace:chessPlace chess:p];
            }
        }
    }
    
    return chessNum * 6 + walkRange + ATK * 2 + chessValue - willKilledNum * 10;
}


/**
 用来生成可下棋子的位置
 
 @param chessPlace 棋盘
 @return 返回一个包含字典的数组 字典包含 [棋子] [棋子可以下的点]->NSArray
 */
- (NSArray *)createStepsWithChessPlace:(NSArray *)chessPlace {
    NSMutableArray *stepQueen = [[NSMutableArray alloc]init];
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = chessPlace[i][j];
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


/**
 获得会被吃子的棋子数量

 @param chessPlace 棋盘
 @param chess 棋子
 @return 被吃子数量
 */
- (NSInteger)willKilledChessNumWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess {
    NSArray *flyStepArray = [YZFlyManager flyManageWithX:chess.x Y:chess.y Camp:chess.camp placeArray:chessPlace.mutableCopy];
    return flyStepArray.count;
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
