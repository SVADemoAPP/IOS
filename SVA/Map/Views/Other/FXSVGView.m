//
//  FSInteractiveMapView.m
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 23/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "FXSVGView.h"
#import "FXSVGParser.h"

@interface FXSVGView ()

@property (nonatomic, strong) FXSVGParser *svg;
@property (nonatomic, strong) NSMutableArray* scaledPaths;

@end

@implementation FXSVGView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        _scaledPaths = [NSMutableArray array];
        [self setDefaultParameters];
    }
    
    return self;
}

- (void)setDefaultParameters
{
    self.fillColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.strokeColor = [UIColor colorWithWhite:0.6 alpha:1];
}

#pragma mark - SVG map loading

- (CGRect)loadMap:(NSString*)mapName withColors:(NSDictionary*)colorsDict
{
    _svg = [FXSVGParser svgWithFile:mapName];
    
    // Clear all data to forbid duplicate adding.
    [self.scaledPaths removeAllObjects];
    
    for (FXSVGElement *element in _svg.paths) {
        // Make the map fits inside the frame
        float scaleHorizontal = self.frame.size.width / _svg.bounds.size.width;
        float scaleVertical = self.frame.size.height / _svg.bounds.size.height;
        float scale = MIN(scaleHorizontal, scaleVertical);
        
        CGAffineTransform scaleTransform = CGAffineTransformIdentity;
        scaleTransform = CGAffineTransformMakeScale(scale, scale);
        scaleTransform = CGAffineTransformTranslate(scaleTransform,-_svg.bounds.origin.x, -_svg.bounds.origin.y);
        
        UIBezierPath* svgRect = [element.path copy];
        [svgRect applyTransform:scaleTransform];
        
        CAShapeLayer  *shapeLayer = [CAShapeLayer  layer];
        // Setting CAShapeLayer properties
        shapeLayer.strokeColor = element.strokeColor.CGColor;
        shapeLayer.fillColor = element.fillColor.CGColor;
        shapeLayer.lineWidth = 0.5;
        
        shapeLayer.path = svgRect.CGPath;
        
        [self.layer addSublayer:shapeLayer];
        
        [_scaledPaths addObject:svgRect];
    }
    return _svg.bounds;
}

- (void)loadMap:(NSString*)mapName withData:(NSDictionary*)data colorAxis:(NSArray*)colors
{
    [self loadMap:mapName withColors:[self getColorsForData:data colorAxis:colors]];
}

- (NSDictionary*)getColorsForData:(NSDictionary*)data colorAxis:(NSArray*)colors
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[data count]];
    
    float min = MAXFLOAT;
    float max = -MAXFLOAT;
    
    for (id key in data) {
        NSNumber* value = [data objectForKey:key];
        
        if([value floatValue] > max)
            max = [value floatValue];
        
        if([value floatValue] < min)
            min = [value floatValue];
    }
    
    for (id key in data) {
        NSNumber* value = [data objectForKey:key];
        float s = ([value floatValue] - min) / (max - min);
        float segmentLength = 1.0 / ([colors count] - 1);
        int minColorIndex = MAX(floorf(s / segmentLength),0);
        int maxColorIndex = MIN(ceilf(s / segmentLength), [colors count] - 1);
        
        UIColor* minColor = colors[minColorIndex];
        UIColor* maxColor = colors[maxColorIndex];
        
        s -= segmentLength * minColorIndex;
        
        CGFloat maxColorRed = 0;
        CGFloat maxColorGreen = 0;
        CGFloat maxColorBlue = 0;
        CGFloat minColorRed = 0;
        CGFloat minColorGreen = 0;
        CGFloat minColorBlue = 0;
        
        [maxColor getRed:&maxColorRed green:&maxColorGreen blue:&maxColorBlue alpha:nil];
        [minColor getRed:&minColorRed green:&minColorGreen blue:&minColorBlue alpha:nil];
        
        UIColor* color = [UIColor colorWithRed:minColorRed * (1.0 - s) + maxColorRed * s
                                         green:minColorGreen * (1.0 - s) + maxColorGreen * s
                                          blue:minColorBlue * (1.0 - s) + maxColorBlue * s
                                         alpha:1];
        
        [dict setObject:color forKey:key];
    }
    
    return dict;
}

#pragma mark - Updating the colors and/or the data

- (void)setColors:(NSDictionary*)colorsDict
{
    for(int i=0;i<[_scaledPaths count];i++) {
        FXSVGPathElement* element = _svg.paths[i];
        
        if([self.layer.sublayers[i] isKindOfClass:CAShapeLayer.class] && element.fill) {
            CAShapeLayer * l = (CAShapeLayer  *)self.layer.sublayers[i];
            
            if(element.fill) {
                if(colorsDict && [colorsDict objectForKey:element.identifier]) {
                    UIColor* color = [colorsDict objectForKey:element.identifier];
                    l.fillColor = color.CGColor;
                } else {
                    l.fillColor = self.fillColor.CGColor;
                }
            } else {
//                l.fillColor = [[UIColor clearColor] CGColor];
            }
        }
    }
}

- (void)setData:(NSDictionary*)data colorAxis:(NSArray*)colors
{
    [self setColors:[self getColorsForData:data colorAxis:colors]];
}

#pragma mark - Layers enumeration

- (void)enumerateLayersUsingBlock:(void (^)(NSString *, CAShapeLayer  *))block
{
    for(int i=0;i<[_scaledPaths count];i++) {
        FXSVGElement* element = _svg.paths[i];
        
        if([self.layer.sublayers[i] isKindOfClass:CAShapeLayer.class] && element.fill) {
            CAShapeLayer * l = (CAShapeLayer  *)self.layer.sublayers[i];
            block(element.identifier, l);
        }
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for(NSInteger i = 0; i < self.scaledPaths.count; i++) {
        UIBezierPath *path = self.scaledPaths[i];
        if ([path containsPoint:touchPoint]) {
            FXSVGElement *element = self.svg.paths[i];
            
            if([self.layer.sublayers[i] isKindOfClass:CAShapeLayer.class] && element.fillColor) {
                CAShapeLayer *layer = (CAShapeLayer *)self.layer.sublayers[i];
                
                if(_clickHandler) {
                    _clickHandler(element.identifier, layer, touchPoint);
//                    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_zj_center"]];
//                    imageview.frame = CGRectMake(touchPoint.x, touchPoint.y, 2, 2);
//                    [self addSubview:imageview];
                }
            }
        }
    }
}

@end
