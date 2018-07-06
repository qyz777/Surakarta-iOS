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

@end
