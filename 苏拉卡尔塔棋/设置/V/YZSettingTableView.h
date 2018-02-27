//
//  YZSettingTableView.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZSettingTableViewDelegate <NSObject>

- (void)eatSourceDidSwitch;
- (void)goSourceDidSwitch;
- (void)vibrationDidSwitch;
- (BOOL)switchStateWithSection:(NSInteger)section;

@end

@interface YZSettingTableView : UITableView<UITableViewDelegate,UITableViewDataSource>



@property(nonatomic,weak)id<YZSettingTableViewDelegate> settingDelegate;

@end
