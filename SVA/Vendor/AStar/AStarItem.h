//
//  AStarItem.h
//  TagImageView
//
//  Created by apple on 13-10-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AStarItem : NSObject

@property (nonatomic, assign) NSInteger id_col;
@property (nonatomic, assign) NSInteger id_row;
@property (nonatomic, assign) NSInteger id_g;
@property (nonatomic, assign) NSInteger id_h;
@property (nonatomic, assign) NSInteger id_fid;
@property (nonatomic, assign) NSInteger id_f;

@property (nonatomic, assign) CGFloat distanceOfItem;

@property (nonatomic, assign) CGPoint point1;
@property (nonatomic, assign) CGPoint point2;

- (void)setPos:(NSInteger)col row:(NSInteger)row;

@end
