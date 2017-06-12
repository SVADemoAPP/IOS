//
//  SVADijkstra.m
//  SVA
//
//  Created by 一样 on 16/2/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVADijkstra.h"

static NSInteger tmp = 9999;

@implementation SVADijkstra

+ (NSString *)calculatePathWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix start:(NSInteger)start end:(NSInteger)end {
    //
    
    if (matrix.count == 0) {
        return nil;
    }
    NSMutableArray<NSNumber *> *labeled = [NSMutableArray array];
    //
//    NSMutableArray<NSNumber *> *indexes = [NSMutableArray arrayWithCapacity:matrix[0].count];
    NSMutableArray<NSNumber *> *indexes = [NSMutableArray array];
    for (NSInteger i = 0; i < matrix.count; i++) {
        [indexes addObject:@(0)];
        [labeled addObject:@(NO)];
    }
    
    NSInteger i_count = -1;
    NSMutableArray<NSNumber *> * distance = [matrix[start] mutableCopy];
    NSInteger index = start;
    // 当前的最短路径
    NSInteger currentShortest = 0;
    
    [indexes replaceObjectAtIndex:++i_count withObject:@(index)];
    [labeled replaceObjectAtIndex:index withObject:@(YES)];
    
    while (i_count < matrix[0].count) {
        NSInteger min = NSIntegerMax;
        for (NSInteger i = 0; i < distance.count; i++) {
            if ((!labeled[i].boolValue) && distance[i].integerValue != -1 && i != index) {
                if (distance[i].integerValue < min) {
                    min = distance[i].integerValue;
                    index = i;
                }
            }
        }
        i_count = i_count + 1;
        if (i_count == matrix[0].count) {
            break;
        }
        [labeled replaceObjectAtIndex:index withObject:@(YES)];
        [indexes replaceObjectAtIndex:i_count withObject:@(index)];
        if ((matrix[indexes[i_count - 1].integerValue][index].integerValue == -1) || currentShortest + matrix[indexes[i_count - 1].integerValue][index].integerValue > distance[index].integerValue) {
            currentShortest = distance[index].integerValue;
        } else {
            currentShortest += matrix[indexes[i_count - 1].integerValue][index].integerValue;
        }
        
        for (NSInteger i = 0; i < distance.count; i++) {
            if (distance[i].integerValue == -1 && matrix[index][i].integerValue != -1) {
                [distance replaceObjectAtIndex:i withObject:@(currentShortest + matrix[index][i].integerValue)];
            } else if ((currentShortest + matrix[index][i].integerValue) < distance[i].integerValue && matrix[index][i].integerValue != -1) {
                
                [distance replaceObjectAtIndex:i withObject:@(currentShortest + matrix[index][i].integerValue)];
//                distance[i] = @(currentShortest + matrix[index][i].integerValue);
            }
        }
    }
    NSString *path = [self.class getRoute:matrix indexes:indexes end:end];
    return path;
}

+ (NSString *)getRoute:(NSArray<NSArray<NSNumber *> *> *)matrix indexes:(NSArray<NSNumber *> *)indexes end:(NSInteger)end {
    NSMutableArray<NSString *> *routeArray = [NSMutableArray arrayWithCapacity:indexes.count];
    for (NSInteger i = 0; i < indexes.count; i++) {
        routeArray[i] = @"";
    }
    
    routeArray[indexes[0].integerValue] = [NSString stringWithFormat:@"%@", indexes[0]];
    for (NSInteger i = 1; i < indexes.count; i++) {
        NSArray<NSNumber *> *thePointDis = [NSArray arrayWithArray:matrix[indexes[i].integerValue]];
        NSInteger prePoint = 0;
        tmp = 9999;
        for (NSInteger j = 0; j < thePointDis.count; j++) {
            BOOL chooseFlag = NO;
            for (NSInteger m = 0; m < i; m++) {
                if (j == indexes[m].integerValue) {
                    chooseFlag = YES;
                }
            }
            if (chooseFlag == NO) {
                continue;
            }
            if (thePointDis[j].integerValue < tmp && thePointDis[j].integerValue > 0) {
                prePoint = j;
                tmp = thePointDis[j].integerValue;
            }
        }
        routeArray[indexes[i].integerValue] = [NSString stringWithFormat:@"%@>%@", routeArray[prePoint], indexes[i]];
    }
    return (NSString *)routeArray[end];
}

@end
