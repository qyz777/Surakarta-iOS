//
//  GameRecord.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/7/11.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//
// 前往/Users/qyizhong/Library/Developer/CoreSimulator/Devices/58CDF6BC-76C0-4056-9FEA-482405245F8B/data/Containers/Bundle/Application/2950EBC5-2CD8-4DAA-9BB5-0A779AC50514/苏拉卡尔塔棋.app/

#import "GameRecord.h"

#define RECORD_PATH [[NSBundle mainBundle] pathForResource:@"GameRecord" ofType:@"txt"]

@implementation GameRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *header = @"!BBBBBB\n!BBBBBB\n!000000\n!000000\n!RRRRRR\n!RRRRRR\n";
        [header writeToFile:RECORD_PATH atomically:true encoding:NSUTF8StringEncoding error:nil];
    }
    return self;
}

- (void)walkChessWithFromX:(NSInteger)fromX
                     fromY:(NSInteger)fromY
                       toX:(NSInteger)toX
                       toY:(NSInteger)toY
                      camp:(NSInteger)camp {
    NSString *fromStrY = [self convertY:fromY];
    NSString *toStrY = [self convertY:toY];
    NSString *strCamp = [self convertCamp:camp];
    NSString *beforeStr = [NSString stringWithContentsOfFile:RECORD_PATH encoding:NSUTF8StringEncoding error:nil];
    NSString *writeData = [NSString stringWithFormat:@"%@%ld%@ - %ld%@\n",strCamp,fromX,fromStrY,toX,toStrY];
    NSString *data = [NSString stringWithFormat:@"%@%@",beforeStr,writeData];
    [writeData writeToFile:RECORD_PATH atomically:true encoding:NSUTF8StringEncoding error:nil];
    [data writeToFile:RECORD_PATH atomically:true encoding:NSUTF8StringEncoding error:nil];
}

- (void)eatChessWithFromX:(NSInteger)fromX
                fromY:(NSInteger)fromY
                  toX:(NSInteger)toX
                  toY:(NSInteger)toY
                 camp:(NSInteger)camp {
    NSString *fromStrY = [self convertY:fromY];
    NSString *toStrY = [self convertY:toY];
    NSString *strCamp = [self convertCamp:camp];
    NSString *beforeStr = [NSString stringWithContentsOfFile:RECORD_PATH encoding:NSUTF8StringEncoding error:nil];
    NSString *writeData = [NSString stringWithFormat:@"%@%ld%@ x %ld%@\n",strCamp,fromX,fromStrY,toX,toStrY];
    NSString *data = [NSString stringWithFormat:@"%@%@",beforeStr,writeData];
    [writeData writeToFile:RECORD_PATH atomically:true encoding:NSUTF8StringEncoding error:nil];
    [data writeToFile:RECORD_PATH atomically:true encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)convertY:(NSInteger)y {
    switch (y) {
        case 0:
            return @"A";
        case 1:
            return @"B";
        case 2:
            return @"C";
        case 3:
            return @"D";
        case 4:
            return @"E";
        case 5:
            return @"F";
        default:
            break;
    }
    return nil;
}

- (NSString *)convertCamp:(NSInteger)camp {
    if (camp == -1) {
        return @"B";
    }else {
        return @"R";
    }
}

@end
