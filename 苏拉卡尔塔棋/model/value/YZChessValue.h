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

// 坏棋减分
+ (NSInteger)badStepScoreWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess;

// 棋子站位减分
+ (NSInteger)badPositionWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;

// 棋子攻击力
+ (NSInteger)chessAttackWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess;

@end
