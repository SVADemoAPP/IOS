//
//  SVAShopView.h
//  SVA
//
//  Created by 君若见故 on 16/2/24.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ALMoviePlayerController/ALMoviePlayerController.h>
#import "SVAPOIViewModel.h"
#import "SVAFindPath.h"
#import "SVAPushView.h"
#import "SJAvatarBrowser.h"

@interface SVAShopView : UIView <SVAPOIDelegate, SVAPushViewDelegate, ALMoviePlayerControllerDelegate>

@property (nonatomic, strong) SVAMapDataModel *mapModel;
@property (nonatomic, strong) SVAPOIViewModel *shopViewModel;
@property (nonatomic, strong) NSArray<SVAPOIModel *> *poiModels;
@property (nonatomic, strong) SVAPushView *pushview;

@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;

- (void)getShopsWithMapModel:(SVAMapDataModel *)mapModel;

- (void)removeShopLayer;

- (void)addStartLayer:(CGPoint)point;

- (void)addEndLayer:(CGPoint)point;

- (void)changeScale:(CGFloat)scale Rotation:(CGFloat)rotation;

- (void)resetAll;

@end
