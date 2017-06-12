//
//  SVAPathFilter.h
//  SVA
//
//  Created by Zeacone on 16/1/25.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFFilter : NSObject

@property (nonatomic, strong) NSMutableArray<NSValue *> *fingerPrintXY;

+ (instancetype)sharedPathFilter;
- (CGPoint)calculatePathFilterPoint:(CGPoint)locate;

@end
