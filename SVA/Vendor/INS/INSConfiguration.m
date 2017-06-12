//
//  INSConfiguration.m
//  INS
//
//  Created by Zeacone on 16/4/16.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "INSConfiguration.h"

@implementation INSConfiguration

+ defaultConfiguration {
    
    static INSConfiguration *configuratoin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuratoin = [INSConfiguration new];
        [configuratoin setupDefaultValue];
    });
    return configuratoin;
}

- (void)setupDefaultValue {
    
    self.sampleNumber         = 50;
    self.smoothWindow         = 10;
    self.accValueTh           = 0.1;
    self.accTimeTh            = 15;
    self.defaultStepLength    = 0.6;
    self.DIRECTION_LOC_WEIGHT = 0.04;
    self.CROSS_LOC_WEIGHT     = 0.02;
    self.DEFAULT_NAV_ANGLE    = 270;
    self.STAY_SPEED_TH        = 0.3;
    self.STAY_SPEED_TH_COUNT  = 1;
    self.LOC_ERROR_TH         = 8.0;
    self.LOC_ERROR_TH_COUNT   = 5;
    
    self.stayCount            = 0;
    self.ErrorLocationCount   = 0;
}

- (void)setupNewValue:(SVAInheritialModel *)model {
    
    self.DEFAULT_NAV_ANGLE = model.correctMapDirection;
    self.accValueTh = model.filterPeakError.doubleValue;
    self.defaultStepLength = model.step.doubleValue;
    self.accTimeTh = model.peakWidth;
    self.DIRECTION_LOC_WEIGHT = model.horizontalWeight.doubleValue;
    self.CROSS_LOC_WEIGHT = model.ongitudinalWeight.doubleValue;
    self.STAY_SPEED_TH = model.banThreshold.doubleValue;
    self.STAY_SPEED_TH_COUNT = model.restTimes;
    self.LOC_ERROR_TH = model.maxDeviation;
    self.LOC_ERROR_TH_COUNT = model.exceedMaxDeviation;
    self.smoothWindow = model.filterLength;
}

@end
