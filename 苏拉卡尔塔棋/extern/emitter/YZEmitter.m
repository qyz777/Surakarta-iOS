//
//  YZEmitter.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/4/9.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZEmitter.h"
#import "YZSettings.h"

@implementation YZEmitter

+ (CAEmitterLayer*)yzEmitterLayer{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    CAEmitterCell *emitterCell = [[CAEmitterCell alloc]init];
    
    emitterCell.name = @"explosion";
    emitterCell.alphaRange = 0.20;
    emitterCell.alphaSpeed = -1.0;
    emitterCell.lifetime = 0.3;
    emitterCell.lifetimeRange = 0.3;
    emitterCell.birthRate = 2500;
    emitterCell.velocity = 40.00;
    emitterCell.velocityRange = 50.00;
    emitterCell.scale = 0.02;
    emitterCell.scaleRange = 0.02;
    
    NSString *type = [YZSettings typeWithKey:@"special"];
    if ([type isEqualToString:@"none"]) {
        emitterCell.contents = nil;
    }else {
        emitterCell.contents = (id)([[UIImage imageNamed:type] CGImage]);
    }
    emitterLayer.name = @"explosionLayer";
    emitterLayer.emitterShape = kCAEmitterLayerCircle;
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.emitterSize = CGSizeMake(0.5, 0);
    emitterLayer.emitterCells = @[emitterCell];
    emitterLayer.renderMode = kCAEmitterLayerBackToFront;
    emitterLayer.masksToBounds = false;
    emitterLayer.birthRate = 0;
    emitterLayer.zPosition = 0;
    
    return emitterLayer;
}

@end
