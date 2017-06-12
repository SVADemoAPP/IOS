//
//  SVACoordinateConversion.h
//  SVA
//
//  Created by Zeacone on 15/12/24.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVACoordinateConversion : NSObject

+ (CGPoint)getPointWithXspot:(CGFloat)x Yspot:(CGFloat)y onMapMode:(SVAMapDataModel *)mapModel;
+ (CGPoint)getPathPointWithXspot:(CGFloat)x Yspot:(CGFloat)y onMapMode:(SVAMapDataModel *)mapModel;

+ (void)setScale:(UILabel *)label andImage:(UIImageView *)image WithMapModel:(SVAMapDataModel *)mapModel touchScale:(CGFloat)touchScale;

@end
