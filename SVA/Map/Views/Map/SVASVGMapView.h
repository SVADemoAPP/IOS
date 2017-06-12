//
//  SVASVGMapView.h
//  SVA
//
//  Created by Zeacone on 16/3/7.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVASVGMapView : UIView

// Click handler
@property (nonatomic, copy) void (^clickHandler)(NSString *identifier, CAShapeLayer *layer, CGPoint touchPoint);

- (void)loadSVGMapWithName:(NSString *)svgName handler:(void(^)())handler;

@end
