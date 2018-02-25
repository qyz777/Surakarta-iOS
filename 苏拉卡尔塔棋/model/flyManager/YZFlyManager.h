//
//  YZFlyManager.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZFlyManager : NSObject

+ (NSDictionary*)flyManageWithX:(NSInteger)x Y:(NSInteger)y Camp:(NSInteger)camp placeArray:(NSMutableArray*)plaArray;

@end
