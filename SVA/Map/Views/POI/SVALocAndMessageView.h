//
//  SVALocAndMessageView.h
//  SVA
//
//  Created by Zeacone on 16/3/8.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SVALocationViewModel.h"
#import "SVAInheritViewModel.h"
#import <INS/INS.h>
#import <PathFilter/PathFilter.h>

@interface SVALocAndMessageView : UIView <SVALocationDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager    *locationManager;
@property (nonatomic, strong) SVALocationViewModel *locationViewModel;
@property (nonatomic, strong) SVAMapDataModel      *mapModel;
@property (nonatomic, strong) SVALocationDataModel *locationData;
@property (nonatomic, strong) SVAPushView          *pushview;

@property (nonatomic, strong) NSArray<SVALocationMessageModel *> *messageModels;
@property (nonatomic, strong) NSMutableArray<NSValue *> *historyLocation;
@property (nonatomic, strong) NSMutableArray<CALayer *> *historyLayer;

- (void)getLocation;

- (void)pauseLocation;

- (void)resumeLocation;

- (void)stopLocation;

- (void)removePushLayer;

- (void)changeScale:(CGFloat)scale Rotation:(CGFloat)rotation;

- (void)addLocation;

- (void)operateLocation;

- (void)changeTransform:(CGFloat)scale rotation:(CGFloat)rotation translate:(CGFloat)translate;

- (void)resetAll;
- (void)removeLocationPoint;
- (void)removePoint;

@end
