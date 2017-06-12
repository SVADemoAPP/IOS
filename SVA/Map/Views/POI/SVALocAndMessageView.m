//
//  SVALocAndMessageView.m
//  SVA
//
//  Created by Zeacone on 16/3/8.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVALocAndMessageView.h"

#define location_timestamp_key @"localTmeStamp"
#define param_timestamp_key @"paramUpdateTime"

@interface SVALocAndMessageView ()

@property (nonatomic, strong) NSMutableArray<CALayer *> *messageLayers;
@property (nonatomic, strong) NSMutableArray<CALayer *> *textLayers;
@property (nonatomic, strong) NSMutableArray<NSValue *> *pushPoints;
@property (nonatomic, strong) CALayer *locationLayer;
@property (nonatomic, strong) CALayer *haloLayer;
@property (nonatomic, assign) CLLocationDirection currentHeading;
@property (nonatomic, assign) CGPoint locationPoint;
@property (nonatomic, assign) CGFloat currentRotation;

@end

@implementation SVALocAndMessageView

- (void)getLocationModel:(SVALocationDataModel *)locationModel MessageModels:(NSArray<SVALocationMessageModel *> *)messageModels onMapModel:(SVAMapDataModel *)mapModel {
    self.locationData = locationModel;
    self.messageModels = messageModels;
    self.mapModel = mapModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addLocation];
        [self locationPointKVO];
    });
    
    [self addPushLayer];
    
    // 根据时间戳的变化判断是否应该重新下载惯导参数
    id paramTimestamp = [[NSUserDefaults standardUserDefaults] objectForKey:param_timestamp_key];
    id localParamTimestamp = [[NSUserDefaults standardUserDefaults] objectForKey:location_timestamp_key];
    if (!localParamTimestamp || ![localParamTimestamp isEqual:paramTimestamp]) {
        [[NSUserDefaults standardUserDefaults] setObject:paramTimestamp forKey:location_timestamp_key];
#warning 取消后台下载惯导参数，使用本地数据
        
//        [self getNewInheritialParameter];
    }
    [self operateLocation];
}

#pragma mark - 从 web 端获取惯导参数
- (void)getNewInheritialParameter {
    
    [SVAInheritViewModel getInhertialData:^(SVAInheritialModel *inheritialModel) {
        NSArray *inheritialParameters = @[@(inheritialModel.correctMapDirection),
                                          inheritialModel.filterPeakError ? inheritialModel.filterPeakError : @"0.1",
                                          inheritialModel.step ? inheritialModel.step : @"0.6",
                                          @(inheritialModel.peakWidth),
                                          inheritialModel.horizontalWeight ? inheritialModel.horizontalWeight : @"0.04",
                                          inheritialModel.ongitudinalWeight ? inheritialModel.ongitudinalWeight : @"0.02",
                                          inheritialModel.banThreshold ? inheritialModel.banThreshold : @"0.3",
                                          @(inheritialModel.restTimes),
                                          @(inheritialModel.maxDeviation),
                                          @(inheritialModel.exceedMaxDeviation),
                                          @(inheritialModel.filterLength)
                                          ];
        
        [[NSUserDefaults standardUserDefaults] setObject:inheritialParameters forKey:@"inherit"];
    }];
}

#pragma mark -- 定位
- (void)getLocation {
    self.pushview = [SVAPushView new];
    self.messageLayers     = [NSMutableArray array];
    self.textLayers        = [NSMutableArray array];
    self.pushPoints        = [NSMutableArray array];
    self.locationViewModel = [SVALocationViewModel new];
    self.locationViewModel.delegate = self;
    [self removePoint];
    [self.locationViewModel startLocating];
    // isChangeFloor
//    BOOL isChangeFloor = [[NSUserDefaults standardUserDefaults] objectForKey:@"isChangeFloor"];
//    if (isChangeFloor == 1) {
        self.locationLayer.hidden = NO;
        self.haloLayer.hidden = NO;
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeFloor"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    [self startGetHeadingCource];
}

