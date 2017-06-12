//
//  SVAPathParser.m
//  SVA
//
//  Created by 一样 on 16/2/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAPathParser.h"
#import "GDataXMLNode.h"

@implementation SVAPathParser

+ (NSMutableArray<NSMutableArray<NSNumber *> *> *)getMatrixFromXML:(NSString *)xmlPath {
    
    NSURL *xmlURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml", xmlPath]];
    NSData *data = [NSData dataWithContentsOfURL:xmlURL];
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlPath ofType:@"xml"]];
    if (!data) {
        return nil;
    }
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSError *error = nil;
    NSArray *lines = [xmlDoc nodesForXPath:@"//line" error:&error];
    
    // 初始化矩阵
    NSMutableArray<NSMutableArray<NSNumber *> *> *rows = [NSMutableArray array];
    for (NSInteger i = 0; i < lines.count; i++) {
        NSMutableArray *col = [NSMutableArray array];
        for (NSInteger j = 0; j < lines.count; j++) {
            [col addObject:@(-1)];
            if (i == j) {
                [col replaceObjectAtIndex:j withObject:@(0)];
            }
        }
        [rows addObject:col];
    }
    
    // 按照XML文件中得值为矩阵重新赋值
    for (GDataXMLElement *element in lines) {
        NSString *xString = element.stringValue;
        NSString *yString = [element attributeForName:@"y"].stringValue;
        NSArray *array = [xString componentsSeparatedByString:@","];
        for (NSString *xPoint in array) {
            rows[yString.integerValue][xPoint.integerValue] = @(1);
        }
    }
    return rows;
}

+ (NSMutableArray<NSValue *> *)getPathPointsFromXML:(NSString *)xmlPath {
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil];
    NSString *tmpPath = [NSString stringWithFormat:@"%@.xml", xmlPath];
    NSURL *pathURL = [documentsDirectoryURL URLByAppendingPathComponent:tmpPath];
    
    NSData *data = [NSData dataWithContentsOfURL:pathURL];
    if (!data) {
        return nil;
    }
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSError *error = nil;
    NSArray *points = [xmlDoc nodesForXPath:@"//points" error:&error];
    
    NSMutableArray<NSValue *> *pathPoints = [NSMutableArray array];
    
    for (GDataXMLElement *element in points) {
        NSString *xString = [element attributeForName:@"x"].stringValue;
        NSString *yString = element.stringValue;
        CGPoint pathPoint = CGPointMake(xString.floatValue, yString.floatValue);
        [pathPoints addObject:[NSValue valueWithCGPoint:pathPoint]];
    }
    
    return pathPoints;
}

@end
