//
//  YZNormalAI.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/3/12.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZNormalAI.h"
#import "YZChessPlace.h"
#import "YZWalkManager.h"
#import "YZFlyManager.h"
#import "YZNormalAITactics.h"

@interface YZNormalAI ()

@property(assign,nonatomic)BOOL isEnding;
@property(assign,nonatomic)NSInteger searchDepth;

@end

@implementation YZNormalAI

- (instancetype)init{
    self = [super init];
    self.isEnding = false;
    self.searchDepth = 2;
    return self;
}

- (NSDictionary*)dictWithChessPlace:(NSArray*)chessPlace StepNum:(NSInteger)num{
//    战术
    if (num <= 3 && [self canBeEatenWithChessPlace:chessPlace Camp:-1] == 0) {
        NSDictionary *tactics = [YZNormalAITactics openingTacticsWithChessPlace:chessPlace StepNum:num];
        YZChessPlace *goWhere = tactics[@"goWhere"];
        YZChessPlace *point = chessPlace[1][4];
        if (goWhere.camp == 0) {
            if (num < 3) {
                return tactics;
            }else {
                if (point.tag > 0) {
                    return tactics;
                }
            }
        }
    }
    
    NSInteger chessNum = [YZChessPlace chessNumWithChessPlace:chessPlace Camp:-1];
    if (chessNum <= 8) {
        self.isEnding = true;
        self.searchDepth = 3;
    }
    if (chessNum <= 4) {
        self.searchDepth = 4;
    }
    
    NSDictionary *maxFlyDict;
    NSInteger maxFlyValue = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = chessPlace[i][j];
            if (p.camp == -1) {
                NSDictionary *dict = [self getFlyStepWithChessPlace:chessPlace Chess:p];
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"fly"]) {
                    NSNumber *number = dict[@"value"];
                    NSInteger value = [number integerValue];
                    if (maxFlyValue < value) {
                        maxFlyValue = value;
                        maxFlyDict = dict;
                    }
                }
            }
        }
    }
    
    if (maxFlyDict.count > 0) {
        return maxFlyDict;
    }else {
        NSDictionary *walkDict = [self getWalkStepWithChessPlace:chessPlace.copy];
        if (walkDict) {
            YZChessPlace *p = walkDict[@"whoGo"];
            if (p.tag > 12) {
//                调到了玩家的棋子，是个bug
                return [self getExtraWalkWithChessPlace:chessPlace];
            }else {
                return walkDict;
            }
        }else {
            return [self getExtraWalkWithChessPlace:chessPlace];
        }
    }
    return nil;
}

//搜索站局面最佳状态导致无子可走所用方法
- (NSDictionary*)getExtraWalkWithChessPlace:(NSArray*)place{
    NSMutableArray *finishArray = [[NSMutableArray alloc]init];
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = place[i][j];
            if (p.camp == -1) {
                NSMutableDictionary *dict = [self getExtraWalkDictWithChessPlace:place Chess:p];
                if (dict) {
                    [dict setObject:p forKey:@"whoGo"];
                    [finishArray addObject:dict];
                }
            }
        }
    }
    for (int k=0; k<finishArray.count; k++) {
        for (int q=0; q<finishArray.count - 1 - k; q++) {
            NSDictionary *d = finishArray[q];
            NSNumber *valueNumberOne = d[@"value"];
            NSDictionary *dd = finishArray[q+1];
            NSNumber *valueNumberTwo = dd[@"value"];
            if (valueNumberOne < valueNumberTwo) {
                NSDictionary *temp = finishArray[q+1];
                finishArray[q+1] = finishArray[q];
                finishArray[q] = temp;
            }
        }
    }
    if (finishArray.count > 0) {
        int num = 0;
        for (NSDictionary *d in finishArray) {
            YZChessPlace *whoGo = d[@"whoGo"];
            YZChessPlace *goWhere = d[@"goWhere"];
            place = [self goWithChess:whoGo toChess:goWhere chessPlace:place.copy];
            if ([self canBeEatenWithChessPlace:place Camp:-1] > 2) {
                place = [self goWithChess:goWhere toChess:whoGo chessPlace:place.copy];
                num ++;
                continue;
            }
            place = [self goWithChess:goWhere toChess:whoGo chessPlace:place.copy];
        }
        if (num == finishArray.count) {
            return finishArray[0];
        }else {
            return finishArray[num];
        }
    }
    return nil;
}