- (void)startGetHeadingCource {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.headingFilter = kCLHeadingFilterNone;
    
    [self.locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    if (self.mapModel) {
        self.locationLayer.affineTransform = CGAffineTransformMakeScale(1 / [ScaleStore defaultScale].scale, 1 / [ScaleStore defaultScale].scale);
        self.locationLayer.affineTransform = CGAffineTransformRotate(self.locationLayer.affineTransform, M_PI * (newHeading.magneticHeading - self.mapModel.angle.doubleValue) / 180.0 + self.currentRotation);
        
    } else {
        
        self.locationLayer.affineTransform = CGAffineTransformMakeScale(1 / [ScaleStore defaultScale].scale, 1 / [ScaleStore defaultScale].scale);
        self.locationLayer.affineTransform = CGAffineTransformRotate(self.locationLayer.affineTransform, M_PI * (newHeading.magneticHeading / 180.0) + self.currentRotation);
    }
    if (newHeading.headingAccuracy < 0) {
        return;
    }
    self.currentHeading = newHeading.magneticHeading;
}

- (void)pauseLocation {
    
}

- (void)resumeLocation {
    
}

#pragma mark -- 停止定位
- (void)stopLocation {
    [self.locationViewModel stopLocating];
}

- (void)addPushLayer {
    // 在下次添加的时候将数据和视图清空
    
    [self.messageLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.messageLayers removeAllObjects];
    
    [self.textLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.textLayers removeAllObjects];
    [self.pushPoints removeAllObjects];
    
    // 推送消息开关
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"pushMessageKey"]) return;
    
    
    // 添加新的推送消息
    for (SVALocationMessageModel *model in self.messageModels) {
        CGPoint pushPoint = [SVACoordinateConversion getPointWithXspot:model.xSpot Yspot:model.ySpot onMapMode:self.mapModel];
//        [self drawIcon:pushPoint AndText:model.message];
        [self wrapNewControl:model.message atPoint:pushPoint];
        [self.pushPoints addObject:[NSValue valueWithCGPoint:pushPoint]];
    }
    [ScaleStore defaultScale].pushPoints = self.pushPoints;
    
    
    SVALocationMessageModel *messageModel = self.messageModels.count == 0 ? nil : [self.messageModels lastObject];
    NSString *key = messageModel.shopName;
    
    if (!key) return;
    
    NSTimeInterval current_timestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSNumber *timestamp_value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSTimeInterval history_timestamp = timestamp_value.doubleValue;
    
    //小于1分钟
    if (timestamp_value && current_timestamp - history_timestamp < 60) {
        
        return;
        
    } else {
        //添加推送窗口
        [self.pushview addPopViewWithMessage:messageModel.message logoPath:messageModel.pictruePath point:nil isShop:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pushview removePopupView];
        });
        
        [[NSUserDefaults standardUserDefaults] setObject:@(current_timestamp) forKey:key];
    }
}

- (void)wrapNewControl:(NSString *)message atPoint:(CGPoint)point {
    
    CGRect stringRect = [message boundingRectWithSize:CGSizeMake(200, 30)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}
                                              context:nil];
    
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 8 + stringRect.size.width, 8);
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = point;
    layer.affineTransform = CGAffineTransformMakeScale(1 / [ScaleStore defaultScale].scale, 1 / [ScaleStore defaultScale].scale);
    layer.affineTransform = CGAffineTransformRotate(layer.affineTransform, -[ScaleStore defaultScale].rotation);
    [self.layer addSublayer:layer];
    
    // Add image flags
    UIImage *image = [UIImage imageNamed:@"shop_icon"];
    CALayer *imagelayer = [CALayer layer];
    imagelayer.frame = CGRectMake(0, 0, 8, 8);
    imagelayer.contents = (__bridge id _Nullable)(image.CGImage);
    imagelayer.contentsScale = [UIScreen mainScreen].scale;
    
    [layer addSublayer:imagelayer];
    
    [self.messageLayers addObject:imagelayer];
    
    // Add text layer to show message.
    CATextLayer *textlayer = [CATextLayer layer];
    textlayer.frame = CGRectMake(CGRectGetMaxX(imagelayer.frame), CGRectGetMinY(imagelayer.frame), stringRect.size.width, stringRect.size.height);
    textlayer.string = message;
    textlayer.fontSize = 8;
    textlayer.foregroundColor = [UIColor lightGrayColor].CGColor;
    textlayer.font = CFBridgingRetain([UIFont systemFontOfSize:8].fontName);
    textlayer.foregroundColor = [UIColor blackColor].CGColor;
    textlayer.alignmentMode = kCAAlignmentLeft;
    textlayer.contentsScale = [UIScreen mainScreen].scale;
    
    [layer addSublayer:textlayer];
    
    [self.textLayers addObject:textlayer];
}

