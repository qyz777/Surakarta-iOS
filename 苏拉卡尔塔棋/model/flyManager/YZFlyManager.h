//
//  YZFlyManager.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZFlyManager : NSObject


/**
 飞行引擎

 @param x x坐标
 @param y y坐标
 @param camp 阵营
 @param plaArray 棋盘
 @return 飞行数组
 */
+ (NSMutableArray*)flyManageWithX:(NSInteger)x Y:(NSInteger)y Camp:(NSInteger)camp placeArray:(NSMutableArray*)plaArray;

@end
