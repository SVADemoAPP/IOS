//
//  FSSVGUtils.h
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 24/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FXSVGUtils : NSObject

+ (NSArray *)parsePoints:(const char *)str;
+ (CGAffineTransform)parseTransform:(NSString*)str;

@end
