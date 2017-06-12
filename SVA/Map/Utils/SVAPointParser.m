//
//  SVAPointParser.m
//  SVA
//
//  Created by Zeacone on 16/1/27.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAPointParser.h"
#import "GDataXMLNode.h"

@implementation SVAPointParser

- (NSMutableArray<NSValue *> *)getPointsFromXML:(NSURL *)xmlPath
                                      withScale:(CGFloat)scale
                                       mapWidth:(NSInteger)width
                                      mapHeight:(NSInteger)height {
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"path" ofType:@"xml"]];
    NSData *data = [NSData dataWithContentsOfURL:xmlPath];
    if (!data) {
        return nil;
    }
    
    NSMutableArray<NSValue *> *pointsArray = [NSMutableArray array];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *lines = [xmlDoc nodesForXPath:@"//line" error:nil];
    for (GDataXMLElement *element in lines) {
        NSString *xString = element.stringValue;
        NSString *yString = [element attributeForName:@"y"].stringValue;
        NSArray *array = [xString componentsSeparatedByString:@","];
        for (NSString *xPoint in array) {
            
#warning 此处改变是为了泰国的路径滤波制作问题
            CGFloat realY = height - yString.integerValue;
            // Because the default unit of path filter length is pixel, so it should be transformed to be decimetre.
            CGPoint point = CGPointMake(xPoint.integerValue / scale * 10, realY / scale * 10);
            
            if (![pointsArray containsObject:[NSValue valueWithCGPoint:point]]) {
                [pointsArray addObject:[NSValue valueWithCGPoint:point]];
            }
        }
    }
    return pointsArray;
}

@end
