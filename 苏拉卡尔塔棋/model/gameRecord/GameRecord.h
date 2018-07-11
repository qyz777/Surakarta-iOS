//
//  GameRecord.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/7/11.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//
// 2018年大学生计算机博弈比赛使用棋盘记录

#import <Foundation/Foundation.h>

@interface GameRecord : NSObject

- (void)walkChessWithFromX:(NSInteger)fromX
                     fromY:(NSInteger)fromY
                       toX:(NSInteger)toX
                       toY:(NSInteger)toY
                      camp:(NSInteger)camp;

- (void)eatChessWithFromX:(NSInteger)fromX
                fromY:(NSInteger)fromY
                  toX:(NSInteger)toX
                  toY:(NSInteger)toY
                 camp:(NSInteger)camp;

@end
