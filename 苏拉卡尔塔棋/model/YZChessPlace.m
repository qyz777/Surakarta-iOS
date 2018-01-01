//
//  YZChessPlace.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2017/12/23.
//  Copyright © 2017年 Q YiZhong. All rights reserved.
//

#import "YZChessPlace.h"

@implementation YZChessPlace


/**
 返回的数组中第一个元素是x，第二个元素是y

 @param x x坐标
 @param y y坐标
 @return 数组
 */
+ (NSArray*)pathwayTable:(NSInteger)x Y:(NSInteger)y{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    switch (x) {
        case 0:{
            if (y == 1) {
                [array addObject:[NSNumber numberWithInteger:0]];
                [array addObject:[NSNumber numberWithInteger:1]];
            }
            if (y == 2) {
                [array addObject:[NSNumber numberWithInteger:2]];
                [array addObject:[NSNumber numberWithInteger:0]];
            }
            if (y == 3) {
                [array addObject:[NSNumber numberWithInteger:2]];
                [array addObject:[NSNumber numberWithInteger:5]];
            }
            if (y == 4) {
                [array addObject:[NSNumber numberWithInteger:1]];
                [array addObject:[NSNumber numberWithInteger:5]];
            }
            break;
        }
        case 1:{
            if (y == 0) {
                [array addObject:[NSNumber numberWithInteger:0]];
                [array addObject:[NSNumber numberWithInteger:1]];
            }
            if (y == 5) {
                [array addObject:[NSNumber numberWithInteger:0]];
                [array addObject:[NSNumber numberWithInteger:4]];
            }
            break;
        }
        case 2:{
            if (y == 0) {
                [array addObject:[NSNumber numberWithInteger:0]];
                [array addObject:[NSNumber numberWithInteger:2]];
            }
            if (y == 5) {
                [array addObject:[NSNumber numberWithInteger:0]];
                [array addObject:[NSNumber numberWithInteger:3]];
            }
            break;
        }
        case 3:{
            if (y == 0) {
                [array addObject:[NSNumber numberWithInteger:5]];
                [array addObject:[NSNumber numberWithInteger:2]];
            }
            if (y == 5) {
                [array addObject:[NSNumber numberWithInteger:5]];
                [array addObject:[NSNumber numberWithInteger:3]];
            }
            break;
        }
        case 4:{
            if (y == 0) {
                [array addObject:[NSNumber numberWithInteger:5]];
                [array addObject:[NSNumber numberWithInteger:1]];
            }
            if (y == 5) {
                [array addObject:[NSNumber numberWithInteger:5]];
                [array addObject:[NSNumber numberWithInteger:4]];
            }
            break;
        }
        case 5:{
            if (y == 1) {
                [array addObject:[NSNumber numberWithInteger:4]];
                [array addObject:[NSNumber numberWithInteger:0]];
            }
            if (y == 2) {
                [array addObject:[NSNumber numberWithInteger:3]];
                [array addObject:[NSNumber numberWithInteger:0]];
            }
            if (y == 3) {
                [array addObject:[NSNumber numberWithInteger:3]];
                [array addObject:[NSNumber numberWithInteger:5]];
            }
            if (y == 4) {
                [array addObject:[NSNumber numberWithInteger:4]];
                [array addObject:[NSNumber numberWithInteger:5]];
            }
            break;
        }
            
        default:
            break;
    }
    
    return array.copy;
}

/**
 返回飞行方向

 @param x x坐标
 @param y y坐标
 @return 返回飞行方向
 */
+ (NSInteger)directionTable:(NSInteger)x Y:(NSInteger)y{
    switch (x) {
        case 0:{
            if (y == 1 || y == 2 || y == 3 || y ==4) {
                return DOWN_TO_FLY;
            }
            break;
        }
        case 1:{
            if (y == 0) {
                return RIGHT_TO_FLY;
            }
            if (y == 5) {
                return LEFT_TO_FLY;
            }
            break;
        }
        case 2:{
            if (y == 0) {
                return RIGHT_TO_FLY;
            }
            if (y == 5) {
                return LEFT_TO_FLY;
            }
            break;
        }
        case 3:{
            if (y == 0) {
                return RIGHT_TO_FLY;
            }
            if (y == 5) {
                return LEFT_TO_FLY;
            }
            break;
        }
        case 4:{
            if (y == 0) {
                return RIGHT_TO_FLY;
            }
            if (y == 5) {
                return LEFT_TO_FLY;
            }
            break;
        }
        case 5:{
            if (y == 1 || y == 2 || y == 3 || y ==4) {
                return UP_TO_FLY;
            }
            break;
        }
        default:
            break;
    }
    return -1;
}

@end
