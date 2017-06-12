//
//  SVAMapView.h
//  SVA
//
//  Created by Zeacone on 15/12/10.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVAFloorTableViewCell.h"
#import "SVAMap.h"
#import "ScaleStore.h"
#import "SVAShopView.h"
#import "SVALocAndMessageView.h"

@interface SVAMapView : UIView <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, copy) void (^getMarketTitleHandler)(NSString *place);

@property (nonatomic, strong) UIScrollView   *contentScrollView;
@property (nonatomic, strong) UIImageView    *backgroudView;
@property (nonatomic, strong) SVAMap         *mapView;
@property (nonatomic, strong) SVAShopView    *shopView;
@property (nonatomic, strong) SVALocAndMessageView *locView;

@property (nonatomic, strong) SVAMapDataModel *mapModel;

@property (nonatomic, strong) UIButton       *locate;

@property (nonatomic, strong) UIButton       *enlarge;
@property (nonatomic, strong) UIButton       *narrow;
@property (nonatomic, strong) UIView         *scaleView;
@property (nonatomic, strong) UITableView    *floorSelection;
@property (nonatomic, strong) UIImageView    *floorView;
@property (nonatomic, strong) UILabel        *scale;
@property (nonatomic, strong) UIImageView    *scaleImage;

@property (nonatomic, assign) CGFloat        offsetY;
@property (nonatomic, assign) NSInteger      currentRow;

@property (nonatomic, assign) CGFloat        lastRotation;

// 楼层信息
@property (nonatomic, strong) NSMutableArray *floors;

@property (nonatomic,strong) UIButton *locationBtn;
@property (nonatomic,assign) CGPoint oldCenter;
@property (nonatomic,assign) CGFloat lastScale;
@property (nonatomic,strong) ScaleStore *scaleStore;

+ (instancetype)sharedMap;
- (void)addShopView;
- (void)loadAllNeed;
- (void)backToNormal:(UIButton *)reset;

@end
