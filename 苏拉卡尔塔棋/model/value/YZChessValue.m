//
//  YZChessValue.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/6/5.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZChessValue.h"
#import "YZChessPlace.h"
#import "YZWalkManager.h"
#import "YZFlyManager.h"

@implementation YZChessValue

+ (NSInteger)chessValueWithChess:(YZChessPlace *)chess {
    NSInteger x = chess.x;
    NSInteger y = chess.y;
    switch (x) {
        case 0:{
            if (y == 0 || y == 5) {
                return -20;
            }else {
                return 10;
            }
            break;
        }
        case 1:{
            if (y == 0 || y == 5) {
                return 10;
            }
            if (y == 1 || y == 4) {
                return 30;
            }
            if (y == 2 || y == 3) {
                return 25;
            }
            break;
        }
        case 2:{
            if (y == 0 || y == 5) {
                return 10;
            }
            if (y == 1 || y == 4) {
                return 25;
            }
            if (y == 2 || y == 3) {
                return 30;
            }
            break;
        }
        case 3:{
            if (y == 0 || y == 5) {
                return 10;
            }
            if (y == 1 || y == 4) {
                return 25;
            }
            if (y == 2 || y == 3) {
                return 30;
            }
            break;
        }
        case 4:{
            if (y == 0 || y == 5) {
                return 10;
            }
            if (y == 1 || y == 4) {
                return 30;
            }
            if (y == 2 || y == 3) {
                return 25;
            }
            break;
        }
        case 5:{
            if (y == 0 || y == 5) {
                return -20;
            }else {
                return 10;
            }
            break;
        }
        default:
            break;
    }
    return 0;
}

+ (NSInteger)chessEndingValueWithChess:(YZChessPlace *)chess {
    NSInteger x = chess.x;
    NSInteger y = chess.y;
    switch (x) {
        case 0:{
            if (y == 0 || y == 5) {
                return -50;
            }else {
                return 20;
            }
            break;
        }
        case 1:{
            if (y == 0 || y == 5) {
                return 20;
            }
            if (y == 1 || y == 4) {
                return 30;
            }
            if (y == 2 || y == 3) {
                return 40;
            }
            break;
        }
        case 2:{
            if (y == 0 || y == 5) {
                return 20;
            }
            if (y == 1 || y == 4) {
                return 40;
            }
            if (y == 2 || y == 3) {
                return 30;
            }
            break;
        }
        case 3:{
            if (y == 0 || y == 5) {
                return 20;
            }
            if (y == 1 || y == 4) {
                return 40;
            }
            if (y == 2 || y == 3) {
                return 30;
            }
            break;
        }
        case 4:{
            if (y == 0 || y == 5) {
                return 20;
            }
            if (y == 1 || y == 4) {
                return 30;
            }
            if (y == 2 || y == 3) {
                return 40;
            }
            break;
        }
        case 5:{
            if (y == 0 || y == 5) {
                return -50;
            }else {
                return 20;
            }
            break;
        }
        default:
            break;
    }
    return 0;
}

+ (NSInteger)chessNumWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    NSInteger num = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = chessPlace[i][j];
            if (p.camp == camp) {
                num++;
            }
        }
    }
    return num;
}

+ (NSInteger)chessWalkRangeWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess {
    return [YZWalkManager walkEngine:chess.x Y:chess.y previousArray:chessPlace].count;
}

+ (NSInteger)badStepScoreWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess {
    NSArray *flyStepArray = [YZFlyManager flyManageWithX:chess.x Y:chess.y Camp:chess.camp placeArray:chessPlace.mutableCopy];
    return -(flyStepArray.count * 1000);
}

+ (NSInteger)badPositionWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    NSInteger badScore = 0;
    NSArray *firstArray = @[chessPlace[1][2],
                       chessPlace[1][3],
                       chessPlace[2][1],
                       chessPlace[2][4],
                       chessPlace[3][1],
                       chessPlace[3][4],
                       chessPlace[4][2],
                       chessPlace[4][3]];
    NSArray *secondArray = @[chessPlace[0][0],
                             chessPlace[0][5],
                             chessPlace[5][0],
                             chessPlace[5][5]];
    for (YZChessPlace *p in firstArray) {
        if (p.camp != camp) {
            badScore -= 30;
        }
    }
    for (YZChessPlace *p in secondArray) {
        if (p.camp == camp) {
            badScore -= 30;
        }
    }
    
    return badScore;
}

+ (NSInteger)chessAttackWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess; {
    NSArray *firstArray = @[chessPlace[1][2],
                       chessPlace[1][3],
                       chessPlace[2][1],
                       chessPlace[2][4],
                       chessPlace[3][1],
                       chessPlace[3][4],
                       chessPlace[4][2],
                       chessPlace[4][3]];
    NSArray *secondArray = @[chessPlace[1][1],
                             chessPlace[1][4],
                             chessPlace[4][1],
                             chessPlace[4][4]];
    NSInteger atk = 0;
    for (YZChessPlace *p in firstArray) {
        if (chess.tag == p.tag) {
            atk += 15;
        }
    }
    for (YZChessPlace *p in secondArray) {
        if (chess.tag == p.tag) {
            atk += 10;
        }
    }
    return atk;
}

@end
