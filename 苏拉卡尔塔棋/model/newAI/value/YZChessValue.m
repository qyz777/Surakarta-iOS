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

+ (NSInteger)chessFirstValueWithChess:(YZChessPlace *)chess {
    NSInteger x = chess.x;
    NSInteger y = chess.y;
    NSInteger camp = chess.camp;
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
                return 50;
            }
            if (y == 2 || y == 3) {
                return 25;
            }
            break;
        }
        case 2:{
            if (camp == -1) {
                if (y == 0 || y == 5) {
                    return 30;
                }
                if (y == 1 || y == 4) {
                    return 15;
                }
                if (y == 2 || y == 3) {
                    return 50;
                }
            }else {
                if (y == 0 || y == 5) {
                    return 20;
                }
                if (y == 1 || y == 4) {
                    return 10;
                }
                if (y == 2 || y == 3) {
                    return 30;
                }
            }
            break;
        }
        case 3:{
            if (camp == 1) {
                if (y == 0 || y == 5) {
                    return 30;
                }
                if (y == 1 || y == 4) {
                    return 15;
                }
                if (y == 2 || y == 3) {
                    return 50;
                }
            }else {
                if (y == 0 || y == 5) {
                    return 20;
                }
                if (y == 1 || y == 4) {
                    return 10;
                }
                if (y == 2 || y == 3) {
                    return 30;
                }
            }
            break;
        }
        case 4:{
            if (y == 0 || y == 5) {
                return 10;
            }
            if (y == 1 || y == 4) {
                return 50;
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

+ (NSInteger)chessValueWithChess:(YZChessPlace *)chess {
    NSInteger x = chess.x;
    NSInteger y = chess.y;
    switch (x) {
        case 0:{
            if (y == 0 || y == 5) {
                return 10;
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
                return 10;
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
                return -10;
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
                return 40;
            }
            if (y == 2 || y == 3) {
                return 30;
            }
            break;
        }
        case 2:{
            if (y == 0 || y == 5) {
                return 15;
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
                return 15;
            }
            if (y == 1 || y == 4) {
                return 40;
            }
            if (y == 2 || y == 3) {
                return 30;
            }
            break;
        }
        case 5:{
            if (y == 0 || y == 5) {
                return -10;
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

+ (NSInteger)chessWillKillWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    for (NSArray *array in chessPlace) {
        for (YZChessPlace *p in array) {
            if (p.camp == camp) {
                NSArray *flyArray = [YZFlyManager flyManageWithX:p.x Y:p.y Camp:p.camp placeArray:chessPlace.mutableCopy];
                if (flyArray.count > 0) {
                    return flyArray.count * 100;
                }
            }
        }
    }
    return 0;
}

+ (NSInteger)angleNeedPerchWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
//    角的三个是对方的，需要卡住中间那个位置
    if (camp == -1) {
        YZChessPlace *p1 = chessPlace[0][0];
        YZChessPlace *p2 = chessPlace[0][1];
        YZChessPlace *p3 = chessPlace[1][0];
        YZChessPlace *p4 = chessPlace[1][1];
        YZChessPlace *p5 = chessPlace[0][5];
        YZChessPlace *p6 = chessPlace[0][4];
        YZChessPlace *p7 = chessPlace[1][5];
        YZChessPlace *p8 = chessPlace[1][4];
        if (p1.camp == -camp && p2.camp == -camp && p3.camp == -camp && p4.camp == 0) {
            return 1;
        }
        if (p5.camp == -camp && p6.camp == -camp && p7.camp == -camp && p8.camp == 0) {
            return 2;
        }
    }
    if (camp == 1) {
        YZChessPlace *p1 = chessPlace[5][0];
        YZChessPlace *p2 = chessPlace[5][1];
        YZChessPlace *p3 = chessPlace[4][0];
        YZChessPlace *p4 = chessPlace[4][1];
        YZChessPlace *p5 = chessPlace[5][5];
        YZChessPlace *p6 = chessPlace[5][4];
        YZChessPlace *p7 = chessPlace[4][5];
        YZChessPlace *p8 = chessPlace[4][4];
        if (p1.camp == -camp && p2.camp == -camp && p3.camp == -camp && p4.camp == 0) {
            return 3;
        }
        if (p5.camp == -camp && p6.camp == -camp && p7.camp == -camp && p8.camp == 0) {
            return 4;
        }
    }
    return -1;
}

+ (NSInteger)anglePostionValueWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess angle:(NSInteger)angle {
    NSInteger x = chess.x;
    NSInteger y = chess.y;
    switch (x) {
        case 0:{
            if (y == 0 || y == 5) {
                return 10;
            }else {
                return 20;
            }
            break;
        }
        case 1:{
            if (y == 0 || y == 5) {
                return 20;
            }
            if (y == 1) {
                if (angle == 1) {
                    return 100;
                }else {
                    return 30;
                }
            }
            if (y == 4) {
                if (angle == 2) {
                    return 100;
                }else {
                    return 30;
                }
            }
            if (y == 2 || y == 3) {
                return 30;
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
            if (y == 1) {
                if (angle == 3) {
                    return 100;
                }else {
                    return 30;
                }
            }
            if (y == 4) {
                if (angle == 4) {
                    return 100;
                }else {
                    return 30;
                }
            }
            if (y == 2 || y == 3) {
                return 30;
            }
            break;
        }
        case 5:{
            if (y == 0 || y == 5) {
                return 10;
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

// TODO:修改
+ (NSInteger)endingPostionValueWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    NSInteger score = 0;
    if (camp == -1) {
        YZChessPlace *p1 = chessPlace[0][0];
        YZChessPlace *p2 = chessPlace[0][5];
        if (p1.camp == camp) {
            score -= 25;
        }
        if (p2.camp == camp) {
            score -= 25;
        }
    }
    if (camp == 1) {
        YZChessPlace *p1 = chessPlace[5][0];
        YZChessPlace *p2 = chessPlace[5][5];
        if (p1.camp == camp) {
            score -= 25;
        }
        if (p2.camp == camp) {
            score -= 25;
        }
    }
    return score;
}

@end
