//
//  YZChessView.h
//  苏腊卡尔塔棋
//
//  Created by 戚译中 on 2017/12/4.
//  Copyright © 2017年 777. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YZChessViewDelegate <NSObject>

/**
 关闭按钮被点击
 */
- (void)closeBtnDidTouchUpInside;

/**
 悔棋按钮被点击
 */
- (void)backBtnDidTouchUpInside;

/**
 棋子被点击

 @param tag 被点击棋子的标签
 */
- (void)chessBtnDidTouchWithTag:(NSInteger)tag;

/**
 棋子下子后被调用

 @param tag 下子的棋子
 @param x 棋子frame上的x坐标
 @param y 棋子frame上的y坐标
 */
- (void)walkBtnDidTouchWithTag:(NSInteger)tag frameX:(CGFloat)x frameY:(CGFloat)y;

/**
 棋子被吃后调用

 @param firstTag 吃子的棋子标签
 @param lastTag 被吃的棋子标签
 */
- (void)chessBtnDidEatWithFirstTag:(NSInteger)firstTag lastTag:(NSInteger)lastTag;

/**
 玩家下子或吃子完的协议，供AI下子
 */
- (void)AIShouldGo;

@end

@interface YZChessView : UIView

@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UIButton *closeBtn;
@property(strong,nonatomic)UIButton *backBtn;

@property(assign,nonatomic)NSInteger walkTag;
@property(assign,nonatomic)NSInteger flyTag;

@property(assign,nonatomic)BOOL isRedChess;
@property(assign,nonatomic)BOOL isAIType;
@property(assign,nonatomic)BOOL isAIRed;

@property(weak,nonatomic)id<YZChessViewDelegate> chessDelegate;

- (void)setWalkEngineWithArray:(NSArray*)array;

- (void)setFlyEngineWithArray:(NSArray*)array;


/**
 红棋子走下一步
 */
- (void)redChessGo;

/**
 蓝棋子走下一步
 */
- (void)blueChessGo;

/**
 重置棋盘，供悔棋使用

 @param array 传入棋盘
 */
- (void)resetChessPlaceWithArray:(NSArray*)array;

/**
 AI下子接口

 @param dict 数据字典
 */
- (void)setAIWalkWithDict:(NSDictionary*)dict;

/**
 AI吃子接口

 @param dict 数据字典
 */
- (void)setAIFlyWithDict:(NSDictionary*)dict;

/**
 AI下红子
 */
- (void)AIRedChessGo;

/**
 AI下蓝子
 */
- (void)AIBlueChessGo;

@end
