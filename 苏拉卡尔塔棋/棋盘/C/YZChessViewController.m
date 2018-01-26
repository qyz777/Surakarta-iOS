//
//  YZChessViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZChessViewController.h"
#import "YZChessView.h"
#import "YZChessPlace.h"

@interface YZChessViewController ()<YZChessViewDelegate>{
    YZChessView *_kYZChessView;
    NSMutableArray *placeArray;
    NSMutableArray *flyPath;
    NSMutableArray *finishFlyPath;
    NSInteger flyX;
    NSInteger flyY;
}

@end

@implementation YZChessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}


/**
 初始化界面
 这里的新建棋盘矩阵的过程中把每个点位的初始化数据为YZChessPlace，具体数据内容请查看YZChessPlace
 棋子的tag初始为1
 */
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    _kYZChessView = [[YZChessView alloc]init];
    _kYZChessView.chessDelegate = self;
    _kYZChessView.isRedChess = false;
    [self.view addSubview:_kYZChessView];
    [self initPlace];
}

- (void)initPlace{
    placeArray = [[NSMutableArray alloc]init];
    //新建棋盘矩阵
    NSInteger k = 1;
    for (int i=0; i<6; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int j=0; j<6; j++) {
            YZChessPlace *place = [[YZChessPlace alloc]init];
            place.x = i;
            place.y = j;
            if (i<2) {
                place.camp = -1;
                place.tag = k;
            }else if (i<4){
                place.camp = 0;
            }else if (i<6) {
                place.camp = 1;
                place.tag = k-12;
            }
            place.frameX = CENTERX-75+j*30;
            place.frameY = CENTERY-75+i*30;
            k++;
            [array addObject:place];
        }
        [placeArray addObject:array];
    }
}

#pragma make - 协议
- (void)chessBtnDidTouchWithTag:(NSInteger)tag{
    NSInteger x = 0;
    NSInteger y = 0;
    NSInteger camp = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = placeArray[i][j];
            if (p.tag == tag) {
                x = p.x;
                y = p.y;
                camp = p.camp;
            }
        }
    }
    
    //设置walk引擎
    NSArray *arrayWalk = [self walkEngine:x Y:y];
    //    NSLog(@"%@",arrayWalk);
    [_kYZChessView setWalkEngineWithArray:arrayWalk];
    _kYZChessView.walkTag = tag;
    
    //设置飞行引擎
    NSDate *startTime = [NSDate date];//计算运行时间
    
    flyPath = [[NSMutableArray alloc]init];
    finishFlyPath = [[NSMutableArray alloc]init];
    for (int i = UP_TO_FLY; i<=LEFT_TO_FLY; i++) {
        flyX = x;
        flyY = y;
        [self flyEngine:x Y:y Direction:i Camp:camp CanFly:false];
    }
    
    NSLog(@"飞行轨道计算运行时间: %f", -[startTime timeIntervalSinceNow]);//计算运行时间
    
    if (finishFlyPath.count > 0) {
        [_kYZChessView setFlyEngineWithArray:finishFlyPath.copy];
        [finishFlyPath removeAllObjects];
    }
}

