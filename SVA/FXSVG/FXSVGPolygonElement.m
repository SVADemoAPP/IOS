//
//  FXSVGPolygonElement.m
//  FSInteractiveMap
//
//  Created by Zeacone on 16/1/7.
//  Copyright © 2016年 Arthur GUIBERT. All rights reserved.
//

#import "FXSVGPolygonElement.h"

@implementation FXSVGPolygonElement

- (NSMutableArray *)realpPoints {
    if (!_realpPoints) {
        _realpPoints = [NSMutableArray array];
    }
    return _realpPoints;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
//    self.fillColor = [UIColor blackColor];
    
    NSString *points = [attributes objectForKey:@"points"];
    NSArray *array = [points componentsSeparatedByString:@" "];
    for (NSString *string in array) {
        if (string.length != 0) {
            CGPoint point = CGPointFromString([NSString stringWithFormat:@"{%@}", string]);
            NSValue *value = [NSValue valueWithCGPoint:point];
            [self.realpPoints addObject:value];
        }
    }
    
    [self drawPolygonWithPoints:self.realpPoints];
    
    return self;
}

- (void)drawPolygonWithPoints:(NSMutableArray *)array {
    NSValue *originValue = array[0];
    [self.path moveToPoint:originValue.CGPointValue];
    [self.realpPoints removeObjectAtIndex:0];
    
    for (NSValue *value in self.realpPoints) {
        [self.path addLineToPoint:value.CGPointValue];
    }
    [self.path closePath];
}

@end
