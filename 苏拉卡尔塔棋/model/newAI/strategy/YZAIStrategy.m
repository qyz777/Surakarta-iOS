//
//  YZAIStrategy.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/7/6.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZAIStrategy.h"

@implementation YZAIStrategy

+ (NSDictionary *)precedenceStrategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp stepNum:(NSInteger)stepNum {
    if (camp == -1) {
        if (stepNum == 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[1][1] forKey:goKey];
            [dict setObject:chessPlace[2][2] forKey:toKey];
            return dict.copy;
        }
        if (stepNum == 1) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[1][0] forKey:goKey];
            [dict setObject:chessPlace[2][0] forKey:toKey];
            return dict.copy;
        }
        if (stepNum == 2) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[0][1] forKey:goKey];
            [dict setObject:chessPlace[1][1] forKey:toKey];
            return dict.copy;
        }
    }else {
        if (stepNum == 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[4][1] forKey:goKey];
            [dict setObject:chessPlace[3][2] forKey:toKey];
            return dict.copy;
        }
        if (stepNum == 1) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[4][0] forKey:goKey];
            [dict setObject:chessPlace[3][0] forKey:toKey];
            return dict.copy;
        }
        if (stepNum == 2) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:chessPlace[5][1] forKey:goKey];
            [dict setObject:chessPlace[4][1] forKey:toKey];
            return dict.copy;
        }
    }
    return nil;
}

+ (NSDictionary *)laterStrategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp stepNum:(NSInteger)stepNum {
    if (camp == -1) {
        if (stepNum == 0) {
            YZChessPlace *p1 = chessPlace[3][0];
            YZChessPlace *p2 = chessPlace[3][2];
            if (p1.camp == 1 || p2.camp == 1) {
                YZChessPlace *toP = chessPlace[2][2];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][1] forKey:goKey];
                [dict setObject:toP forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
            YZChessPlace *p3 = chessPlace[3][5];
            YZChessPlace *p4 = chessPlace[3][3];
            if (p3.camp == 1 || p4.camp == 1) {
                YZChessPlace *toP = chessPlace[2][3];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][4] forKey:goKey];
                [dict setObject:chessPlace[2][3] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
        }
        if (stepNum == 1) {
            YZChessPlace *p1 = chessPlace[3][0];
            YZChessPlace *p2 = chessPlace[3][2];
            if (p1.camp == 1 && p2.camp == 1) {
                YZChessPlace *toP = chessPlace[2][1];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][0] forKey:goKey];
                [dict setObject:chessPlace[2][1] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
            YZChessPlace *p3 = chessPlace[3][5];
            YZChessPlace *p4 = chessPlace[3][3];
            if (p3.camp == 1 && p4.camp == 1) {
                YZChessPlace *toP = chessPlace[2][4];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][5] forKey:goKey];
                [dict setObject:chessPlace[2][4] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
        }
        if (stepNum == 2) {
            YZChessPlace *p1 = chessPlace[4][1];
            YZChessPlace *p2 = chessPlace[4][4];
            YZChessPlace *p3 = chessPlace[5][1];
            YZChessPlace *p4 = chessPlace[5][4];
            if (p1.camp == 1 && p3.camp == 0) {
                YZChessPlace *toP = chessPlace[1][1];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[0][1] forKey:goKey];
                [dict setObject:chessPlace[1][1] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
            if (p2.camp == 1 && p4.camp == 0) {
                YZChessPlace *toP = chessPlace[1][4];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[0][4] forKey:goKey];
                [dict setObject:chessPlace[1][4] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
        }
    }else {
        if (stepNum == 0) {
            YZChessPlace *p1 = chessPlace[2][0];
            YZChessPlace *p2 = chessPlace[2][2];
            if (p1.camp == -1 || p2.camp == -1) {
                YZChessPlace *toP = chessPlace[3][2];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][1] forKey:goKey];
                [dict setObject:chessPlace[3][2] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
            YZChessPlace *p3 = chessPlace[2][5];
            YZChessPlace *p4 = chessPlace[2][3];
            if (p3.camp == -1 || p4.camp == -1) {
                YZChessPlace *toP = chessPlace[3][3];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][4] forKey:goKey];
                [dict setObject:chessPlace[3][3] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
        }
        if (stepNum == 1) {
            YZChessPlace *p1 = chessPlace[2][0];
            YZChessPlace *p2 = chessPlace[2][2];
            if (p1.camp == -1 && p2.camp == -1) {
                YZChessPlace *toP = chessPlace[3][1];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][0] forKey:goKey];
                [dict setObject:chessPlace[3][1] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
            YZChessPlace *p3 = chessPlace[2][5];
            YZChessPlace *p4 = chessPlace[2][3];
            if (p3.camp == -1 && p4.camp == -1) {
                YZChessPlace *toP = chessPlace[3][4];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][5] forKey:goKey];
                [dict setObject:chessPlace[3][4] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
        }
        if (stepNum == 2) {
            YZChessPlace *p1 = chessPlace[1][1];
            YZChessPlace *p2 = chessPlace[1][4];
            YZChessPlace *p3 = chessPlace[0][1];
            YZChessPlace *p4 = chessPlace[0][4];
            if (p1.camp == -1 && p3.camp == 0) {
                YZChessPlace *toP = chessPlace[4][1];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[5][1] forKey:goKey];
                [dict setObject:chessPlace[4][1] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
            if (p2.camp == -1 && p4.camp == 0) {
                YZChessPlace *toP = chessPlace[4][4];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[5][4] forKey:goKey];
                [dict setObject:chessPlace[4][4] forKey:toKey];
                if (toP.camp == 0) {
                    return dict.copy;
                }
            }
        }
    }
    return nil;
}

@end