- (BOOL)canFlyWtihDircetion:(NSInteger)dircetion{
    switch (dircetion) {
        case UP_TO_FLY:{
            flyX -= 1;
            if (flyX < 0) {
                flyX += 1;
                return false;
            }else{
                return true;
            }
        }
        case RIGHT_TO_FLY:{
            flyY += 1;
            if (flyY > 5) {
                flyY -= 1;
                return false;
            }else{
                return true;
            }
        }
        case DOWN_TO_FLY:{
            flyX += 1;
            if (flyX > 5) {
                flyX -= 1;
                return false;
            }else{
                return true;
            }
        }
        case LEFT_TO_FLY:{
            flyY -= 1;
            if (flyY < 0) {
                flyY += 1;
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
    if ((flyX == 0 && flyY == 0) || (flyX == 5 && flyY == 0) || (flyX == 0 && flyY == 5) || (flyX == 5 && flyY == 5)) {
        return;
    }
    
    while ([self canFlyWtihDircetion:dircetion]) {
        YZChessPlace *p = placeArray[flyX][flyY];
        if (p.camp != 0) {
            if (p.camp + camp == 0) {
                //敌方棋子
                if (alreadyFly) {
                    [flyPath addObject:p];
                    //可以飞行了
                    [finishFlyPath addObject:flyPath.copy];
                    [flyPath removeAllObjects];
                    return;
                }else{
                    [flyPath removeAllObjects];
                    return;
                }
            }else{
                //自己棋子
                if (flyX == x && flyY == y) {
                    if (flyPath.count < 6) {
                        continue;
                    }else{
                        return;
                    }
                }else{
                    //和起点不同
                    [flyPath removeAllObjects];
                    return;
                }
            }
        }
    }
    
    if ((flyX == 0 && flyY == 0) || (flyX == 5 && flyY == 0) || (flyX == 0 && flyY == 5) || (flyX == 5 && flyY == 5)) {
        return;
    }
    
    YZChessPlace *pp = placeArray[flyX][flyY];
    [flyPath addObject:pp];
    
    NSArray *pathwayArray = [YZChessPlace pathwayTable:flyX Y:flyY];
    if (pathwayArray.count > 0) {
        NSNumber *nX = pathwayArray[0];
        NSNumber *nY = pathwayArray[1];
        flyX = [nX integerValue];
        flyY = [nY integerValue];
    }
    
    YZChessPlace *ppp = placeArray[flyX][flyY];
    if (ppp.camp != 0) {
        if (ppp.camp + camp == 0) {
            [flyPath addObject:ppp];
            //可以飞行了
            [finishFlyPath addObject:flyPath.copy];
            [flyPath removeAllObjects];
            return;
        }else{
            [flyPath removeAllObjects];
            return;
        }
    }else{
        [placeArray addObject:ppp];
        dircetion = [YZChessPlace directionTable:flyX Y:flyY];
        [self flyEngine:x Y:y Direction:dircetion Camp:camp CanFly:true];
    }
}

/**
 棋子吃子完以后的协议
 
 @param firstTag 吃子的tag
 @param lastTag 被吃子的tag
 */
- (void)chessBtnDidEatWithFirstTag:(NSInteger)firstTag lastTag:(NSInteger)lastTag{
    NSInteger shortCamp = 0;
    int m = 0,n = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = placeArray[i][j];
            if (p.tag == firstTag) {
                shortCamp = p.camp;
                p.tag = 0;
                p.camp = 0;
                placeArray[i][j] = p;
            }
            if (p.tag == lastTag) {
                m = i;
                n = j;
            }
        }
    }
    YZChessPlace *shortP = placeArray[m][n];
    shortP.tag = firstTag;
    shortP.camp = shortCamp;
    placeArray[m][n] = shortP;
}

/**
 棋子经过walk引擎然后改矩阵
 
 @param tag 需要移动棋子的tag值
 @param x x坐标
 @param y y坐标
 */
- (void)walkBtnDidTouchWithTag:(NSInteger)tag frameX:(CGFloat)x frameY:(CGFloat)y{
//    if (_kYZChessView.isRedChess) {
//        [_kYZChessView blueChessGo];
//    }else{
//        [_kYZChessView redChessGo];
//    }
    NSInteger shortTag = tag;
    NSInteger shortCamp = 0;
    int m = 0;
    int n = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = placeArray[i][j];
            if (p.tag == tag) {
                shortCamp = p.camp;
                p.tag = 0;
                p.camp = 0;
                placeArray[i][j] = p;
            }
            if (p.frameX == x && p.frameY == y) {
                m = i;
                n = j;
            }
        }
    }
    YZChessPlace *shortP = placeArray[m][n];
    shortP.tag = shortTag;
    shortP.camp = shortCamp;
    placeArray[m][n] = shortP;
}


/**
 walk下子引擎
 
 @param x x坐标
 @param y y坐标
 @return 把满足可以下子的位置的YZChessPlace数据存到数组中返回
 */
- (NSMutableArray*)walkEngine:(NSInteger)x Y:(NSInteger)y{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if (x-1>=0 && y-1>=0 && x-1<6 && y-1<6) {
        YZChessPlace *p1 = placeArray[x-1][y-1];
        if (p1.camp == 0) {
            [array addObject:p1];
        }
    }
    if (x-1>=0 && y>=0 && x-1<6 && y<6) {
        YZChessPlace *p2 = placeArray[x-1][y];
        if (p2.camp == 0){
            [array addObject:p2];
        }
    }
    if (x-1>=0 && y+1>=0 && x-1<6 && y+1<6) {
        YZChessPlace *p3 = placeArray[x-1][y+1];
        if (p3.camp == 0){
            [array addObject:p3];
        }
    }
    if (x>=0 && y-1>=0 && x<6 && y-1<6) {
        YZChessPlace *p4 = placeArray[x][y-1];
        if (p4.camp == 0){
            [array addObject:p4];
        }
    }
    if (x>=0 && y+1>=0 && x<6 && y+1<6) {
        YZChessPlace *p5 = placeArray[x][y+1];
        if (p5.camp == 0){
            [array addObject:p5];
        }
    }
    if (x+1>=0 && y-1>=0 && x+1<6 && y-1<6) {
        YZChessPlace *p6 = placeArray[x+1][y-1];
        if (p6.camp == 0){
            [array addObject:p6];
        }
    }
    if (x+1>=0 && y>=0 && x+1<6 && y<6) {
        YZChessPlace *p7 = placeArray[x+1][y];
        if (p7.camp == 0){
            [array addObject:p7];
        }
    }
    if (x+1>=0 && y+1>=0 && x+1<6 && y+1<6) {
        YZChessPlace *p8 = placeArray[x+1][y+1];
        if (p8.camp == 0){
            [array addObject:p8];
        }
    }
    return array;
}
@end