- (void)removePushLayer {
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.pushview removePopupView];
    
    for (NSValue *value in self.pushPoints) {
        CGPoint tempPoint = value.CGPointValue;
        if (!CGRectContainsPoint(CGRectMake(tempPoint.x - 5, tempPoint.y - 5, 10, 10), touchPoint)) {
            continue;
        }
        
        NSInteger index = [self.pushPoints indexOfObject:value];
        
        [self.pushview addPopViewWithMessage:self.messageModels[index].message logoPath:self.messageModels[index].pictruePath point:value isShop:NO];
        break;
    }
}

- (void)changeScale:(CGFloat)scale Rotation:(CGFloat)rotation {
    self.currentRotation = rotation;
    
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isEqual:self.locationLayer] || [layer isEqual:self.haloLayer]) {
            continue;
        }
        layer.affineTransform = CGAffineTransformIdentity;
        layer.affineTransform = CGAffineTransformMakeScale(1 / scale, 1 / scale);
        layer.affineTransform = CGAffineTransformRotate(layer.affineTransform, -rotation);
    }
}

#pragma mark -- 操作定位点  惯导  路径滤波
- (void)operateLocation {
    double final_x = self.locationData.x / 10;
    double final_y = self.locationData.y / 10;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"insKey"]) {
        //惯导
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[INSAngleSpeed defaultAngleSpeed] start];
        });
        
        // 获取地图角度和磁力计的角度
        
        double navAngle = (self.mapModel.angle.doubleValue + self.currentHeading) / 180.0 * M_PI;
        
        CGPoint newLocation = [INSLocator newLocationWithX:final_x / 10.0 Y:final_y / 10.0 headingAngle:navAngle Velocity:[INSAngleSpeed defaultAngleSpeed].speed];
        
        final_x = newLocation.x;
        final_y = newLocation.y;
        
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"pathFilterKey"]) {
        // 路径滤波
        
        if (![PFFilter sharedPathFilter].fingerPrintXY || [PFFilter sharedPathFilter].fingerPrintXY.count == 0) {
            NSLog(@"路径滤波文件不存在！");
        } else {
            
            dispatch_async(dispatch_queue_create("pathfilter", DISPATCH_QUEUE_CONCURRENT), ^{
                
                CGPoint filterPoint = [[PFFilter sharedPathFilter] calculatePathFilterPoint:CGPointMake(self.locationData.x, self.locationData.y)];
                CGPoint filterLocation = [SVACoordinateConversion getPointWithXspot:filterPoint.x / 10.0 Yspot:filterPoint.y / 10.0 onMapMode:self.mapModel];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.locationPoint = filterLocation;
                    self.locationLayer.position = filterLocation;
                    self.haloLayer.position = filterLocation;
                    if (!self.historyLocation) {
                        self.historyLocation = [NSMutableArray array];
                    }
                    if (![self.historyLocation containsObject:[NSValue valueWithCGPoint:filterLocation]])
                    {
                        [self.historyLocation addObject:[NSValue valueWithCGPoint:filterLocation]];
                    }
                    [self addHistoryLocation];
                });
            });
            return;
//            CGPoint newLocation = [[SVAPathFilter sharedPathFilter] calculatePathFilterPoint:CGPointMake(self.locationData.x, self.locationData.y)];
//            final_x = newLocation.x / 10;
//            final_y = newLocation.y / 10;
        }
    }
    
    CGPoint newLocation = [SVACoordinateConversion getPointWithXspot:final_x Yspot:final_y onMapMode:self.mapModel];
    
    self.locationPoint = newLocation;
    self.locationLayer.position = newLocation;
    self.haloLayer.position = newLocation;
    if (!self.historyLocation) {
        self.historyLocation = [NSMutableArray array];
    }
    if (![self.historyLocation containsObject:[NSValue valueWithCGPoint:newLocation]])
    {
        [self.historyLocation addObject:[NSValue valueWithCGPoint:newLocation]];
    }
    [self addHistoryLocation];
}

