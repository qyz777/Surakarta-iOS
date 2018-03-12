//
//  YZChessView.h
//  苏腊卡尔塔棋
//
//  Created by 戚译中 on 2017/12/4.
//  Copyright © 2017年 777. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YZChessViewDelegate <NSObject>

- (void)closeBtnDidTouchUpInside;
- (void)backBtnDidTouchUpInside;
- (void)chessBtnDidTouchWithTag:(NSInteger)tag;
- (void)walkBtnDidTouchWithTag:(NSInteger)tag frameX:(CGFloat)x frameY:(CGFloat)y;
- (void)chessBtnDidEatWithFirstTag:(NSInteger)firstTag lastTag:(NSInteger)lastTag;

@end

@interface YZChessView : UIView

@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UIButton *closeBtn;
@property(strong,nonatomic)UIButton *backBtn;

@property(assign,nonatomic)NSInteger walkTag;
@property(assign,nonatomic)NSInteger flyTag;
@property(assign,nonatomic)BOOL isRedChess;

@property(weak,nonatomic)id<YZChessViewDelegate> chessDelegate;

- (void)setWalkEngineWithArray:(NSArray*)array;

- (void)setFlyEngineWithArray:(NSArray*)array;

- (void)redChessGo;

- (void)blueChessGo;

- (void)resetChessPlaceWithArray:(NSArray*)array;

@end
