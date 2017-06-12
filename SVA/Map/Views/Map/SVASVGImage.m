//
//  SVASVGImage.m
//  SVA
//
//  Created by Zeacone on 16/1/26.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVASVGImage.h"

@implementation SVASVGImage

- (instancetype)initWithSVG:(NSString *)svg {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.svgImage = [[SVGKLayeredImageView alloc] initWithSVGKImage:nil];
    [self addSubview:self.svgImage];
    return self;
}

- (void)loadSVGMap:(NSString *)svg handler:(void (^)())handler {
    if (!svg) {
        self.image = nil;
        return;
    }
    self.svgImage.image = nil;
//    if ([svg isEqualToString:@"huawei"] || [svg isEqualToString:@"vdf"])
//    {
//        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:svg withExtension:@"svg"];
//        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//        NSString *finalPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.svg", svg]];
//        NSURL *finalURL = [NSURL URLWithString:finalPath];
//        NSError *error = nil;
//        [[NSFileManager defaultManager] copyItemAtURL:bundleURL toURL:finalURL error:&error];
////        self.image = [SVGKImage imageWithContentsOfURL:finalURL];
//        self.image = [SVGKImage imageNamed:svg inBundle:[NSBundle mainBundle]];
//    } else
//    {
        self.image = [SVGKImage imageWithContentsOfURL:[NSURL URLWithString:svg]];
//    }
    
    //[SVGKImage imageNamed:svg];
    if (self.image.hasSize)
    {
        self.image.size = CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.width*(self.image.size.height/self.image.size.width));
    }
    self.svgImage.image = self.image;
    self.svgImage.backgroundColor = [UIColor clearColor];
    self.svgImage.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
//    if ([svg isEqualToString:@"huawei"]) {
        self.svgImage.center = CGPointMake(SCREEN_SIZE.width/2, (SCREEN_SIZE.height - 64)/2);
    
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    self.svgImage.frame = CGRectMake(0, 0, size.width, self.image.size.height);
    
//    }
//    if ([svg isEqualToString:@"vdf"]) {
//        self.svgImage.center = CGPointMake(SCREEN_SIZE.width / 2 +160, (SCREEN_SIZE.height - 64) / 2+40);
//
//    }
    
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (CALayer *sublayer in self.layer.sublayers) {
        for (CALayer *secondSublayer in sublayer.sublayers) {
            for (CALayer *thirdSublayer in secondSublayer.sublayers) {
                if( [thirdSublayer isKindOfClass:[CAShapeLayer class]]) {
                    CAShapeLayer* shapeLayer = (CAShapeLayer*)thirdSublayer;
                    if ([shapeLayer containsPoint:touchPoint] && _clickHandler) {
                        _clickHandler(@"something", shapeLayer, touchPoint);
                    }
                }
                for (CALayer *fourthSublayer in thirdSublayer.sublayers) {
                    if( [fourthSublayer isKindOfClass:[CAShapeLayer class]]) {
                        CAShapeLayer* shapeLayer = (CAShapeLayer*)fourthSublayer;
                        if ([shapeLayer containsPoint:touchPoint] && _clickHandler) {
                            _clickHandler(@"something", shapeLayer, touchPoint);
                        }
                    }
                }
            }
        }
    }
}


@end
