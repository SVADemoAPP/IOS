//
//  MyLocator.m
//  svaDemo
//
//  Created by XuZongCheng on 16/1/12.
//  Copyright © 2016年 XuZongCheng. All rights reserved.
//


#import <GameplayKit/GameplayKit.h>
#import "INSConfiguration.h"
#import "INSLocator.h"

#define NAV_ANGLE 240

#define CONFIG [INSConfiguration defaultConfiguration]

@implementation INSLocator

// 上一次定位的坐标
static float last_loc_x = .0;
static float last_loc_y = .0;

/**
 *  根据给定的参数按照惯性导航算法计算出优化后的坐标点
 *
 *  @param x        原始定位点的 X 值
 *  @param y        原始定位点的 Y 值
 *  @param heading  磁力计的偏向角以及地图本身的偏向角
 *  @param velocity 行走的速度
 *
 *  @return 经过惯导算法计算的定位坐标点
 */
+ (CGPoint)newLocationWithX:(CGFloat)x Y:(CGFloat)y headingAngle:(double)heading Velocity:(double)velocity {
    
    // 获取惯导参数
    
    
    double tmp_x = .0;
    double tmp_y = .0;
    
    // 计算惯导偏向角
    heading += heading + CONFIG.DEFAULT_NAV_ANGLE / 180.0 * M_PI;
    
    if (heading > M_PI * 2) {
        heading = fmodf(heading, M_PI * 2);
    }
    
    // 为什么这么写？
    heading = M_PI - heading;
    
    
    tmp_x = last_loc_x != .0 ? last_loc_x : x;
    tmp_y = last_loc_y != .0 ? last_loc_y : y;
    
    // 计算速度在某个坐标轴上的位移
    tmp_x += velocity * cos(heading);
    tmp_y += velocity * sin(heading);
    
    // 计算上次定位点与本次定位点的距离
    double distance = sqrt(pow(tmp_x - x, 2.0) + pow(tmp_y - y, 2.0));
    
    // 两次定位点分别在 x 轴和 y 轴上的位移
    double loc_dx = x - tmp_x;
    double loc_dy = y - tmp_y;
    
    // 横向权重
    tmp_x += CONFIG.DIRECTION_LOC_WEIGHT * (loc_dx * cos(heading) + loc_dy * sin(heading) * cos(heading));
    tmp_y += CONFIG.DIRECTION_LOC_WEIGHT * (loc_dx * cos(heading) + loc_dy * sin(heading) * sin(heading));
    
    // 纵向权重
    tmp_x += CONFIG.DIRECTION_LOC_WEIGHT * (loc_dx * sin(heading) + loc_dy * cos(heading) * cos(heading));
    tmp_y += CONFIG.DIRECTION_LOC_WEIGHT * (loc_dx * sin(heading) + loc_dy * cos(heading) * sin(heading));
    
    // 如果速度小于静止速度门限
    if (velocity < CONFIG.STAY_SPEED_TH) {
        
        CONFIG.stayCount += 1;
        
        if (CONFIG.stayCount >= CONFIG.STAY_SPEED_TH_COUNT) {
            
            tmp_x = last_loc_x != .0 ?: tmp_x;
            tmp_y = last_loc_y != .0 ?: tmp_y;
        }
    } else if(distance > CONFIG.LOC_ERROR_TH) {
        
        // 如果两次点的距离超过定位误差门限
        CONFIG.stayCount = 0;
        CONFIG.ErrorLocationCount += 1;
        
        if(CONFIG.ErrorLocationCount >= CONFIG.LOC_ERROR_TH_COUNT) {
            
            tmp_x = x;
            tmp_y = y;
        }
    } else {
        CONFIG.ErrorLocationCount = 0;
    }
    
    last_loc_x = tmp_x;
    last_loc_y = tmp_y;
    
    return CGPointMake(tmp_x, tmp_y);
}

@end
