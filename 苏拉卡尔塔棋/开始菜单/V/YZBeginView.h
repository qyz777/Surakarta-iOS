//
//  YZBeginView.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZBeginViewDelegate <NSObject>

- (void)userDidTouchPVPBtn;

@end

@interface YZBeginView : UIView

@property(strong,nonatomic)UIButton *pvpBtn;
@property(strong,nonatomic)UIButton *pveBtn;
@property(weak,nonatomic)id<YZBeginViewDelegate> beginViewDelegate;

@end
