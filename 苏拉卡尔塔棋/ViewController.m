//
//  ViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2017/12/20.
//  Copyright © 2017年 Q YiZhong. All rights reserved.
//

#import "ViewController.h"
#import "YZChessView.h"
#import "YZChessPlace.h"

@interface ViewController ()<YZChessViewDelegate>{
    YZChessView *_kYZChessView;
    NSMutableArray *placeArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    _kYZChessView = [[YZChessView alloc]init];
    _kYZChessView.chessDelegate = self;
    [self.view addSubview:_kYZChessView];
    
    placeArray = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"下拉"] style:UIBarButtonItemStyleDone target:self action:@selector(pressRightBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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

- (void)pressRightBtn{
    
}

#pragma make - 协议
- (void)ChessBtnDidTouchWithTag:(NSInteger)tag{
    NSInteger x = 0;
    NSInteger y = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<6; j++) {
            YZChessPlace *p = placeArray[i][j];
            if (p.tag == tag) {
                x = p.x;
                y = p.y;
            }
        }
    }
    
    NSArray *array = [self walkEngine:x Y:y];
    NSLog(@"%@",array);
    [_kYZChessView setWalkEngineWithArray:array];
    _kYZChessView.walkTag = tag;
}

- (void)walkBtnDidTouchWithTag:(NSInteger)tag X:(CGFloat)x Y:(CGFloat)y{
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
