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
@property(copy,nonatomic)NSMutableArray *flyPath;
@property(copy,nonatomic)NSMutableArray *finishFlyPath;
@property(copy,nonatomic)NSMutableArray *placeArray;

@end

@implementation YZFlyManager

+ (NSDictionary*)flyManageWithX:(NSInteger)x Y:(NSInteger)y Camp:(NSInteger)camp placeArray:(NSMutableArray*)plaArray{
    YZFlyManager *manager = [[YZFlyManager alloc]init];
    [manager beginFlyWithX:x Y:y Camp:camp placeArray:plaArray];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:manager.finishFlyPath forKey:@"finishFlyPath"];
    [dict setObject:manager.placeArray forKey:@"placeArray"];
    return dict.copy;
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
                    [_finishFlyPath addObject:_flyPath.copy];
                    [_flyPath removeAllObjects];
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
            [_finishFlyPath addObject:_flyPath.copy];
            [_flyPath removeAllObjects];
            return;
        }else{
            [_flyPath removeAllObjects];
            return;
        }
    }else{
        [_placeArray addObject:ppp];
        dircetion = [YZChessPlace directionTable:_flyX Y:_flyY];
        [self flyEngine:x Y:y Direction:dircetion Camp:camp CanFly:true];
    }
}

@end
