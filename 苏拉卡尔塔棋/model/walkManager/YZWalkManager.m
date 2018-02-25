//
//  YZWalkManager.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZWalkManager.h"
#import "YZChessPlace.h"

@implementation YZWalkManager

+ (NSMutableArray*)walkEngine:(NSInteger)x Y:(NSInteger)y previousArray:(NSArray*)preArray{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if (x-1>=0 && y-1>=0 && x-1<6 && y-1<6) {
        YZChessPlace *p1 = preArray[x-1][y-1];
        if (p1.camp == 0) {
            [array addObject:p1];
        }
    }
    if (x-1>=0 && y>=0 && x-1<6 && y<6) {
        YZChessPlace *p2 = preArray[x-1][y];
        if (p2.camp == 0){
            [array addObject:p2];
        }
    }
    if (x-1>=0 && y+1>=0 && x-1<6 && y+1<6) {
        YZChessPlace *p3 = preArray[x-1][y+1];
        if (p3.camp == 0){
            [array addObject:p3];
        }
    }
    if (x>=0 && y-1>=0 && x<6 && y-1<6) {
        YZChessPlace *p4 = preArray[x][y-1];
        if (p4.camp == 0){
            [array addObject:p4];
        }
    }
    if (x>=0 && y+1>=0 && x<6 && y+1<6) {
        YZChessPlace *p5 = preArray[x][y+1];
        if (p5.camp == 0){
            [array addObject:p5];
        }
    }
    if (x+1>=0 && y-1>=0 && x+1<6 && y-1<6) {
        YZChessPlace *p6 = preArray[x+1][y-1];
        if (p6.camp == 0){
            [array addObject:p6];
        }
    }
    if (x+1>=0 && y>=0 && x+1<6 && y<6) {
        YZChessPlace *p7 = preArray[x+1][y];
        if (p7.camp == 0){
            [array addObject:p7];
        }
    }
    if (x+1>=0 && y+1>=0 && x+1<6 && y+1<6) {
        YZChessPlace *p8 = preArray[x+1][y+1];
        if (p8.camp == 0){
            [array addObject:p8];
        }
    }
    return array;
}

@end
