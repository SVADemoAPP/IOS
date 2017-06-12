//
//  FSSVGRectElement.m
//  FSInteractiveMap
//
//  Created by Zeacone on 16/1/6.
//  Copyright © 2016年 Arthur GUIBERT. All rights reserved.
//

#import "FXSVGRectElement.h"

@implementation FXSVGRectElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super initWithAttributes:attributes];
    if (!self)
    {
        return nil;
    }
    
//    self.fillColor = [UIColor blueColor];
    
    NSString *x = [attributes objectForKey:@"x"];
    NSString *y = [attributes objectForKey:@"y"];
    NSString *width = [attributes objectForKey:@"width"];
    NSString *height = [attributes objectForKey:@"height"];
    [self drawRectWithX:x Y:y Width:width Height:height];
    [FXSVGUtils parseTransform:self.tranform];
    
    // Check the fill attribute
    if([attributes objectForKey:@"fill"] && ![[attributes objectForKey:@"fill"] isEqualToString:@"none"]) {
        self.fill = YES;
    }
    
    return self;
}

- (void)drawRectWithX:(NSString *)x Y:(NSString *)y Width:(NSString *)width Height:(NSString *)height {
    CGRect rect = CGRectMake(x.floatValue, y.floatValue, width.floatValue, height.floatValue);
    self.path = [UIBezierPath bezierPathWithRect:rect];
}

@end
