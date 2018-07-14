//
//  YZFlyAnimation.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZFlyAnimation.h"
#import "YZChessPlace.h"

@implementation YZFlyAnimation

+ (CAKeyframeAnimation *)animationWithChessCenter:(CGPoint)center chessArray:(NSArray*)array{
    double duration = 1.0;
    YZChessPlace *zeroP = array.firstObject;
    YZChessPlace *lastP = array.lastObject;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(zeroP.frameX, zeroP.frameY)];
    for (int i = 0; i<array.count-1; i++) {
        YZChessPlace *p = array[i];
        path = [self flyPathWithX:p.x Y:p.y frameX:p.frameX frameY:p.frameY Path:path];
        duration += 0.5;
    }
    [path addLineToPoint:CGPointMake(lastP.frameX, lastP.frameY)];
    duration += 0.5;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.keyPath = @"position";
    animation.duration = duration;
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+ (UIBezierPath*)flyPathWithX:(NSInteger)x Y:(NSInteger)y frameX:(CGFloat)frameX frameY:(CGFloat)frameY Path:(UIBezierPath*)path{
    if (x == 0) {
        switch (y) {
            case 1:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:30 startAngle:0 endAngle:-M_PI_2*3 clockwise:false];
                return path;
            }
            case 2:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:60 startAngle:0 endAngle:-M_PI_2*3 clockwise:false];
                return path;
            }
            case 3:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY-75) radius:60 startAngle:M_PI endAngle:M_PI_2 clockwise:true];
                return path;
            }
            case 4:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY-75) radius:30 startAngle:M_PI endAngle:M_PI_2 clockwise:true];
                return path;
            }
            default:
                break;
        }
    }
    if (x == 1) {
        switch (y) {
            case 0:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:30 startAngle:M_PI_2 endAngle:M_PI*2 clockwise:true];
                return path;
            }
            case 5:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY-75) radius:30 startAngle:M_PI_2 endAngle:M_PI clockwise:false];
                return path;
            }
                
            default:
                break;
        }
    }
    if (x == 2) {
        switch (y) {
            case 0:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY-75) radius:60 startAngle:M_PI_2 endAngle:M_PI*2 clockwise:true];
                return path;
            }
            case 5:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY-75) radius:60 startAngle:M_PI_2 endAngle:M_PI clockwise:false];
                return path;
            }
            default:
                break;
        }
    }
    if (x == 3) {
        switch (y) {
            case 0:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY+75) radius:60 startAngle:-M_PI_2 endAngle:-M_PI*2 clockwise:false];
                return path;
            }
            case 5:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY+75) radius:60 startAngle:-M_PI_2 endAngle:M_PI clockwise:true];
                return path;
            }
            default:
                break;
        }
    }
    if (x == 4) {
        switch (y) {
            case 0:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY+75) radius:30 startAngle:-M_PI_2 endAngle:-M_PI*2 clockwise:false];
                return path;
            }
            case 5:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY+75) radius:30 startAngle:-M_PI_2 endAngle:M_PI clockwise:true];
                return path;
            }
            default:
                break;
        }
    }
    if (x == 5) {
        switch (y) {
            case 1:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY+75) radius:30 startAngle:0 endAngle:M_PI_2*3 clockwise:true];
                return path;
            }
            case 2:{
                [path addArcWithCenter:CGPointMake(CENTERX-75, CENTERY+75) radius:60 startAngle:0 endAngle:M_PI_2*3 clockwise:true];
                return path;
            }
            case 3:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY+75) radius:60 startAngle:M_PI endAngle:M_PI_2*3 clockwise:false];
                return path;
            }
            case 4:{
                [path addArcWithCenter:CGPointMake(CENTERX+75, CENTERY+75) radius:30 startAngle:M_PI endAngle:M_PI_2*3 clockwise:false];
                return path;
            }
            default:
                break;
        }
    }
    [path addLineToPoint:CGPointMake(frameX, frameY)];
    return path;
}


@end