- (NSMutableDictionary*)getExtraWalkDictWithChessPlace:(NSArray*)place Chess:(YZChessPlace*)chess{
    NSArray *walkArray = [YZWalkManager walkEngine:chess.x Y:chess.y previousArray:place.copy];
    if (walkArray.count > 0) {
        NSInteger maxValue = 0;
        int maxI = 0;
        for (int i=0; i<walkArray.count; i++) {
            YZChessPlace *shortP = walkArray[i];
            if ([YZChessPlace chessValueWithX:shortP.x Y:shortP.y] > maxValue) {
                maxValue = [YZChessPlace chessValueWithX:shortP.x Y:shortP.y];
                maxI = i;
            }
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:walkArray[maxI] forKey:@"goWhere"];
        [dict setObject:[NSNumber numberWithInteger:maxValue] forKey:@"value"];
        [dict setObject:@"walk" forKey:@"type"];
        return dict;
    }
    return nil;
}


/**
 会不会被敌方棋子吃

 @param chessPlace 棋盘
 @param camp 阵营
 @return 能吃棋子的数量
 */
- (NSInteger)canBeEatenWithChessPlace:(NSArray*)chessPlace Camp:(NSInteger)camp{
    NSInteger count = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = chessPlace[i][j];
            if (p.camp + camp == 0) {
                NSArray *flyArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (flyArray.count > 0) {
                    count++;
                }
            }
        }
    }
    return count;
}


/**
 拿到棋子飞行的位置

 @param chessPlace 棋盘
 @param chess 棋子
 @return 返回一个字典 [价值] [棋子] [下棋子的位置] [类型]
 */
- (NSDictionary*)getFlyStepWithChessPlace:(NSArray*)chessPlace Chess:(YZChessPlace*)chess{
    NSArray *flyArray = [YZFlyManager flyManageWithX:chess.x Y:chess.y Camp:chess.camp placeArray:chessPlace.mutableCopy];
    if (flyArray.count > 0) {
        NSInteger maxValue = 0;
        int maxI = 0;
        for (int i=0; i<flyArray.count; i++) {
            NSArray *shortArray = flyArray[i];
            YZChessPlace *shortP = shortArray.lastObject;
            if ([YZChessPlace chessValueWithX:shortP.x Y:shortP.y] > maxValue) {
                maxValue = [YZChessPlace chessValueWithX:shortP.x Y:shortP.y];
                maxI = i;
            }
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[NSNumber numberWithInteger:maxValue] forKey:@"value"];
        [dict setObject:chess forKey:@"whoGo"];
        [dict setObject:flyArray[maxI] forKey:@"goWhere"];
        [dict setObject:@"fly" forKey:@"type"];
        return dict.copy;
    }
    return nil;
}


/**
 这是一个拿到下子位置的方法，其中用到了α-β搜索策略

 @param chessPlace 棋盘
 @return 返回一个字典 [价值] [棋子] [下棋子的位置] [类型]
 */
- (NSDictionary*)getWalkStepWithChessPlace:(NSArray*)chessPlace{
    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    NSArray *allWalkArray = [self createMovesWithChessPlace:chessPlace.copy Camp:-1];
    
    for (NSDictionary *d in allWalkArray) {
        for (YZChessPlace *canMove in d[@"walkArray"]) {
            YZChessPlace *tread = [self getTreadWithChessPlace:chessPlace.copy Point:canMove Camp:-1];
            chessPlace = [self goWithChess:tread toChess:canMove chessPlace:chessPlace.copy];
            NSInteger value = [self alphaBetaSearchWithDepth:_searchDepth alpha:-20000 beta:20000 Camp:-1 chessPlace:chessPlace.copy];
            chessPlace = [self goWithChess:canMove toChess:tread chessPlace:chessPlace.copy];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithInteger:value] forKey:@"value"];
            [dict setObject:tread forKey:@"whoGo"];
            [dict setObject:canMove forKey:@"goWhere"];
            [dict setObject:@"walk" forKey:@"type"];
            [valueArray addObject:dict.copy];
        }
    }
    NSDictionary *maxDict;
    NSInteger maxValue = 0;
    for (NSDictionary *d in valueArray) {
        NSNumber *valueNumber = d[@"value"];
        NSInteger value = [valueNumber integerValue];
        if (maxValue < value) {
            maxValue = value;
            maxDict = d;
        }
    }
    if (maxDict.count > 0) {
        YZChessPlace *p = chessPlace[0][5];
        YZChessPlace *pp = chessPlace[1][4];
        if (p.camp == -1 && pp.camp == 0) {
            NSMutableDictionary *extraDict = [[NSMutableDictionary alloc]init];
            [extraDict setObject:[NSNumber numberWithInteger:99999] forKey:@"value"];
            [extraDict setObject:p forKey:@"whoGo"];
            [extraDict setObject:pp forKey:@"goWhere"];
            [extraDict setObject:@"walk" forKey:@"type"];
            return extraDict.copy;
        }
        return maxDict;
    }
    return nil;
}

