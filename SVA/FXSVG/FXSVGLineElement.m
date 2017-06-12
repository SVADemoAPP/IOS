//
//  FXSVGLineElement.m
//  FSInteractiveMap
//
//  Created by Zeacone on 16/1/7.
//  Copyright © 2016年 Arthur GUIBERT. All rights reserved.
//

#import "FXSVGLineElement.h"

@implementation FXSVGLineElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
//    self.fillColor = [UIColor redColor];
    
    NSString *x1 = [attributes objectForKey:@"x1"];
    NSString *y1 = [attributes objectForKey:@"y1"];
    NSString *x2 = [attributes objectForKey:@"x2"];
    NSString *y2 = [attributes objectForKey:@"y2"];
    
    CGPoint startPoint = CGPointMake(x1.doubleValue, y1.doubleValue);
    CGPoint endPoint = CGPointMake(x2.doubleValue, y2.doubleValue);
    [self drawLineWithStartPoint:startPoint endPoint:endPoint];
    
    return self;
}

- (void)drawLineWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    [self.path moveToPoint:start];
    [self.path addLineToPoint:end];
}

@end
