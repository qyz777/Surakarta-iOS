//
//  YZChessView.h
//  苏腊卡尔塔棋
//
//  Created by 戚译中 on 2017/12/4.
//  Copyright © 2017年 777. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YZChessViewDelegate <NSObject>

- (void)chessBtnDidTouchWithTag:(NSInteger)tag;
- (void)walkBtnDidTouchWithTag:(NSInteger)tag frameX:(CGFloat)x frameY:(CGFloat)y;
- (void)chessBtnDidEatWithFirstTag:(NSInteger)firstTag lastTag:(NSInteger)lastTag;

@end

@interface YZChessView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UIPickerView *pickView;
@property(strong,nonatomic)UIView *popView;
@property(strong,nonatomic)UIButton *selectPickViewBtn;

@property(assign,nonatomic)NSInteger walkTag;
@property(assign,nonatomic)NSInteger flyTag;

@property(weak,nonatomic)id<YZChessViewDelegate> chessDelegate;

- (void)setWalkEngineWithArray:(NSArray*)array;

- (void)setFlyEngineWithArray:(NSArray*)array;

@end
