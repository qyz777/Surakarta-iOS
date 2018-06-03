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

//传入棋盘
- (NSDictionary *)stepDataWithChessPlace:(NSArray *)chessPlace;

@end
