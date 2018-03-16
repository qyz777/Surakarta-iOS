//
//  YZNormalAITactics.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/3/16.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZNormalAITactics.h"
#import "YZChessPlace.h"

@implementation YZNormalAITactics

+ (NSDictionary*)openingTacticsWithChessPlace:(NSArray*)chessPlace StepNum:(NSInteger)num{
    YZChessPlace *whoGo = nil;
    YZChessPlace *goWhere = nil;
    switch (num) {
        case 0:{
            whoGo = chessPlace[1][5];
            goWhere = chessPlace[2][4];
            break;
        }
        case 1:{
            whoGo = chessPlace[1][4];
            goWhere = chessPlace[2][3];
            break;
        }
        case 2:{
            whoGo = chessPlace[0][4];
            goWhere = chessPlace[1][4];
            break;
        }
        case 3:{
            whoGo = chessPlace[2][4];
            goWhere = chessPlace[3][4];
            break;
        }
        default:
            break;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:goWhere forKey:@"goWhere"];
    [dict setObject:whoGo forKey:@"whoGo"];
    [dict setObject:@"walk" forKey:@"type"];
    return dict.copy;
}

@end
