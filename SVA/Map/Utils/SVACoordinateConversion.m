//
//  SVACoordinateConversion.m
//  SVA
//
//  Created by Zeacone on 15/12/24.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVACoordinateConversion.h"

@implementation SVACoordinateConversion

/**
 *  根据地图图片的宽高、比例尺以及坐标系，计算定位时的位置以及商家位置
 *
 *  @param x             获取的 x 坐标位置，单位为米
 *  @param y             获取的 y 坐标位置，单位为米
 *  @param width         地图的实际宽度
 *  @param height        地图的实际高度
 *  @param originalScale 地图的实际比例，代表的是 originalScale 个像素为1m
 *  @param touchScale    实际的 UI 缩放比例
 *  @param coordinate    地图的坐标系
 *
 *  @return 实际的可用的坐标位置
 */
+ (CGPoint)getPointWithXspot:(CGFloat)x Yspot:(CGFloat)y onMapMode:(SVAMapDataModel *)mapModel {
    // 全部转换成为 point 来处理
    
    // 将坐标点转化为以像素为单位的坐标
    CGFloat pixelX = x * mapModel.scale.doubleValue;
    CGFloat pixelY = y * mapModel.scale.doubleValue;
   
    // 计算给定的点在地图上的百分比位置
    CGFloat xPercent = pixelX / mapModel.imgWidth;
    CGFloat yPercent = pixelY / mapModel.imgHeight;
    
    
    // 将原点转化为以像素为单位的坐标
    CGFloat pixelXO = mapModel.xo.doubleValue * mapModel.scale.doubleValue;
    CGFloat pixelYO = mapModel.yo.doubleValue * mapModel.scale.doubleValue;
    // 计算原点在地图上的百分比位置
    CGFloat xoPercent = pixelXO / mapModel.imgWidth;
    CGFloat yoPercent = pixelYO / mapModel.imgHeight;
    
    // 计算地图在手机上最初实际展示的大小
    CGFloat scale = mapModel.imgWidth / SCREEN_SIZE.width;
    CGFloat showWidth = SCREEN_SIZE.width;
    CGFloat showHeight = mapModel.imgHeight / scale;
    
    // 计算坐标点显示的实际位置
    CGFloat realX, realY;
    // 先判断坐标系，以便进行坐标转换
    if ([mapModel.coordinate isEqualToString:@"ul"]) {  // up and left
        realX = showWidth * xPercent - showWidth * xoPercent;
        realY = ((SCREEN_SIZE.height - 64 - showHeight) / 2) + showHeight * yPercent - showHeight * yoPercent;
    } else if ([mapModel.coordinate isEqualToString:@"ll"]) {   // low and left
        realX = showWidth * xPercent - showWidth * xoPercent;
        realY = SCREEN_SIZE.height - 64 - (((SCREEN_SIZE.height - 64 - showHeight) / 2) + showHeight * yPercent - showHeight * yoPercent);
    } else if ([mapModel.coordinate isEqualToString:@"ur"]) {   // up and right
        realX = SCREEN_SIZE.width - (showWidth * xPercent - showWidth * xoPercent);
        realY = ((SCREEN_SIZE.height - 64 - showHeight) / 2) + showHeight * yPercent - showHeight * yoPercent;
    } else if ([mapModel.coordinate isEqualToString:@"lr"]) {   // low and right
        realX = SCREEN_SIZE.width - (showWidth * xPercent - showWidth * xoPercent);
        realY = SCREEN_SIZE.height - 64 - (((SCREEN_SIZE.height - 64 - showHeight) / 2) + showHeight * yPercent - showHeight * yoPercent);
    }
    // 返回坐标最终的实际位置
    return CGPointMake(realX, realY);
}

+ (CGPoint)getPathPointWithXspot:(CGFloat)x Yspot:(CGFloat)y onMapMode:(SVAMapDataModel *)mapModel {
    // 全部转换成为 point 来处理
    
    // 将坐标点转化为以像素为单位的坐标
    CGFloat pixelX = x * mapModel.scale.doubleValue;
    CGFloat pixelY = y * mapModel.scale.doubleValue;
    
    // 计算给定的点在地图上的百分比位置
    CGFloat xPercent = pixelX / mapModel.imgWidth;
    CGFloat yPercent = pixelY / mapModel.imgHeight;
    
    
    // 将原点转化为以像素为单位的坐标
    CGFloat pixelXO = mapModel.xo.doubleValue * mapModel.scale.doubleValue;
    CGFloat pixelYO = mapModel.yo.doubleValue * mapModel.scale.doubleValue;
    // 计算原点在地图上的百分比位置
    CGFloat xoPercent = pixelXO / mapModel.imgWidth;
    CGFloat yoPercent = pixelYO / mapModel.imgHeight;
    
    // 计算地图在手机上最初实际展示的大小
    CGFloat scale = mapModel.imgWidth / SCREEN_SIZE.width;
    CGFloat showWidth = SCREEN_SIZE.width;
    CGFloat showHeight = mapModel.imgHeight / scale;
    
    // 计算坐标点显示的实际位置
    CGFloat realX, realY;
    
    realX = showWidth * xPercent - showWidth * xoPercent;
    realY = ((SCREEN_SIZE.height - 64 - showHeight) / 2) + showHeight * yPercent - showHeight * yoPercent;
    // 返回坐标最终的实际位置
    return CGPointMake(realX, realY);
}

+ (void)setScale:(UILabel *)label andImage:(UIImageView *)image WithMapModel:(SVAMapDataModel *)mapModel touchScale:(CGFloat)touchScale {
    //
    CGFloat newScale = mapModel.imgWidth / SCREEN_SIZE.width / mapModel.scale.doubleValue * 40 / touchScale;
    CGFloat newWidth = (newScale - (NSInteger)newScale + 1) * 40;
    NSInteger newIntScale = (NSInteger)(newScale + 0.5);
    label.text = [NSString stringWithFormat:@"%@m", @(newIntScale)];
    CGRect oldframe = label.frame;
    oldframe.size.width = newWidth;
    label.frame = oldframe;
    CGRect oldImageframe = image.frame;
    oldImageframe.size.width = newWidth;
    image.frame = oldImageframe;
}

@end
