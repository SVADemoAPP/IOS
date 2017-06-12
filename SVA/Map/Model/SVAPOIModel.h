//
//  SVAPOIModel.h
//  SVA
//
//  Created by Zeacone on 15/12/23.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAPOIModel : SMActivityBaseModel <NSCoding>

@property (nonatomic, copy  ) NSString   *place;
@property (nonatomic, assign) NSUInteger placeId;
@property (nonatomic, copy  ) NSString   *floor;
@property (nonatomic, assign) CGFloat    xSpot;
@property (nonatomic, assign) CGFloat    ySpot;
@property (nonatomic, copy  ) NSString   *info;
@property (nonatomic, copy  ) NSString   *isEnable;
@property (nonatomic, copy  ) NSString   *pictruePath;
@property (nonatomic, copy  ) NSString   *moviePath;
@property (nonatomic, copy  ) NSString   *isVip;
@property (nonatomic, copy  ) NSString   *id;
@property (nonatomic, copy  ) NSString   *floorNo;

@end
