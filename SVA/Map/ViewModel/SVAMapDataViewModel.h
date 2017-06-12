//
//  MapViewModels.h
//  SVA
//
//  Created by Zeacone on 15/12/21.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVAMapDataModel.h"

@interface SVAMapDataViewModel : NSObject

// 存储返回的所有地图相关数据，需要对地图数据进行整理
@property (nonatomic, strong) NSArray        *models;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSMutableArray *placeIDs;
@property (nonatomic, strong) NSMutableArray *floors;

@property (nonatomic, copy) void (^completeHandler)();

+ (instancetype)sharedMapViewModel;
- (void)getMapInfo;
- (void)startSubscriptionWith:(NSUInteger)placeid;
- (NSMutableArray *)getFloorsByPlace:(NSString *)place;
- (SVAMapDataModel *)getMapDataByFloorNo:(NSUInteger)floorNo;

@end
