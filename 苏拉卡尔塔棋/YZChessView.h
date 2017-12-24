//
//  YZChessView.h
//  苏腊卡尔塔棋
//
//  Created by 戚译中 on 2017/12/4.
//  Copyright © 2017年 777. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YZChessViewDelegate <NSObject>

- (void)ChessBtnDidTouchWithTag:(NSInteger)tag;
- (void)walkBtnDidTouchWithTag:(NSInteger)tag X:(CGFloat)x Y:(CGFloat)y;

@end

@interface YZChessView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UIPickerView *pickView;
@property(strong,nonatomic)UIView *popView;
@property(strong,nonatomic)UIButton *selectPickViewBtn;

@property(assign,nonatomic)NSInteger walkTag;

@property(weak,nonatomic)id<YZChessViewDelegate> chessDelegate;

- (void)setWalkEngineWithArray:(NSArray*)array;

@end
