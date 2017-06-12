//
//  SVAFindPath.h
//  SVA
//
//  Created by 一样 on 16/2/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVAPathParser.h"
#import "AOShortestPath.h"

@interface SVAFindPath : NSObject

+ (NSArray<NSValue *> *)findPathWithStart:(CGPoint)start end:(CGPoint)end onModel:(SVAMapDataModel *)mapModel;

@end
