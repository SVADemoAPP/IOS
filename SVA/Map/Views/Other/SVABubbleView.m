//
//  SVABubbleView.m
//  SVA
//
//  Created by Zeacone on 15/12/24.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVABubbleView.h"

@implementation SVABubbleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor (context, 0.0, 0.0, 0.0, 0.0);
    CGContextSetLineWidth(context, 3.0);
    CGFloat cornerRadius = 5.0;
    CGFloat pointerSize = 10.0;
    UIColor *borderColor = [UIColor redColor];
    
    CGPoint origin = self.frame.origin;
    CGSize size = self.frame.size;
    
    //确定画线的宽度，对象组合，颜色
    CGMutablePathRef bubblePath = CGPathCreateMutable();
    //绘制起点－箭头右边－气泡右上顶点－右下顶点－左下顶点－左上顶点－箭头左边－起点闭合
    CGPathMoveToPoint(bubblePath, NULL, origin.x, origin.y);
    
    CGPathAddLineToPoint(bubblePath, NULL, origin.x+pointerSize-1, origin.y-2);
    
    CGPathAddArcToPoint(bubblePath, NULL, origin.x, origin.y, origin.x + size.width, origin.y, cornerRadius);
    
    CGPathAddArcToPoint(bubblePath, NULL, origin.x + size.width, origin.y,origin.x+size.width, origin.y+size.height, cornerRadius);
    
    CGPathAddArcToPoint(bubblePath, NULL, origin.x + size.width, origin.y+size.height, origin.x, origin.y+size.height, cornerRadius);
    
    CGPathAddArcToPoint(bubblePath, NULL, origin.x, origin.y+size.height, origin.x, origin.y+pointerSize , cornerRadius);
    
    CGPathAddLineToPoint(bubblePath, NULL, origin.x + pointerSize, origin.y+pointerSize);
    
    CGPathCloseSubpath(bubblePath);
    
    //绘制阴影
    CGContextAddPath(context, bubblePath);
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0, 3), 5);
    CGContextSetRGBFillColor(context, 255.0, 255.0, 255.0, 0.0);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    //设置边线颜色
    CGContextAddPath(context, bubblePath);
    CGContextClip(context);
    
    size_t numberBorderComponents = CGColorGetNumberOfComponents([borderColor CGColor]);
    const CGFloat *borderComponents = CGColorGetComponents(borderColor.CGColor);
    CGFloat r,g,b,a;
    if (numberBorderComponents == 2) {
        r = borderComponents[0];
        g = borderComponents[0];
        b = borderComponents[0];
        a = borderComponents[1];
    }else {
        r = borderComponents[0];
        g = borderComponents[1];
        b = borderComponents[2];
        a = borderComponents[3];
    }
    CGContextSetRGBStrokeColor(context, r, g, b, a);
    CGContextAddPath(context, bubblePath);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(bubblePath);
}

@end
