//
//  YZChessValue.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/6/5.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZChessPlace;

@interface YZChessValue : NSObject

// 棋子下棋范围
+ (NSInteger)chessWalkRangeWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess;

// 棋子数量
+ (NSInteger)chessNumWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;

// 普通棋盘价值
+ (NSInteger)chessValueWithChess:(YZChessPlace *)chess;

// 残局棋盘价值
+ (NSInteger)chessEndingValueWithChess:(YZChessPlace *)chess;

// 棋子攻击力
+ (NSInteger)chessAttackWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess;

// 棋子可吃子分数
+ (NSInteger)chessWillKillWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;

// 占角分数
+ (NSInteger)angleNeedPerchWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;

// 用来控制开局棋子走向，开局前三步用
+ (BOOL)openingChessShouldGo:(YZChessPlace *)goChess to:(YZChessPlace *)toChess camp:(NSInteger)camp;

@end
