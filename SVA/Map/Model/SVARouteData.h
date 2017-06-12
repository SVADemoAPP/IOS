//
//  SVARouteData.h
//  SVA
//
//  Created by 黄芹 on 1/28/16.
//  Copyright © 2016 huawei. All rights reserved.
//

#import "SMActivityBaseModel.h"

@interface SVARouteData : SMActivityBaseModel

@property (nonatomic, copy) NSString *floor;
@property (nonatomic, copy) NSString *route;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, assign) long updateTime;

@end
