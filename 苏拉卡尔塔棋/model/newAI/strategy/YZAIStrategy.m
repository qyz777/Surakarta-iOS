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
            [dict setObject:chessPlace[0][0] forKey:goKey];
            [dict setObject:chessPlace[1][1] forKey:toKey];
            return dict.copy;
        }
        if (stepNum == 2) {
            YZChessPlace *p23 = chessPlace[2][3];
            YZChessPlace *p12 = chessPlace[1][2];
            if (p23.camp == 0 && p12.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][2] forKey:goKey];
                [dict setObject:chessPlace[2][3] forKey:toKey];
                return dict.copy;
            }
        }
        if (stepNum == 3) {
            YZChessPlace *p20 = chessPlace[2][0];
            if (p20.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[1][0] forKey:goKey];
                [dict setObject:chessPlace[2][0] forKey:toKey];
                return dict.copy;
            }
        }
        if (stepNum == 4) {
            YZChessPlace *p12 = chessPlace[1][2];
            YZChessPlace *p01 = chessPlace[0][1];
            if (p12.camp == 0 && p01.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[0][1] forKey:goKey];
                [dict setObject:chessPlace[1][2] forKey:toKey];
                return dict.copy;
            }
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
            [dict setObject:chessPlace[5][0] forKey:goKey];
            [dict setObject:chessPlace[4][1] forKey:toKey];
            return dict.copy;
        }
        if (stepNum == 2) {
            YZChessPlace *p33 = chessPlace[3][3];
            YZChessPlace *p42 = chessPlace[4][2];
            if (p33.camp == 0 && p42.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][2] forKey:goKey];
                [dict setObject:chessPlace[3][3] forKey:toKey];
                return dict.copy;
            }
        }
        if (stepNum == 3) {
            YZChessPlace *p30 = chessPlace[3][0];
            if (p30.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[4][0] forKey:goKey];
                [dict setObject:chessPlace[3][0] forKey:toKey];
                return dict.copy;
            }
        }
        if (stepNum == 4) {
            YZChessPlace *p42 = chessPlace[4][2];
            YZChessPlace *p51 = chessPlace[5][1];
            if (p42.camp == 0 && p51.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:chessPlace[5][1] forKey:goKey];
                [dict setObject:chessPlace[4][2] forKey:toKey];
                return dict.copy;
            }
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

+ (NSDictionary *)strategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    if (camp == -1) {
        YZChessPlace *p30 = chessPlace[3][0];
        YZChessPlace *p32 = chessPlace[3][2];
        YZChessPlace *p40 = chessPlace[4][0];
        YZChessPlace *p41 = chessPlace[4][1];
        YZChessPlace *p51 = chessPlace[5][1];
        if (p30.camp == 1 && p32.camp == 1 && p40.camp == 0 && p41.camp == 1 && p51.camp == 0) {
            YZChessPlace *p10 = chessPlace[1][0];
            if (p10.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:p10 forKey:goKey];
                [dict setObject:chessPlace[2][1] forKey:toKey];
                return dict.copy;
            }
        }
        YZChessPlace *p35 = chessPlace[3][5];
        YZChessPlace *p33 = chessPlace[3][3];
        YZChessPlace *p45 = chessPlace[4][5];
        YZChessPlace *p44 = chessPlace[4][4];
        YZChessPlace *p54 = chessPlace[5][4];
        if (p35.camp == 1 && p33.camp == 1 && p45.camp == 0 && p44.camp == 1 && p54.camp == 0) {
            YZChessPlace *p15 = chessPlace[1][5];
            if (p15.camp == -1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:p15 forKey:goKey];
                [dict setObject:chessPlace[2][4] forKey:toKey];
                return dict.copy;
            }
        }
    }else {
        YZChessPlace *p20 = chessPlace[2][0];
        YZChessPlace *p22 = chessPlace[2][2];
        YZChessPlace *p10 = chessPlace[1][0];
        YZChessPlace *p11 = chessPlace[1][1];
        YZChessPlace *p01 = chessPlace[0][1];
        if (p20.camp == 1 && p22.camp == 1 && p10.camp == 0 && p11.camp == 1 && p01.camp == 0) {
            YZChessPlace *p40 = chessPlace[4][0];
            if (p40.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:p40 forKey:goKey];
                [dict setObject:chessPlace[3][1] forKey:toKey];
                return dict.copy;
            }
        }
        YZChessPlace *p25 = chessPlace[2][5];
        YZChessPlace *p23 = chessPlace[2][3];
        YZChessPlace *p15 = chessPlace[1][5];
        YZChessPlace *p14 = chessPlace[1][4];
        YZChessPlace *p04 = chessPlace[0][4];
        if (p25.camp == 1 && p23.camp == 1 && p15.camp == 0 && p14.camp == 1 && p04.camp == 0) {
            YZChessPlace *p45 = chessPlace[4][5];
            if (p45.camp == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:p45 forKey:goKey];
                [dict setObject:chessPlace[3][4] forKey:toKey];
                return dict.copy;
            }
        }
    }
    return nil;
}

