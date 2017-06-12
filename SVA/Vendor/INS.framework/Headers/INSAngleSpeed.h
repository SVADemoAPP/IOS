//
//  INSAngleSpeed.h
//  INS
//
//  Created by Zeacone on 16/4/14.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "INSConfiguration.h"
#import "INSQueue.h"

@interface INSSensorData : NSObject

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) double z;

@end

@interface INSAngleSpeed : NSObject

@property (nonatomic, assign) double speed;

@property (nonatomic, strong) INSQueue *insQueue;

+ (INSAngleSpeed *)defaultAngleSpeed;

- (void)start;

- (void)stop;

@end
