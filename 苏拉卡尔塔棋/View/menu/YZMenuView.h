//
//  YZMenuView.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/1/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZMenuViewDelegate <NSObject>

- (void)userDidTouchPVPBtn;
- (void)userDidTouchPVEBtn;
- (void)userDidTouchSettingBtn;

@end

@interface YZMenuView : UIView

@property(strong,nonatomic)UIButton *beginBtn;
@property(strong,nonatomic)UIButton *settingBtn;
@property(strong,nonatomic)UIButton *pvpBtn;
@property(strong,nonatomic)UIButton *pveBtn;
@property(strong,nonatomic)UIButton *backBtn;
@property(weak,nonatomic)id<YZMenuViewDelegate> menuViewDelegate;


@end
