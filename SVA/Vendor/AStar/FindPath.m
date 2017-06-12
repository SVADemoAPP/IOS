//
//  IndoorMapViewNew.m
//  WisdomMallAPP
//
//  Created by apple on 14-1-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "FindPath.h"

#define IMAGE_SIZE      15.0f

@implementation FindPath

- (NSMutableArray *)pathArray {
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (AStar *)astar {
    if (!_astar) {
        _astar = [AStar new];
    }
    return _astar;
}

#pragma mark - get path Point

/**
 *  获取线段集合
 *
 *  @param filePath 路径
 *
 *  @return 线段集合
 */
- (NSMutableArray *)fetchPathPairPoint:(NSString *)filePath {
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:filePath ofType:@"txt"];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSData *lineData;
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    while ((lineData = [fileHandle readLineWithDelimiter:@"\n"])) {
        NSString *lineString = [[NSString alloc] initWithData:lineData encoding:NSUTF8StringEncoding];
        
        //#号为注释
        if ([lineString characterAtIndex:0] == '#') {
            continue;
        }
        NSString *replaceStr = [lineString stringByReplacingOccurrencesOfString:@"(" withString:@"{"];
        NSString *replaceStr1 = [replaceStr stringByReplacingOccurrencesOfString:@")" withString:@"}"];
        
        NSArray *array = [replaceStr1 componentsSeparatedByString:@"-"];
        if (array) {
            ItemRelation *relation = [[ItemRelation alloc] init];
            for (int i = 0; i < array.count; i++) {
                
                NSString *pointStr = [array objectAtIndex:i];
                pointStr = [pointStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                pointStr = [pointStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                if (![points containsObject:pointStr]) {
                    [points addObject:pointStr];
                }
                
                CGPoint point = CGPointFromString(pointStr);
                if (i == 0) {
                    relation.point1.col = point.x;
                    relation.point1.row = point.y;
                } else {
                    relation.point2.col = point.x;
                    relation.point2.row = point.y;
                }
            }
            //关系点集合
            [self.astar.relationArray addObject:relation];
        }
    }
    
    for (NSString *pointStr in points) {
        AStarItem *item = [[AStarItem alloc] init];
        CGPoint point = CGPointFromString(pointStr);
        
        [item setPos:point.x row:point.y];
        //结点集合
        [results addObject:item];
    }
    return results;
}

/**
 *  画商场地图路径
 */
- (NSMutableArray *)findPathStartX:(CGFloat)startX
                             statY:(CGFloat)startY
                              endX:(CGFloat)endX
                              endY:(CGFloat)endY
                          filePath:(NSString *)filePath {

    NSMutableArray *points = [self fetchPathPairPoint:filePath];
    self.astar.allPointsArray = [points mutableCopy];
    
    NSMutableArray *pathsArray = [[NSMutableArray alloc] init];
    
    //转换成与路径点相同的坐标系
    CGFloat x_start = startX;
    CGFloat y_start = startY;
    CGFloat x_end = endX;
    CGFloat y_end = endY;
    
    AStarItem *item_start_nearest = [self.astar findNearestPoint:x_start row:y_start];
    AStarItem *item_end_nearest = [self.astar findNearestPoint:x_end row:y_end];

    self.finalPath = [self.astar findPath:item_start_nearest.id_col
                         curY:item_start_nearest.id_row
                         aimX:item_end_nearest.id_col
                         aimY:item_end_nearest.id_row
                     withPath:nil];
    
    //添加起点，终点两头
    AStarItem *itemStart = [[AStarItem alloc] init];
    itemStart.id_col = x_start;
    itemStart.id_row = y_start;
    
    AStarItem *itemEnd = [[AStarItem alloc] init];
    itemEnd.id_col = x_end;
    itemEnd.id_row = y_end;
    [self.finalPath insertObject:itemStart atIndex:0];
    [self.finalPath addObject:itemEnd];
    
    pathsArray = [self.finalPath mutableCopy];
    return pathsArray;
}

@end
