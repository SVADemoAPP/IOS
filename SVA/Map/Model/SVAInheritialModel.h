//
//  SVAInheritialModel.h
//  SVA
//
//  Created by XuZongCheng on 16/2/21.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAInheritialModel : SMActivityBaseModel

@property (nonatomic, copy)   NSString  *banThreshold;
@property (nonatomic, assign) NSInteger correctMapDirection;
@property (nonatomic, assign) NSInteger exceedMaxDeviation;
@property (nonatomic, assign) NSInteger filterLength;
@property (nonatomic, copy)   NSString  *filterPeakError;
@property (nonatomic, copy)   NSString  *horizontalWeight;
@property (nonatomic, assign) NSInteger isEnable;
@property (nonatomic, assign) NSInteger maxDeviation;
@property (nonatomic, copy)   NSString  *ongitudinalWeight;
@property (nonatomic, assign) NSInteger peakWidth;
@property (nonatomic, assign) NSInteger restTimes;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, copy)   NSString  *step;

@end
