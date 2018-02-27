//
//  YZSettings.m
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/2/27.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import "YZSettings.h"

@implementation YZSettings

+ (void)firstSetting{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"goChessSource"];
    if (!str) {
        NSString *shortStr = @"on";
        [[NSUserDefaults standardUserDefaults]setObject:shortStr forKey:@"goChessSource"];
        [[NSUserDefaults standardUserDefaults]setObject:shortStr forKey:@"eatChessSource"];
        [[NSUserDefaults standardUserDefaults]setObject:shortStr forKey:@"vibrate"];
    }
}

+ (void)changeSettingWithKey:(NSString*)key{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if ([str isEqualToString:@"on"]) {
        str = @"off";
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:key];
    }else {
        str = @"on";
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:key];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (BOOL)isOnWithKey:(NSString*)key{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if ([str isEqualToString:@"on"]) {
        return true;
    }else {
        return false;
    }
}

@end
