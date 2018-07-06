//
//  YZNewAI.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/6/3.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZNewAI : NSObject

@property(nonatomic, assign)NSInteger camp;
@property(nonatomic, assign)NSInteger searchDepth;
@property(nonatomic, assign)NSInteger stepNum;

@property(nonatomic, assign)BOOL isFirst;

// 获得AI下子
- (NSDictionary *)stepDataWithChessPlace:(NSArray *)chessPlace;

// 使用GCD获得AI下子
- (void)stepWithChessPlace:(NSArray *)chessPlace block:(void(^)(NSDictionary *step))block;

@end
