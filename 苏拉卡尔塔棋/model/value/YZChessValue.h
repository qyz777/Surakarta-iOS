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

+ (NSInteger)chessFirstValueWithChess:(YZChessPlace *)chess;

// 普通棋盘价值
+ (NSInteger)chessValueWithChess:(YZChessPlace *)chess;

// 残局棋盘价值
+ (NSInteger)chessEndingValueWithChess:(YZChessPlace *)chess;

// 坏棋减分
+ (NSInteger)badStepScoreWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess;

// 棋子攻击力
+ (NSInteger)chessAttackWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess;

// 棋子可吃子分数
+ (NSInteger)chessWillKillWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;

// 占角，返回-1不需要 1 2 3 4代表 左上 右上 左下 右下
+ (NSInteger)angleNeedPerchWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;

// 占角采用不同的局面评估
+ (NSInteger)anglePostionValueWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess angle:(NSInteger)angle;

// 残局局面平方，用来在残局刺激棋子离开保守的位置
+ (NSInteger)endingPostionValueWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;

@end
