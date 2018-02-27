//
//  YZSettings.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZSettings : NSObject

+ (void)firstSetting;

+ (void)changeSettingWithKey:(NSString*)key;

+ (BOOL)isOnWithKey:(NSString*)key;

@end
