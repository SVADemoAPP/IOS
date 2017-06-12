//
//  MyLocator.h
//  svaDemo
//
//  Created by XuZongCheng on 16/1/12.
//  Copyright © 2016年 XuZongCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface INSLocator :NSObject

+ (CGPoint)newLocationWithX:(CGFloat)x Y:(CGFloat)y headingAngle:(double)heading Velocity:(double)velocity;

@end
