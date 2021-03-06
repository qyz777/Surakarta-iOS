//
//  YZChessPlace.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2017/12/23.
//  Copyright © 2017年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString const *stepArrayKey;
UIKIT_EXTERN NSString const *goKey;
UIKIT_EXTERN NSString const *toKey;
UIKIT_EXTERN NSString const *valueKey;
UIKIT_EXTERN NSString const *stepTypeKey;
UIKIT_EXTERN NSString const *stepTypeWalk;
UIKIT_EXTERN NSString const *stepTypeFly;

@interface YZChessPlace : NSObject<NSCopying,NSMutableCopying>

@property(assign,nonatomic)NSInteger camp;
@property(assign,nonatomic)NSInteger tag;
@property(assign,nonatomic)NSInteger x;
@property(assign,nonatomic)NSInteger y;
@property(assign,nonatomic)CGFloat frameX;
@property(assign,nonatomic)CGFloat frameY;

//初始化棋盘
+ (NSMutableArray*)initPlace;

//获取飞行点位
+ (NSArray*)pathwayTable:(NSInteger)x Y:(NSInteger)y;

//获取飞行方向
+ (NSInteger)directionTable:(NSInteger)x Y:(NSInteger)y;


@end