#pragma make - α-β Search
- (NSInteger)alphaBetaSearchWithDepth:(NSInteger)depth alpha:(NSInteger)alpha beta:(NSInteger)beta Camp:(NSInteger)camp chessPlace:(NSArray*)place{
    if (depth <= 0) {
        return [self getValueWithChessPlace:place Camp:camp] - [self getValueWithChessPlace:place Camp:-camp];
    }
    
    NSArray *allWalkArray = [self createMovesWithChessPlace:place.copy Camp:camp];
    for (NSDictionary *d in allWalkArray) {
        for (YZChessPlace *canMove in d[@"walkArray"]) {
            YZChessPlace *tread = [self getTreadWithChessPlace:place.copy Point:canMove Camp:camp];
            place = [self goWithChess:tread toChess:canMove chessPlace:place.copy];
            NSInteger value = - [self alphaBetaSearchWithDepth:depth - 1 alpha:-beta beta:-alpha Camp:-camp chessPlace:place];
            place = [self goWithChess:canMove toChess:tread chessPlace:place.copy];
            if (value > alpha) {
                alpha = value;
            }
            if (value >= beta) {
                break;
            }
        }
    }
    return alpha;
}


/**
 用来生成可下棋子的位置

 @param chessPlace 棋盘
 @param camp 阵营
 @return 返回一个包含字典的数组 字典包含 [棋子] [棋子可以下的点]->NSArray
 */
- (NSArray*)createMovesWithChessPlace:(NSArray*)chessPlace Camp:(NSInteger)camp{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if (self.isEnding) {
        for (int i=5; i>=0; i--) {
            for (int j=5; j>=0; j--) {
                YZChessPlace *p = chessPlace[i][j];
                if (p.camp == camp) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:[YZWalkManager walkEngine:p.x Y:p.y previousArray:chessPlace] forKey:@"walkArray"];
                    [dict setObject:p forKey:@"whoGo"];
                    [array addObject:dict.copy];
                }
            }
        }
    }else {
        for (int i=0; i<6; i++) {
            for (int j=0; j<6; j++) {
                YZChessPlace *p = chessPlace[i][j];
                if (p.camp == camp) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:[YZWalkManager walkEngine:p.x Y:p.y previousArray:chessPlace] forKey:@"walkArray"];
                    [dict setObject:p forKey:@"whoGo"];
                    [array addObject:dict.copy];
                }
            }
        }
    }
    
    NSSet *set = [NSSet setWithArray:array];
    return [set allObjects];
}


/**
 因为有很多个棋子可以下一个位置，所以该方法用来取一个棋子下子

 @param place 棋盘
 @param point 下子位置
 @param camp 阵营
 @return 返回一个棋子
 */
- (YZChessPlace*)getTreadWithChessPlace:(NSArray*)place Point:(YZChessPlace*)point Camp:(NSInteger)camp{
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *tread = place[i][j];
            if (tread.tag > 0) {
                NSArray *walkArray = [YZWalkManager walkEngine:tread.x Y:tread.y previousArray:place];
                for (YZChessPlace *pp in walkArray) {
                    if (point.frameX == pp.frameX && point.frameY == pp.frameY) {
                        return tread;
                    }
                }
            }
        }
    }
    return nil;
}


/**
 评估函数

 @param place 棋盘
 @param camp 阵营
 @return 返回评估值
 */
- (NSInteger)getValueWithChessPlace:(NSArray*)place Camp:(NSInteger) camp{
    NSInteger chessValue = 0;
    NSInteger walkRange = 0;
    NSInteger ATK = 0;
    NSInteger chessNum = [YZChessPlace chessNumWithChessPlace:place Camp:camp];
    NSInteger shortChessNum = [YZChessPlace chessNumWithChessPlace:place Camp:-camp];
    
    for (NSArray *array in place) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                if (chessNum + shortChessNum <= 12 && chessNum <= 6 && shortChessNum <= 6) {
                    chessValue += [YZChessPlace chessEndingValueWith:p.x Y:p.y];
                }else {
                    chessValue += [YZChessPlace chessValueWithX:p.x Y:p.y];
                }
                walkRange += [YZChessPlace chessWalkRangeWithChessPlace:place X:p.x Y:p.y];
                ATK += [YZChessPlace chessAttackRangeWithChessPlace:place X:p.x Y:p.y Camp:camp];
            }
        }
    }
    
    return chessNum * 6 + walkRange + ATK * 2 +chessValue; 
}


/**
 用来模拟下子的方法，可以用来撤回下子

 @param goChess 棋子
 @param toChess 下棋子的位置
 @param chessPlace 棋盘
 @return 返回一个模拟下完棋子的棋盘
 */
- (NSArray*) goWithChess:(YZChessPlace*)goChess toChess:(YZChessPlace*)toChess chessPlace:(NSArray*)chessPlace{
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
