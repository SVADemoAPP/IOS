//
//  SVALocate.h
//  SVA
//
//  Created by Zeacone on 15/12/21.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVALocationModel.h"
#import "SVALocAndMessageView.h"

@protocol SVALocationDelegate <NSObject>

- (void)getLocationModel:(SVALocationDataModel *)locationModel MessageModels:(NSArray<SVALocationMessageModel *> *)messageModels onMapModel:(SVAMapDataModel *)mapModel;

@end

@interface SVALocationViewModel : SMActivityBaseModel <SVAMapDownloadDelegate>

@property (nonatomic, assign) id<SVALocationDelegate> delegate;
@property (nonatomic, strong) NSTimer                 *timer;

/**
 *  Create locating singleton.
 *
 *  @return A singleton of current class.
 */
+ (instancetype)sharedLocateViewModel;

/**
 *  Start locating every 2 seconds on a runloop.
 */
- (void)startLocating;

/**
 *  Invalid source timer to stop locate operation.
 */
- (void)stopLocating;

- (void)startRunloop;

- (void)startTimer;

@end
