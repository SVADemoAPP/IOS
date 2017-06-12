//
//  SVAMap.h
//  SVA
//
//  Created by Zeacone on 16/1/14.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVAImageMapView.h"
#import "SVASVGMapView.h"
#import "SVAMapDataModel.h"

@protocol SVAMapDownloadDelegate <NSObject>

- (void)mapHasDownloaded:(SVAMapDataModel *)mapDataModel;

@end

@interface SVAMap : UIView

@property (nonatomic, assign) id<SVAMapDownloadDelegate> delegate;

@property (nonatomic, strong) SVAImageMapView *imageMap;
@property (nonatomic, strong) SVASVGMapView *svgMap;
// Map related
@property (nonatomic, strong) CAShapeLayer *oldClickedlayer;
@property (nonatomic, strong) SVAMapDataModel *mapModel;
@property (nonatomic, strong) NSMutableArray<NSValue *> *points;

- (void)loadMapWithMapModel:(SVAMapDataModel *)mapModel;

@end
