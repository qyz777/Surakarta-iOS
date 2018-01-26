//
//  YZMenuView.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZMenuViewDelegate <NSObject>

- (void)userDidTouchBeginBtn;

@end

@interface YZMenuView : UIView

@property(strong,nonatomic)UIButton *beginBtn;
@property(strong,nonatomic)UIButton *settingBtn;
@property(weak,nonatomic)id<YZMenuViewDelegate> menuViewDelegate;


@end
