//
//  INSConfiguration.h
//  INS
//
//  Created by Zeacone on 16/4/16.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INSConfiguration : NSObject

/**
 *  取样数据，默认为1s钟50组数据
 */
@property (nonatomic, assign) NSInteger sampleNumber;

/**
 *  平滑窗口，默认为10组数据
 */
@property (nonatomic, assign) NSInteger smoothWindow;

/**
 *  加速度灵敏度
 */
@property (nonatomic, assign) double accValueTh;

/**
 *  暂时不明白
 */
@property (nonatomic, assign) NSInteger accTimeTh;

/**
 *  步伐长度，默认0.6m
 */
@property (nonatomic, assign) double defaultStepLength;

/**
 *  横向错误权重
 */
@property (nonatomic, assign) double DIRECTION_LOC_WEIGHT;

/**
 *  纵向错误权重
 */
@property (nonatomic, assign) double CROSS_LOC_WEIGHT;

/**
 *  默认地图的偏向角
 */
@property (nonatomic, assign) double DEFAULT_NAV_ANGLE;

/**
 *  静止速度门限
 */
@property (nonatomic, assign) double STAY_SPEED_TH;

/**
 *  静止速度门限次数
 */
@property (nonatomic, assign) NSInteger STAY_SPEED_TH_COUNT;

/**
 *  定位错误精度门限
 */
@property (nonatomic, assign) double LOC_ERROR_TH;

/**
 *  定位错误次数门限
 */
@property (nonatomic, assign) NSInteger LOC_ERROR_TH_COUNT;


////////////////////////// Record Zone ///////////////////////

@property (nonatomic, assign) NSInteger stayCount;
@property (nonatomic, assign) NSInteger ErrorLocationCount;

/**
 *  使用单例来保存所有惯性导航所需要的参数
 *
 *  @return 返回配置类单例
 */
+ (INSConfiguration *)defaultConfiguration;

- (void)setupNewValue:(NSDictionary *)configure;

@end
