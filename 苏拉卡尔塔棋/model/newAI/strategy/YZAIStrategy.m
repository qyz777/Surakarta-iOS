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

+ (NSDictionary *)strategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp stepNum:(NSInteger)stepNum {
    NSDictionary *d = [self strategyOneWithChessPlace:chessPlace camp:camp];
    if (d) {
        return d;
    }
    d = [self strategyTwoWithChessPlace:chessPlace camp:camp];
    if (d) {
        return d;
    }
    return nil;
}

// 策略1
// R R R R R R
// R - R R R -
// - - R - R -
// B - B - - -
// - - B B B B
// B B B B B B
+ (NSDictionary *)strategyOneWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    if (camp == -1) {
        YZChessPlace *p1 = chessPlace[3][0];
        YZChessPlace *p2 = chessPlace[3][2];
        YZChessPlace *p3 = chessPlace[4][0];
        YZChessPlace *p4 = chessPlace[4][1];
        if (p1.camp == 1 && p2.camp == 1 && p3.camp == 0 && p4.camp == 0) {
            YZChessPlace *p = chessPlace[1][0];
            YZChessPlace *toP = chessPlace[2][1];
            if (p.camp == -1 && toP.camp == 0) {
                if (toP.camp == 0) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:p forKey:goKey];
                    [dict setObject:chessPlace[2][1] forKey:toKey];
                    return dict.copy;
                }
            }
        }
        YZChessPlace *p5 = chessPlace[3][3];
        YZChessPlace *p6 = chessPlace[3][5];
        YZChessPlace *p7 = chessPlace[5][4];
        YZChessPlace *p8 = chessPlace[5][5];
        if (p5.camp == 1 && p6.camp == 1 && p7.camp == 1 && p8.camp == 1) {
            YZChessPlace *p = chessPlace[2][4];
            YZChessPlace *toP = chessPlace[2][3];
            if (p.camp == -1 && toP.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:p forKey:goKey];
                [dict setObject:toP forKey:toKey];
                return dict.copy;
            }
        }
    }else {
        YZChessPlace *p1 = chessPlace[2][0];
        YZChessPlace *p2 = chessPlace[2][4];
        YZChessPlace *p3 = chessPlace[1][5];
        YZChessPlace *p4 = chessPlace[1][4];
        if (p1.camp == 1 && p2.camp == 1 && p3.camp == 0 && p4.camp == 0) {
            YZChessPlace *p = chessPlace[4][0];
            YZChessPlace *toP = chessPlace[3][5];
            if (p.camp == -1 && toP.camp == 0) {
                if (toP.camp) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:p forKey:goKey];
                    [dict setObject:chessPlace[3][5] forKey:toKey];
                    return dict.copy;
                }
            }
        }
    }
    return nil;
}

// 策略2
+ (NSDictionary *)strategyTwoWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp {
    if (camp == -1) {
        YZChessPlace *p1 = chessPlace[3][3];
        YZChessPlace *p2 = chessPlace[3][5];
        YZChessPlace *p3 = chessPlace[4][4];
        YZChessPlace *p4 = chessPlace[5][5];
        if (p1.camp == 1 && p2.camp == 1 && p3.camp == 1 && p4.camp == 1) {
            YZChessPlace *p = chessPlace[1][5];
            YZChessPlace *toP = chessPlace[2][5];
            if (p.camp == -1 && toP.camp == 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:p forKey:goKey];
                [dict setObject:toP forKey:toKey];
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
            return 1;
        }
        
        YZChessPlace *p4 = chessPlace[3][3];
        YZChessPlace *p5 = chessPlace[3][5];
        if (p4.camp == 1 && p5.camp == 1) {
            return 2;
        }
    }else {
        YZChessPlace *p1 = chessPlace[2][0];
        YZChessPlace *p2 = chessPlace[2][2];
        if (p1.camp == -1 && p2.camp == -1) {
            return 3;
        }
        
        YZChessPlace *p4 = chessPlace[2][3];
        YZChessPlace *p5 = chessPlace[2][5];
        if (p4.camp == -1 && p5.camp == -1) {
            return 4;
        }
    }
    return -1;
}

+ (BOOL)isNeedDefendWithPosition:(NSInteger)position x:(NSInteger)x y:(NSInteger)y {
    switch (position) {
        case 1:
            if (x == 0 && y == 0) {
                return true;
            }
            if (x == 1 && y == 0) {
                return true;
            }
            if (x == 2 && y == 0) {
                return true;
            }
        case 2:
            if (x == 0 && y == 5) {
                return true;
            }
            if (x == 1 && y == 5) {
                return true;
            }
            if (x == 2 && y == 5) {
                return true;
            }
        case 3:
            if (x == 3 && y == 0) {
                return true;
            }
            if (x == 4 && y == 0) {
                return true;
            }
            if (x == 5 && y == 0) {
                return true;
            }
        case 4:
            if (x == 3 && y == 5) {
                return true;
            }
            if (x == 4 && y == 5) {
                return true;
            }
            if (x == 5 && y == 5) {
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
