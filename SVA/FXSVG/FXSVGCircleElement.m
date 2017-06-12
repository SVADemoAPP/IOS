//
//  FXSVGCircleElement.m
//  FSInteractiveMap
//
//  Created by Zeacone on 16/1/7.
//  Copyright © 2016年 Arthur GUIBERT. All rights reserved.
//

#import "FXSVGCircleElement.h"

@implementation FXSVGCircleElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
//    self.fillColor = [UIColor purpleColor];
    
    CGFloat cx = ((NSString *)[attributes objectForKey:@"cx"]).doubleValue;
    CGFloat cy = ((NSString *)[attributes objectForKey:@"cy"]).doubleValue;
    CGPoint center = CGPointMake(cx, cy);
    CGFloat radius = ((NSString *)[attributes objectForKey:@"r"]).doubleValue;
    [self drawCircleWithCenter:center radius:radius];
    
    return self;
}

- (void)drawCircleWithCenter:(CGPoint)center radius:(CGFloat)radius {
    [self.path addArcWithCenter:center radius:radius startAngle:.0 endAngle:(2 * M_PI) clockwise:YES];
}

@end
