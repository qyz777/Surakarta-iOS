//
//  YZFlyManager.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZFlyManager.h"
#import "YZChessPlace.h"

@interface YZFlyManager()

@property(assign,nonatomic)NSInteger flyX;
@property(assign,nonatomic)NSInteger flyY;
@property(strong,nonatomic)NSMutableArray *flyPath;
@property(strong,nonatomic)NSMutableArray *finishFlyPath;
@property(strong,nonatomic)NSMutableArray *placeArray;

@end

@implementation YZFlyManager

+ (NSMutableArray*)flyManageWithX:(NSInteger)x Y:(NSInteger)y Camp:(NSInteger)camp placeArray:(NSMutableArray*)plaArray{
    YZFlyManager *manager = [[YZFlyManager alloc]init];
    [manager beginFlyWithX:x Y:y Camp:camp placeArray:plaArray];
    return manager.finishFlyPath;
}

- (void)beginFlyWithX:(NSInteger)x Y:(NSInteger)y Camp:(NSInteger)camp placeArray:(NSMutableArray*)plaArray{
    _flyPath = [[NSMutableArray alloc]init];
    _finishFlyPath = [[NSMutableArray alloc]init];
    _placeArray = plaArray;
//    NSDate *startTime = [NSDate date];//计算运行时间
    for (int i = UP_TO_FLY; i<=LEFT_TO_FLY; i++) {
        _flyX = x;
        _flyY = y;
        [self flyEngine:x Y:y Direction:i Camp:camp CanFly:false];
    }
//    NSLog(@"飞行轨道计算运行时间: %f",-[startTime timeIntervalSinceNow]);//计算运行时间
}

#pragma make - 不可以动的飞行算法
- (BOOL)canFlyWtihDircetion:(NSInteger)dircetion{
    switch (dircetion) {
        case UP_TO_FLY:{
            _flyX -= 1;
            if (_flyX < 0) {
                _flyX += 1;
                return false;
            }else{
                return true;
            }
        }
        case RIGHT_TO_FLY:{
            _flyY += 1;
            if (_flyY > 5) {
                _flyY -= 1;
                return false;
            }else{
                return true;
            }
        }
        case DOWN_TO_FLY:{
            _flyX += 1;
            if (_flyX > 5) {
                _flyX -= 1;
                return false;
            }else{
                return true;
            }
        }
        case LEFT_TO_FLY:{
            _flyY -= 1;
            if (_flyY < 0) {
                _flyY += 1;
                return false;
            }else{
                return true;
            }
        }
        default:
            break;
    }
    
    return false;
}

- (void)flyEngine:(NSInteger)x Y:(NSInteger)y Direction:(NSInteger) dircetion Camp:(NSInteger)camp CanFly:(BOOL)alreadyFly{
    if ((_flyX == 0 && _flyY == 0) || (_flyX == 5 && _flyY == 0) || (_flyX == 0 && _flyY == 5) || (_flyX == 5 && _flyY == 5)) {
        return;
    }
    
    while ([self canFlyWtihDircetion:dircetion]) {
        YZChessPlace *p = _placeArray[_flyX][_flyY];
        if (p.camp != 0) {
            if (p.camp + camp == 0) {
                //敌方棋子
                if (alreadyFly) {
                    [_flyPath addObject:p];
                    //可以飞行了
                    if (_flyPath.count > 5) {
                        //飞行溢出情况
                        NSMutableArray *bugArray = [self bugArrayWithFlyArray:_flyPath];
                        [_finishFlyPath addObject:bugArray.copy];
                        [bugArray removeAllObjects];
                        [_flyPath removeAllObjects];
                    }else {
                        [_finishFlyPath addObject:_flyPath.copy];
                        [_flyPath removeAllObjects];
                    }
                    return;
                }else{
                    [_flyPath removeAllObjects];
                    return;
                }
            }else{
                //自己棋子
                if (_flyX == x && _flyY == y) {
                    if (_flyPath.count < 6) {
                        continue;
                    }else{
                        return;
                    }
                }else{
                    //和起点不同
                    [_flyPath removeAllObjects];
                    return;
                }
            }
        }
    }
    
    if ((_flyX == 0 && _flyY == 0) || (_flyX == 5 && _flyY == 0) || (_flyX == 0 && _flyY == 5) || (_flyX == 5 && _flyY == 5)) {
        return;
    }
    
    YZChessPlace *pp = _placeArray[_flyX][_flyY];
    [_flyPath addObject:pp];
    
    NSArray *pathwayArray = [YZChessPlace pathwayTable:_flyX Y:_flyY];
    if (pathwayArray.count > 0) {
        NSNumber *nX = pathwayArray[0];
        NSNumber *nY = pathwayArray[1];
        _flyX = [nX integerValue];
        _flyY = [nY integerValue];
    }
    
    YZChessPlace *ppp = _placeArray[_flyX][_flyY];
    if (ppp.camp != 0) {
        if (ppp.camp + camp == 0) {
            [_flyPath addObject:ppp];
            //可以飞行了
            if (_flyPath.count > 5) {
                //飞行溢出情况
                NSMutableArray *bugArray = [self bugArrayWithFlyArray:_flyPath];
                [_finishFlyPath addObject:bugArray.copy];
                [bugArray removeAllObjects];
                [_flyPath removeAllObjects];
            }else {
                [_finishFlyPath addObject:_flyPath.copy];
                [_flyPath removeAllObjects];
            }
            return;
        }else{
            [_flyPath removeAllObjects];
            return;
        }
    }else{
        dircetion = [YZChessPlace directionTable:_flyX Y:_flyY];
        [self flyEngine:x Y:y Direction:dircetion Camp:camp CanFly:true];
    }
}

- (NSMutableArray*)bugArrayWithFlyArray:(NSMutableArray*)flyArray{
    NSMutableArray *bugArray = [[NSMutableArray alloc]init];
    if (flyArray.count == 8 || flyArray.count == 12) {
//        处理特殊bug
        [bugArray addObject:flyArray[flyArray.count-4]];
        [bugArray addObject:flyArray[flyArray.count-3]];
        [bugArray addObject:flyArray[flyArray.count-2]];
        [bugArray addObject:flyArray[flyArray.count-1]];
    }else {
        for (int i=(int)flyArray.count / 4 * 4; i<flyArray.count; i++) {
            [bugArray addObject:flyArray[i]];
        }
    }
    return bugArray;
}

@end
