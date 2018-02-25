//
//  YZWalkManager.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZWalkManager : NSObject


/**
 walk下子引擎

 @param x x坐标
 @param y y坐标
 @param preArray placeArray
 @return 把满足可以下子的位置的YZChessPlace数据存到数组中返回
 */
+ (NSMutableArray*)walkEngine:(NSInteger)x Y:(NSInteger)y previousArray:(NSArray*)preArray;

@end
