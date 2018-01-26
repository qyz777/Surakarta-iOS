//
//  YZChessViewController.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,chessGameMode){
    chessGameModePVP = 0,
    chessGameModePVE
};

@interface YZChessViewController : UIViewController

@property(assign,nonatomic)chessGameMode gameMode;

@end