- (void)addHistoryLocation {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"followLocationKey"]) {
        [self.historyLocation removeAllObjects];
        return;
    }
    
    if (!self.historyLayer) {
        self.historyLayer = [NSMutableArray array];
    }
    
    for (CALayer *layer in self.historyLayer) {
        [layer removeFromSuperlayer];
    }
    
    UIImage *history = [UIImage imageNamed:@"trackingpoint"];
    
    for (NSValue *value in self.historyLocation) {
        CGPoint point = value.CGPointValue;
        
        CALayer *layer = [CALayer layer];
        layer.position = point;
        layer.bounds = CGRectMake(0, 0, 4, 4);
        layer.contents = (__bridge id _Nullable)(history.CGImage);
        layer.affineTransform = CGAffineTransformMakeScale(1 / [ScaleStore defaultScale].scale, 1 / [ScaleStore defaultScale].scale);
        [self.layer addSublayer:layer];
        [self.historyLayer addObject:layer];
    }
}

#pragma mark -- 添加定位点
- (void)addLocation {
    
    UIImage *image = [UIImage imageNamed:@"locate_arrow"];
    self.locationLayer = [CALayer layer];
    self.locationLayer.zPosition = 1.0;
    self.locationLayer.bounds = CGRectMake(0, 0, 25, 25);
    self.locationLayer.contents = (__bridge id _Nullable)(image.CGImage);
    [self.layer addSublayer:self.locationLayer];
    
    // Add halo circle
    self.haloLayer = [CALayer layer];
    self.haloLayer.bounds = CGRectMake(0, 0, 50, 50);
    self.haloLayer.backgroundColor = [UIColor colorWithRed:0.000 green:0.000 blue:1.000 alpha:0.1].CGColor;
    self.haloLayer.cornerRadius = 25;
    [self.layer addSublayer:self.haloLayer];
    
    // 添加路径滤波点
//    for (NSValue *value in [SVAPathFilter sharedPathFilter].fingerPrintXY) {
//        CALayer *layer = [CALayer layer];
//        layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"blue"].CGImage);
//        CGPoint newLocation = [SVACoordinateConversion getPointWithXspot:value.CGPointValue.x/10 Yspot:value.CGPointValue.y/10 onMapMode:self.mapModel];
//        layer.position = newLocation;
//        layer.bounds = CGRectMake(0, 0, 2, 2);
//        layer.cornerRadius = 1.0;
//        [self.layer addSublayer:layer];
//    }
}

- (void)changeTransform:(CGFloat)scale rotation:(CGFloat)rotation translate:(CGFloat)translate {
    self.layer.sublayerTransform = CATransform3DScale(self.layer.sublayerTransform, 1/scale, 1/scale, 0);
    self.layer.sublayerTransform = CATransform3DRotate(self.layer.sublayerTransform, rotation / 180 * M_PI, 0, 0, 1);
    self.layer.sublayerTransform = CATransform3DScale(self.layer.sublayerTransform, translate, translate, translate);
}


- (void)resetAll {
    
}

#pragma mark -- 移除 messageLayers textLayers
- (void)removePoint
{
    [self.messageLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.messageLayers removeAllObjects];
    
    [self.textLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.textLayers removeAllObjects];
    
    [self.historyLayer enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.historyLayer removeAllObjects];
    [self.historyLocation removeAllObjects];
}

#pragma mark -- 移除点位点
- (void)removeLocationPoint
{
    self.locationLayer.hidden = YES;
    self.haloLayer.hidden = YES;
}

- (void)locationPointKVO
{
//    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"ANIMATION_TAG"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [self addObserver:self forKeyPath:@"locationPoint" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"ANIMATION_TAG"];
    
    if ([str isEqualToString:@"is"]) {
        if ([keyPath isEqualToString:@"locationPoint"]) {
            
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"locationPoint" object:nil userInfo:change];
            //发送消息
            [[NSNotificationCenter defaultCenter] postNotification:notice];
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"height" context:nil];
}

@end
