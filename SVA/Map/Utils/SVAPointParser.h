//
//  SVAPointParser.h
//  SVA
//
//  Created by Zeacone on 16/1/27.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAPointParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, copy) void(^parserCompletionHandler)(NSMutableArray<NSValue *> *pointsArray);

- (NSMutableArray<NSValue *> *)getPointsFromXML:(NSURL *)xmlPath
                                      withScale:(CGFloat)scale
                                       mapWidth:(NSInteger)width
                                      mapHeight:(NSInteger)height;

@end
