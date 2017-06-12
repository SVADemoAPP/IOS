//
//  SVAPOIViewModel.h
//  SVA
//
//  Created by Zeacone on 15/12/23.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVAPOIModel.h"
@class SVAPOI;

@protocol SVAPOIDelegate <NSObject>

- (void)getShopModels:(NSArray<SVAPOIModel *> *)shopModels;

@end

@interface SVAPOIViewModel : NSObject

@property (nonatomic, assign) id<SVAPOIDelegate> delegate;

@property (nonatomic, strong) NSArray *POIModels;
@property (nonatomic, strong) NSMutableArray *POIPoints;
@property (nonatomic, strong) SVAMapDataModel *mapModel;

+ (instancetype)sharedPOIViewModel;
- (void)getPOIsWithMapDataModel:(SVAMapDataModel *)model;

@end
