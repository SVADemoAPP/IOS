//
//  SVASVGImage.h
//  SVA
//
//  Created by Zeacone on 16/1/26.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVASVGImage : UIView

// Click handler
@property (nonatomic, copy) void (^clickHandler)(NSString *identifier, CAShapeLayer *layer, CGPoint touchPoint);

@property (nonatomic, strong) SVGKImageView *svgImage;
@property (nonatomic, strong) SVGKImage *image;

- (instancetype)initWithSVG:(NSString *)svg;
- (void)loadSVGMap:(NSString *)svg handler:(void(^)())handler;
//- (void)loadSVGMapWithPath:(NSString *)svgPath;

@end
