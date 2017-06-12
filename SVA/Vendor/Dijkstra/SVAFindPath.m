//
//  SVAFindPath.m
//  SVA
//
//  Created by 一样 on 16/2/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAFindPath.h"
#import "SVADijkstra.h"

@interface SVAFindPath ()

@end

@implementation SVAFindPath

+ (CGPoint)getNearestPointWithPoint:(CGPoint)point withPoints:(NSArray<NSValue *> *)points {

    // 临时距离
    double tmp_distance = 0;
    // 最短距离
    double shortest_dis = 0;
    // 所找到的点
    CGPoint find_point;
    
    NSInteger x0 = point.x;
    NSInteger y0 = point.y;
    
    for (NSValue *pointValue in points) {
        tmp_distance = sqrt(pow(x0 - pointValue.CGPointValue.x, 2) + pow(y0 - pointValue.CGPointValue.y, 2));
        if (shortest_dis == 0 || shortest_dis > tmp_distance) {
            shortest_dis = tmp_distance;
            find_point = pointValue.CGPointValue;
        }
    }
    return find_point;
}

+ (NSArray<NSValue *> *)findPathWithStart:(CGPoint)start end:(CGPoint)end onModel:(SVAMapDataModel *)mapModel {
    // 拼接路径文件的地址，商场名字+楼层
    NSString *xmlPath = [NSString stringWithFormat:@"%@%@", mapModel.place, mapModel.floor];
    NSArray<NSValue *> *pathPoints = [SVAPathParser getPathPointsFromXML:xmlPath];
    
    // 寻找起点终点最近的路径点
    CGPoint realStartPoint = [self.class getNearestPointWithPoint:start withPoints:pathPoints];
    CGPoint realEndPoint = [self.class getNearestPointWithPoint:end withPoints:pathPoints];
    
    NSInteger startNo = 0, endNo = 0;
    for (NSInteger i = 0; i < pathPoints.count; i++) {
        
        if (CGPointEqualToPoint(pathPoints[i].CGPointValue, realStartPoint)) {
            startNo = i;
        }
        if (CGPointEqualToPoint(pathPoints[i].CGPointValue, realEndPoint)) {
            endNo = i;
        }
    }
    
    if (!pathPoints && pathPoints.count == 0) {
        return nil;
    }
    NSString *path = [SVADijkstra calculatePathWithMatrix:[SVAPathParser getMatrixFromXML:xmlPath] start:startNo end:endNo];
    
    NSArray *pointNo = [path componentsSeparatedByString:@">"];
    NSMutableArray<NSValue *> *pointValue = [NSMutableArray array];
    for (NSString *no in pointNo) {
        [pointValue addObject:pathPoints[no.integerValue]];
    }
    return pointValue;
}

@end
