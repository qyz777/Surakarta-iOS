//
//  YZNormalAITactics.h
//  苏拉卡尔塔棋
//
//  Created by Q YiZhong on 2018/3/16.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZNormalAITactics : NSObject

+ (NSDictionary*)openingTacticsWithChessPlace:(NSArray*)chessPlace StepNum:(NSInteger)num;

@end
