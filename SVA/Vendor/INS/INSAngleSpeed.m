//
//  INSAngleSpeed.m
//  INS
//
//  Created by Zeacone on 16/4/14.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "INSAngleSpeed.h"
#import "INSConfiguration.h"

#define CONFIG [INSConfiguration defaultConfiguration]

static dispatch_queue_t ins_speed_manager_queue() {
    static dispatch_queue_t ins_speed_manager_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins_speed_manager_queue = dispatch_queue_create("com.ins.speed.manager.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return ins_speed_manager_queue;
}

@implementation INSSensorData

@end

@interface INSAngleSpeed ()
{
    CMMotionManager *cmManager;
}

@end

@implementation INSAngleSpeed

+ (INSAngleSpeed *)defaultAngleSpeed {
    
    static INSAngleSpeed *angleSpeed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        angleSpeed = [INSAngleSpeed new];
        angleSpeed.insQueue = [[INSQueue alloc] initWithQueue:ins_speed_manager_queue()];
    });
    return angleSpeed;
}

- (void)start {
    
    dispatch_async(ins_speed_manager_queue(), ^{
        [self startAcceleration];
    });
}

- (void)stop {
    
    
}

- (void)startAcceleration {
    
    cmManager = [[CMMotionManager alloc] init];
    
    if (cmManager.accelerometerAvailable) {
        cmManager.accelerometerUpdateInterval = 1.0 / 50.0;
        [cmManager startAccelerometerUpdates];
        [self fetchAccelerometerData];
    } else {
        NSLog(@"传感器不可用。");
    }
}

- (void)fetchAccelerometerData {

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(startFetchData) userInfo:nil repeats:YES];
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runloop run];
    [timer fire];
}

- (void)startFetchData {
    
    INSSensorData *sensorData = [INSSensorData new];

    sensorData.x = cmManager.accelerometerData.acceleration.x;
    sensorData.y = cmManager.accelerometerData.acceleration.y;
    sensorData.z = cmManager.accelerometerData.acceleration.z;

    [self.insQueue enqueue:sensorData];

    // 在子线程中调用速度计算
    [self calculateVelocity];
}

/**
 *  根据加速度计的数据计算行走速度
 */
- (void)calculateVelocity {
    
    // 在队列中获取传感器数据
    NSArray<INSSensorData *> *accelerometerData = [self.insQueue fetchQueueData];
    
    if (self.insQueue.count < 60) {
        
        NSLog(@"Not have enough data yet.");
        self.speed = .0;
        return;
    }
    
    // ① 对传感器数据进行平滑处理
    NSArray<NSNumber *> *smoothArray = [self smoothArray:accelerometerData];
    // ② 找出平滑数据的波峰
    NSArray *frequence = [self findWaveCrest:smoothArray];
    // ③ 根据波峰算出速度
    double velocity = [self calculateVelocityWithFrequence:frequence];
    
    NSLog(@"Velocity is %@", @(velocity));
    
    self.speed = velocity;
}

/**
 *  对数据进行平滑处理
 */
- (NSArray<NSNumber *> *)smoothArray:(NSArray<INSSensorData *> *)array {
    
    NSMutableArray<NSNumber *> *smoothArray = [NSMutableArray array];
    
    // 获取50组数据用于平滑窗口
    for (NSInteger i = CONFIG.smoothWindow / 2 - 1; i < CONFIG.sampleNumber + CONFIG.smoothWindow / 2; i++) {
        
        double smooth_accx = .0, smooth_accy = .0, smooth_accz = .0, smooth_acc_sum = .0;
        
        for (NSInteger j = 0; j < CONFIG.smoothWindow; j++) {
            
            // 9-----0
            // 10-----1
            // 11-----2
            // ...
            // 59-----50
            smooth_accx += array[i + CONFIG.smoothWindow / 2 - j].x;
            smooth_accy += array[i + CONFIG.smoothWindow / 2 - j].y;
            smooth_accz += array[i + CONFIG.smoothWindow / 2 - j].z;
        }
        
        smooth_acc_sum = pow(smooth_accx / CONFIG.smoothWindow, 2.0) + pow(smooth_accy / CONFIG.smoothWindow, 2.0) + pow(smooth_accz / CONFIG.smoothWindow, 2.0);
        
        [smoothArray addObject:[NSNumber numberWithDouble:smooth_acc_sum]];
    }
    return [smoothArray copy];
}

/**
 *  找到速度波峰
 *
 *  @param wavecrest 原始数据
 */
- (NSArray<NSNumber *> *)findWaveCrest:(NSArray<NSNumber *> *)wavecrest {
    
    static double last_top_acc_index = 0;
    
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    [array addObject:[NSNumber numberWithDouble:last_top_acc_index]];
    
    for (NSInteger i = 1; i < wavecrest.count - 1; i++) {
        
        BOOL bigGreaterThanBefore = (wavecrest[i].doubleValue - wavecrest[i - 1].doubleValue) > pow(CONFIG.accValueTh, 2.0);
        BOOL greaterThanLater = (wavecrest[i].doubleValue - wavecrest[i + 1].doubleValue) > 0;
        
        BOOL greaterThanBefore = (wavecrest[i].doubleValue - wavecrest[i - 1].doubleValue) > 0;
        BOOL bigGreaterThanLater = (wavecrest[i].doubleValue - wavecrest[i + 1].doubleValue) > pow(CONFIG.accValueTh, 2.0);
        
        if ((bigGreaterThanBefore && greaterThanLater) || (greaterThanBefore && bigGreaterThanLater)) {
            [array addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    if (array.count == 0) {
        last_top_acc_index = array.lastObject.integerValue;
    } else if (last_top_acc_index > -(CONFIG.sampleNumber * 10)) {
        last_top_acc_index -= CONFIG.sampleNumber;
    }
    
    return [array copy];
}

- (double)calculateVelocityWithFrequence:(NSArray<NSNumber *> *)wavecrest {
    
//    double velocity = .0;
    NSInteger steps = 0;
    
    for (NSInteger i = 0; i < wavecrest.count; i++) {
        for (NSInteger j = i + 1; j < wavecrest.count; j++) {
            if (j == i) {
                continue;
            }
            if (wavecrest[j].integerValue - wavecrest[i].integerValue > CONFIG.accTimeTh) {
                if (steps == 0 || steps > wavecrest[j].integerValue - wavecrest[i].integerValue) {
                    steps = wavecrest[j].integerValue - wavecrest[i].integerValue;
                }
            }
        }
    }
    
    if (steps == 0) {
        return .0;
    }
    
    return CONFIG.defaultStepLength * (double)CONFIG.sampleNumber / (double)steps;
}

@end
