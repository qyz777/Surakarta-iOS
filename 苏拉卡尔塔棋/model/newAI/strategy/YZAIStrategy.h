//
//  YZAIStrategy.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/7/6.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//
// AI策略

#import <Foundation/Foundation.h>
#import "YZChessPlace.h"

@interface YZAIStrategy : NSObject


/**
 先手策略，采取前三步主动进攻方式，有明显缺陷，暂不使用

 @param chessPlace 棋盘
 @param camp 阵营
 @param stepNum 步数
 @return 棋位
 */
+ (NSDictionary *)precedenceStrategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp stepNum:(NSInteger)stepNum;


/**
 后手策略，前三步后手策略，在满足先手策略时触发

 @param chessPlace 棋盘
 @param camp 阵营
 @param stepNum 步数
 @return 棋位
 */
+ (NSDictionary *)laterStrategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp stepNum:(NSInteger)stepNum;


/**
 棋盘策略接口，对于博弈树第一步满足的特定条件做展开策略

 @param chessPlace 棋盘
 @param camp 阵营
 @return 棋位
 */
+ (NSDictionary *)strategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;


/**
 应对内环进攻威胁

 @param chessPlace 棋盘
 @param camp 阵营
 @return 需要注意的方位 左上 右上 左下 右下 1 2 3 4
 */
+ (NSInteger)defendStrategyWithChessPlace:(NSArray *)chessPlace camp:(NSInteger)camp;


/**
 处在内环威胁之中，获得防守方法

 @param position 防守方位
 @param x x坐标
 @param y y坐标
 @return 是否下子
 */
+ (BOOL)isNeedDefendWithPosition:(NSInteger)position x:(NSInteger)x y:(NSInteger)y;

+ (NSDictionary *)chessWillKilledStrategyWithChessPlace:(NSArray *)chessPlace chess:(YZChessPlace *)chess;

@end
