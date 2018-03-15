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

@implementation YZNormalAI

- (NSDictionary*)dictWithChessPlace:(NSArray*)chessPlace{
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
    NSMutableArray *flyArray = [[NSMutableArray alloc]init];
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
            if (p.camp == 1) {
                [flyArray addObject:[YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:place.mutableCopy]];
            }
        }
    }
    for (int k=0; k<finishArray.count; k++) {
        NSDictionary *d = finishArray[k];
        NSNumber *valueNumberOne = d[@"value"];
        for (int q=k; q<finishArray.count; q++) {
            NSDictionary *dd = finishArray[q];
            NSNumber *valueNumberTwo = dd[@"value"];
            if (valueNumberOne < valueNumberTwo) {
                NSDictionary *temp = finishArray[k];
                finishArray[k] = finishArray[q];
                finishArray[q] = temp;
            }
        }
    }
    if (finishArray.count > 0) {
        NSDictionary *d = finishArray[0];
        YZChessPlace *p = d[@"goWhere"];
        for (NSArray *array in flyArray) {
            for (YZChessPlace *pp in array) {
                if (p.x == pp.x && p.y == pp.y) {
                    if (finishArray.count > 1) {
                        return finishArray[1];
                    }
                }
            }
        }
        return finishArray[0];
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

- (NSDictionary*)getWalkStepWithChessPlace:(NSArray*)chessPlace{
    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    NSArray *allWalkArray = [self createMovesWithChessPlace:chessPlace.copy Camp:-1];
    
    for (NSDictionary *d in allWalkArray) {
        for (YZChessPlace *canMove in d[@"walkArray"]) {
            YZChessPlace *tread = [self getTreadWithChessPlace:chessPlace.copy Point:canMove Camp:-1];
            chessPlace = [self goWithChess:tread toChess:canMove chessPlace:chessPlace.copy];
            NSInteger value = [self alphaBetaSearchWithDepth:3 alpha:-40000 beta:40000 camp:-1 chessPlace:chessPlace.copy];
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
        return maxDict;
    }
    return nil;
}

#pragma make - α-β Search
- (NSInteger)alphaBetaSearchWithDepth:(NSInteger)depth alpha:(NSInteger)alpha beta:(NSInteger)beta camp:(NSInteger)camp chessPlace:(NSArray*)place{
    if (depth <= 0) {
        return [self getValueWithChessPlace:place camp:camp] - [self getValueWithChessPlace:place camp:-camp];
    }
    
    NSArray *allWalkArray = [self createMovesWithChessPlace:place.copy Camp:camp];
    for (NSDictionary *d in allWalkArray) {
        for (YZChessPlace *canMove in d[@"walkArray"]) {
            YZChessPlace *tread = [self getTreadWithChessPlace:place.copy Point:canMove Camp:camp];
            place = [self goWithChess:tread toChess:canMove chessPlace:place.copy];
            NSInteger value = - [self alphaBetaSearchWithDepth:depth - 1 alpha:-beta beta:-alpha camp:-camp chessPlace:place];
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

- (NSArray*)createMovesWithChessPlace:(NSArray*)chessPlace Camp:(NSInteger)camp{
    NSMutableArray *array = [[NSMutableArray alloc]init];
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
    NSSet *set = [NSSet setWithArray:array];
    return [set allObjects];
}

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

- (NSInteger)getValueWithChessPlace:(NSArray*)place camp:(NSInteger) camp{
    NSInteger chessValue = 0;
    NSInteger walkRange = 0;
    NSInteger ATK = 0;
    NSInteger chessNum = [YZChessPlace chessNumWithChessPlace:place Camp:camp];
    
    for (NSArray *array in place) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                if (chessNum <= 12) {
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

- (NSArray*)goWithChess:(YZChessPlace*)goChess toChess:(YZChessPlace*)toChess chessPlace:(NSArray*)chessPlace{
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
