//
//  FSSVG.h
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 22/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FXSVGUtils.h"
#import "FXSVGPathElement.h"
#import "FXSVGRectElement.h"

@interface FXSVGParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray* paths;
@property (nonatomic) CGRect bounds;

+ (instancetype)svgWithFile:(NSString*)filePath;

@end
