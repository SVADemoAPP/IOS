//
//  IndoorMapViewNew.h
//  WisdomMallAPP
//
//  Created by apple on 14-1-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AStar.h"
#import "AStarItem.h"
#import "ItemRelation.h"
#import "NSFileHandle+readLine.h"

@interface FindPath : NSObject
{
    NSMutableArray *facilitiesArray;
    
    
    //animation
    UIImageView *_personImageView;
    
    BOOL _isShowing;
    
    //ios7
    CGFloat _offset_y;
}

@property (strong, nonatomic) NSMutableArray *pathArray;
@property (strong, nonatomic) NSMutableArray *pointsArray;

//路径搜索
@property (strong, nonatomic) AStar *astar;
//画路径
@property (strong, nonatomic) NSMutableArray *finalPath;

@property (assign, nonatomic) int facilityType;

/**
 *  画商场地图路径
 */
- (NSMutableArray *)findPathStartX:(CGFloat)startX
                             statY:(CGFloat)startY
                              endX:(CGFloat)endX
                              endY:(CGFloat)endY
                          filePath:(NSString *)filePath;

@end
