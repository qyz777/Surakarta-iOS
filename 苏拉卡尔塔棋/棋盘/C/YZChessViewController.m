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
#import "YZWalkManager.h"
#import "YZFlyManager.h"

@interface YZChessViewController ()<YZChessViewDelegate>{
    YZChessView *_kYZChessView;
    NSMutableArray *placeArray;
    NSMutableArray *flyPath;
    NSMutableArray *finishFlyPath;
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
    placeArray = [YZChessPlace initPlace];
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
    NSArray *arrayWalk = [YZWalkManager walkEngine:x Y:y previousArray:placeArray.copy];
    [_kYZChessView setWalkEngineWithArray:arrayWalk];
    _kYZChessView.walkTag = tag;
    
    //设置飞行引擎
    NSDictionary *dict = [YZFlyManager flyManageWithX:x Y:y Camp:camp placeArray:placeArray];
    placeArray = dict[@"placeArray"];
    finishFlyPath = dict[@"finishFlyPath"];
    
    if (finishFlyPath.count > 0) {
        [_kYZChessView setFlyEngineWithArray:finishFlyPath.copy];
        [finishFlyPath removeAllObjects];
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

@end
