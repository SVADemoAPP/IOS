//
//  LocateModel.h
//  SVA
//
//  Created by Zeacone on 15/12/21.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVALocationDataModel : SMActivityBaseModel <NSCoding>

@property (nonatomic, copy  ) NSString *idType;
@property (nonatomic, copy  ) NSString *timestamp;
@property (nonatomic, copy  ) NSString *dataType;
@property (nonatomic, assign) CGFloat  x;
@property (nonatomic, assign) CGFloat  y;
@property (nonatomic, assign) CGFloat  z;
@property (nonatomic, copy  ) NSString *userID;
@property (nonatomic, copy  ) NSString *path;
@property (nonatomic, copy  ) NSString *xo;
@property (nonatomic, copy  ) NSString *yo;
@property (nonatomic, copy  ) NSString *scale;

@end

@interface SVALocationMessageModel : SMActivityBaseModel <NSCoding>

@property (nonatomic, copy  ) NSString *place;
@property (nonatomic, copy  ) NSString *placeId;
@property (nonatomic, copy  ) NSString *shopName;
@property (nonatomic, assign) NSString *timeInterval;
@property (nonatomic, assign) CGFloat  xSpot;
@property (nonatomic, assign) CGFloat  ySpot;
@property (nonatomic, copy  ) NSString *floor;
@property (nonatomic, assign) CGFloat  rangeSpot;
@property (nonatomic, copy  ) NSString *pictruePath;
@property (nonatomic, copy  ) NSString *moviePath;
@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, copy  ) NSString *floorNo;
@property (nonatomic, copy  ) NSString *message;
@property (nonatomic, copy  ) NSString *isEnable;

@end

@interface SVALocationModel : SMActivityBaseModel <NSCoding>

@property (nonatomic, copy  ) NSArray *message;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy  ) NSString     *error;

@end