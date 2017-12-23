//
//  ViewController.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2017/12/20.
//  Copyright © 2017年 Q YiZhong. All rights reserved.
//

#import "ViewController.h"
#import "YZChessView.h"

@interface ViewController (){
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
    [self.view addSubview:_kYZChessView];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"下拉"] style:UIBarButtonItemStyleDone target:self action:@selector(pressRightBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    placeArray = [[NSMutableArray alloc]init];
    for (int i=0; i<36; i++) {
        if (i<12) {
            placeArray[i] = @-1;
        }else if (i<24){
            placeArray[i] = @0;
        }else if (i<36){
            placeArray[i] = @1;
        }
    }
}

- (void)pressRightBtn{
    
}

@end