+ (NSInteger)defendStrategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    if (camp == -1) {
        YZChessPlace *p1 = chessPlace[3][0];
        YZChessPlace *p2 = chessPlace[3][2];
        if (p1.camp == 1 && p2.camp == 1) {
            YZChessPlace *p21 = chessPlace[2][1];
            YZChessPlace *p20 = chessPlace[2][0];
            YZChessPlace *p11 = chessPlace[1][1];
            YZChessPlace *p10 = chessPlace[1][0];
            if (p21.camp == -1 && p20.camp == 0) {
                return 11;
            }
            if (p11.camp == -1 && p10.camp == 0) {
                return 12;
            }
            return -1;
        }
        
        YZChessPlace *p4 = chessPlace[3][3];
        YZChessPlace *p5 = chessPlace[3][5];
        if (p4.camp == 1 && p5.camp == 1) {
            YZChessPlace *p24 = chessPlace[2][4];
            YZChessPlace *p25 = chessPlace[2][0];
            YZChessPlace *p14 = chessPlace[1][4];
            YZChessPlace *p15 = chessPlace[1][5];
            if (p24.camp == -1 && p25.camp == 0) {
                return 21;
            }
            if (p14.camp == -1 && p15.camp == 0) {
                return 22;
            }
            return -1;
        }
    }else {
        YZChessPlace *p1 = chessPlace[2][0];
        YZChessPlace *p2 = chessPlace[2][2];
        if (p1.camp == -1 && p2.camp == -1) {
            YZChessPlace *p31 = chessPlace[3][1];
            YZChessPlace *p30 = chessPlace[3][0];
            YZChessPlace *p41 = chessPlace[4][1];
            YZChessPlace *p40 = chessPlace[4][0];
            if (p31.camp == 1 && p30.camp == 0) {
                return 31;
            }
            if (p41.camp == 1 && p40.camp == 0) {
                return 32;
            }
            return -1;
        }
        
        YZChessPlace *p4 = chessPlace[2][3];
        YZChessPlace *p5 = chessPlace[2][5];
        if (p4.camp == -1 && p5.camp == -1) {
            YZChessPlace *p34 = chessPlace[3][4];
            YZChessPlace *p35 = chessPlace[3][5];
            YZChessPlace *p44 = chessPlace[4][4];
            YZChessPlace *p45 = chessPlace[4][5];
            if (p34.camp == 1 && p35.camp == 0) {
                return 41;
            }
            if (p44.camp == 1 && p45.camp == 0) {
                return 42;
            }
            return -1;
        }
    }
    return -1;
}

+ (BOOL)isNeedDefendWithPosition:(NSInteger)position x:(NSInteger)x y:(NSInteger)y {
    switch (position) {
        case 11:
            if (x == 2 && y == 0) {
                return true;
            }
        case 12:
            if (x == 1 && y == 0) {
                return true;
            }
        case 21:
            if (x == 2 && y == 5) {
                return true;
            }
        case 22:
            if (x == 1 && y == 5) {
                return true;
            }
        case 31:
            if (x == 3 && y == 0) {
                return true;
            }
        case 32:
            if (x == 4 && y == 0) {
                return true;
            }
        case 41:
            if (x == 3 && y == 5) {
                return true;
            }
        case 42:
            if (x == 4 && y == 5) {
                return true;
            }
        default:
            break;
    }
    return false;
}

+ (NSDictionary *)chessWillKilledStrategyWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSInteger x = chess.x;
    NSInteger y = chess.y;
    NSInteger camp = chess.camp;
    if (x == 4 && y == 4) {
        YZChessPlace *p1 = chessPlace[5][4];
        YZChessPlace *p2 = chessPlace[4][5];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
        if (p2.camp == camp) {
            [dict setObject:@(p1.x) forKey:@"x"];
            [dict setObject:@(p1.y) forKey:@"y"];
        }
    }
    if (x == 3 && y == 4) {
        YZChessPlace *p1 = chessPlace[5][3];
        YZChessPlace *p2 = chessPlace[3][5];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
    }
    if (x == 4 && y == 1) {
        YZChessPlace *p1 = chessPlace[4][0];
        YZChessPlace *p2 = chessPlace[5][1];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
        if (p2.camp == camp) {
            [dict setObject:@(p1.x) forKey:@"x"];
            [dict setObject:@(p1.y) forKey:@"y"];
        }
    }
    if (x == 3 && y == 1) {
        YZChessPlace *p1 = chessPlace[5][2];
        YZChessPlace *p2 = chessPlace[3][0];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
    }
    if (x == 1 && y == 1) {
        YZChessPlace *p1 = chessPlace[0][1];
        YZChessPlace *p2 = chessPlace[1][0];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
        if (p2.camp == camp) {
            [dict setObject:@(p1.x) forKey:@"x"];
            [dict setObject:@(p1.y) forKey:@"y"];
        }
    }
    if (x == 2 && y == 1) {
        YZChessPlace *p1 = chessPlace[0][2];
        YZChessPlace *p2 = chessPlace[2][0];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
    }
    if (x == 1 && y == 4) {
        YZChessPlace *p1 = chessPlace[0][4];
        YZChessPlace *p2 = chessPlace[1][5];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
        if (p2.camp == camp) {
            [dict setObject:@(p1.x) forKey:@"x"];
            [dict setObject:@(p1.y) forKey:@"y"];
        }
    }
    if (x == 2 && y == 4) {
        YZChessPlace *p1 = chessPlace[0][3];
        YZChessPlace *p2 = chessPlace[2][5];
        if (p1.camp == camp) {
            [dict setObject:@(p2.x) forKey:@"x"];
            [dict setObject:@(p2.y) forKey:@"y"];
        }
    }
    return dict.copy;
}

@end
