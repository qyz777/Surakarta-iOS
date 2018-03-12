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

@implementation YZNormalAI{
    NSArray *place;
}

- (NSDictionary*)dictWithChessPlace:(NSArray*)chessPlace{
    place = chessPlace;
    return [self getFinishPlace].copy;
}

- (NSDictionary*)getFinishPlace{
    NSMutableArray *finishArray = [[NSMutableArray alloc]init];
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = place[i][j];
            if (p.camp == -1) {
                NSMutableDictionary *dict = [self getChessValueWithChess:p];
                if (dict) {
                    [dict setObject:p forKey:@"棋子"];
                    [finishArray addObject:dict];
                }
            }
        }
    }
    NSInteger maxValue = 0;
    int maxK = 0;
    int flyCount = 0;
    for (int k=0; k<finishArray.count; k++) {
        NSDictionary *d = finishArray[k];
        NSString *shortStr = d[@"类型"];
        if ([shortStr isEqualToString:@"行走"]) {
            NSNumber *valueNumber = d[@"可走位置价值"];
            if (maxValue < valueNumber.integerValue) {
                maxValue = valueNumber.integerValue;
                maxK = k;
            }
        }
        if ([shortStr isEqualToString:@"飞行"]) {
            flyCount++;
        }
    }
    if (flyCount > 0) {
        maxK = 0;
        maxValue = 0;
        for (int j=0; j<finishArray.count; j++) {
            NSDictionary *d = finishArray[j];
            NSString *shortStr = d[@"类型"];
            if ([shortStr isEqualToString:@"飞行"]) {
                NSNumber *valueNumber = d[@"可走位置价值"];
                if (maxValue < valueNumber.integerValue) {
                    maxValue = valueNumber.integerValue;
                    maxK = j;
                }
            }
        }
    }
    return finishArray[maxK];
}

- (NSMutableDictionary*)getChessValueWithChess:(YZChessPlace*)chess{
    NSArray *walkArray = [YZWalkManager walkEngine:chess.x Y:chess.y previousArray:place.copy];
    NSArray *flyArray = [YZFlyManager flyManageWithX:chess.x Y:chess.y Camp:chess.camp placeArray:place.copy];
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
        [dict setObject:flyArray[maxI] forKey:@"可走位置"];
        [dict setObject:[NSNumber numberWithInteger:maxValue] forKey:@"可走位置价值"];
        [dict setObject:@"飞行" forKey:@"类型"];
        return dict;
    }
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
        [dict setObject:walkArray[maxI] forKey:@"可走位置"];
        [dict setObject:[NSNumber numberWithInteger:maxValue] forKey:@"可走位置价值"];
        [dict setObject:@"行走" forKey:@"类型"];
        return dict;
    }
    return nil;
}

@end
