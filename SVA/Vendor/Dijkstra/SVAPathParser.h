//
//  SVAPathParser.h
//  SVA
//
//  Created by 一样 on 16/2/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAPathParser : NSObject

+ (NSMutableArray<NSMutableArray<NSNumber *> *> *)getMatrixFromXML:(NSString *)xmlPath;

+ (NSMutableArray<NSValue *> *)getPathPointsFromXML:(NSString *)xmlPath;

@end
