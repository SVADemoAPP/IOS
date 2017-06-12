//
//  FSSVG.m
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 22/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "SVASVG.h"
#import "FXSVG.h"

@interface SVASVG()
@property (nonatomic, strong) NSMutableArray* transforms;
@property (nonatomic) CGAffineTransform currentTransform;
@end

@implementation SVASVG

+ (instancetype)svgWithFile:(NSString*)filePath {
    return [[SVASVG alloc] initWithFile:filePath];
}

- (id)initWithFile:(NSString*)filename {
    self = [super init];
    
    if(self) {
        _paths = [NSMutableArray array];
        _transforms = [NSMutableArray array];
        _currentTransform = CGAffineTransformIdentity;
        
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"svg"]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        [parser parse];
    }
    
    return self;
}

#pragma mark - Xml Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"g"]) {
        // Push
        CGAffineTransform t = CGAffineTransformIdentity;
        
        if([attributeDict objectForKey:@"transform"]) {
            t = [FXSVGUtils parseTransform:[attributeDict objectForKey:@"transform"]];
        }
        
        _currentTransform = CGAffineTransformConcat(t, _currentTransform);
        [_transforms addObject:NSStringFromCGAffineTransform(_currentTransform)];
    } else if ([elementName isEqualToString:@"svg"]) {
        NSLog(@"123");
    } else {
        
        // Get transform property
        CGAffineTransform t = _currentTransform;
        
        if([attributeDict objectForKey:@"transform"]) {
            CGAffineTransform pathTransform = [FXSVGUtils parseTransform:[attributeDict objectForKey:@"transform"]];
            t = CGAffineTransformConcat(pathTransform, _currentTransform);
        }
        
        /**
         *  This is for seven svg elements, like Path, Line, Rect, Circle, Ellipse, Polyline and Polygon.
         */
        if([elementName isEqualToString:@"path"]) {
            FXSVGPathElement *element = [[FXSVGPathElement alloc] initWithAttributes:attributeDict];
            if(element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if ([elementName isEqualToString:@"rect"]) {
            FXSVGRectElement *element = [[FXSVGRectElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
            
        } else if([elementName isEqualToString:@"polygon"]) {
            FXSVGPolygonElement *element = [[FXSVGPolygonElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"polyline"]) {
            FXSVGPolylineElement *element = [[FXSVGPolylineElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"line"]) {
            FXSVGLineElement *element = [[FXSVGLineElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"circle"]) {
            FXSVGCircleElement *element = [[FXSVGCircleElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"ellipse"]) {
            FXSVGEllipseElement *element = [[FXSVGEllipseElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"g"])
    {
        // Pop
        [_transforms removeLastObject];
        
        if([_transforms count] > 0 ) {
            _currentTransform = CGAffineTransformFromString([_transforms lastObject]);
        } else {
            _currentTransform = CGAffineTransformIdentity;
        }
    }
}

@end
