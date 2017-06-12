//
//  ScaleStore.m
//  SVA
//
//  Created by 君若见故 on 16/2/19.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ScaleStore.h"

@implementation ScaleStore

+ (instancetype)defaultScale {

    static ScaleStore *scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [[self alloc] init];
        scale.scale = 1;
        scale.inheritialParameters = [NSMutableArray array];
    });
    return scale;
}


@end
