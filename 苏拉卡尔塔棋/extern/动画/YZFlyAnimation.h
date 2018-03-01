//
//  YZFlyAnimation.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface YZFlyAnimation : CAKeyframeAnimation


/**
 飞行动画组件

 @param center 棋子的center
 @param array 吃子点位
 @return 返回一个动画
 */
+ (CAKeyframeAnimation *)animationWithChessCenter:(CGPoint)center chessArray:(NSArray*)array;

@end
