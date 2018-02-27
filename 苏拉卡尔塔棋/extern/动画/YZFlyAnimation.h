//
//  YZFlyAnimation.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface YZFlyAnimation : CAKeyframeAnimation

+ (CAKeyframeAnimation *)animationWithChessCenter:(CGPoint)center chessArray:(NSArray*)array;

@end
