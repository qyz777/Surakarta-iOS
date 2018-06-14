//
//  YZNewAI.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/6/3.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString const *stepArrayKey;
UIKIT_EXTERN NSString const *goKey;
UIKIT_EXTERN NSString const *toKey;
UIKIT_EXTERN NSString const *valueKey;
UIKIT_EXTERN NSString const *stepTypeKey;
UIKIT_EXTERN NSString const *stepTypeWalk;
UIKIT_EXTERN NSString const *stepTypeFly;

@interface YZNewAI : NSObject

@property(nonatomic, assign)NSInteger camp;
@property(nonatomic, assign)NSInteger searchDepth;

// 获得AI下子
- (NSDictionary *)stepDataWithChessPlace:(NSArray *)chessPlace;

// 使用GCD获得AI下子
- (void)stepWithChessPlace:(NSArray *)chessPlace block:(void(^)(NSDictionary *step))block;

@end
