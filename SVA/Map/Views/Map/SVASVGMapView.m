//
//  SVASVGMapView.m
//  SVA
//
//  Created by Zeacone on 16/3/7.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVASVGMapView.h"

@implementation SVASVGMapView

- (void)loadSVGMapWithName:(NSString *)svgName handler:(void (^)())handler {
    @weakify(self);
    [[SVANetworkResource sharedResource] downloadSVGFileWithFilename:svgName completionHandler:^(NSURL *filepath) {
        @strongify(self);
        handler();
        [self loadSVGMapWithPath:filepath.path];
    }];
}

- (void)loadSVGMapWithPath:(NSString *)svgPath {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:svgPath];
    SVGKImage *svgImage = [SVGKImage imageWithContentsOfURL:url];
    
    if (svgImage.hasSize) {
        svgImage.size = CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.width * (svgImage.size.height / svgImage.size.width));
    }
    
    SVGKLayeredImageView *svgImageView = ({
        SVGKLayeredImageView *imageview = [[SVGKLayeredImageView alloc] initWithSVGKImage:svgImage];
        imageview.frame = CGRectMake(0, (SCREEN_SIZE.height - 64 - svgImage.size.height) / 2 , svgImage.size.width, svgImage.size.height);
        imageview;
    });
    [self addSubview:svgImageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (CALayer *sublayer in self.layer.sublayers) {
        
        for (CALayer *secondSublayer in sublayer.sublayers) {
            
            for (CALayer *thirdSublayer in secondSublayer.sublayers) {
                
                if (![thirdSublayer isKindOfClass:[CAShapeLayer class]]) continue;
                CAShapeLayer *shapeLayer = (CAShapeLayer *)thirdSublayer;
                if (![shapeLayer containsPoint:touchPoint] || !self.clickHandler) continue;
                self.clickHandler(@"something", shapeLayer, touchPoint);
                
                for (CALayer *fourthSublayer in thirdSublayer.sublayers) {
                    if (![fourthSublayer isKindOfClass:[CAShapeLayer class]]) continue;
                    CAShapeLayer *shapeLayer = (CAShapeLayer *)fourthSublayer;
                    if (![shapeLayer containsPoint:touchPoint] || !self.clickHandler) continue;
                    self.clickHandler(@"something", shapeLayer, touchPoint);
                }
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
