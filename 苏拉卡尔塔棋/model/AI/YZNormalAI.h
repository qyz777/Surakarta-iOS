//
//  YZNormalAI.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/3/12.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//
/*
 一个简易的AI，仅以盘面价值为参考量
 */

#import <Foundation/Foundation.h>

@interface YZNormalAI : NSObject

//传入棋盘
- (NSDictionary*)dictWithChessPlace:(NSArray*)chessPlace StepNum:(NSInteger)num;

@end
