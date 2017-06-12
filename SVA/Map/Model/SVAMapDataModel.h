//
//  MapModels.h
//  SVA
//
//  Created by Zeacone on 15/12/15.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAMapDataModel : SMActivityBaseModel

@property (nonatomic, copy  ) NSString   *angle;
@property (nonatomic, copy  ) NSString   *coordinate;
@property (nonatomic, copy  ) NSString   *floor;
@property (nonatomic, assign) NSUInteger floorNo;
@property (nonatomic, assign) NSUInteger floorid;
@property (nonatomic, assign) NSUInteger imgHeight;
@property (nonatomic, assign) NSUInteger imgWidth;
@property (nonatomic, copy  ) NSString   *path;
@property (nonatomic, copy  ) NSString   *svg;
@property (nonatomic, copy  ) NSString   *place;
@property (nonatomic, assign) NSUInteger placeId;
@property (nonatomic, copy  ) NSString   *scale;
@property (nonatomic, copy  ) NSString   *route;
@property (nonatomic, copy  ) NSString   *pathFile;
@property (nonatomic, copy  ) NSString   *updateTime;
@property (nonatomic, copy  ) NSString   *xo;
@property (nonatomic, copy  ) NSString   *yo;
@property (nonatomic, copy, ) NSString   *id;

@end
