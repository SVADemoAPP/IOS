//
//  SVALocate.m
//  SVA
//
//  Created by Zeacone on 15/12/21.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVALocationViewModel.h"
#import "SVAMapView.h"

@class SVAMapView;
@class SVAPOI;

#define GET_LOCATION @"/sva/api/getData"

static dispatch_queue_t get_location_queue() {
    static dispatch_queue_t get_location_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        get_location_queue = dispatch_queue_create("server.connection.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return get_location_queue;
}

@implementation SVALocationViewModel

+ (instancetype)sharedLocateViewModel {
    static SVALocationViewModel *locateViewModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locateViewModel = [[SVALocationViewModel alloc] init];
    });
    return locateViewModel;
}

- (void)stopLocating {
    [self.timer invalidate];
    [SVAMapView sharedMap].locate.selected = NO;
    //判断网络请求
    [ScaleStore defaultScale].isHttpRequest = NO;
}

- (void)startTimer {
    [self.timer fire];
}

- (void)startLocating {
    /// Test method.
//    [self startRunloop];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[SVANavAngleAndSpeed defaultNav] threadStart];
//    });
    [ScaleStore defaultScale].isHttpRequest = YES;
//    return;
    
    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"], @"isPush": @"2"};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[BASE_IP stringByAppendingString:GET_LOCATION]
                                                                                parameters:parameter
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    @weakify(self);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    
        if (!responseObject) return;

        @strongify(self);
        // 获取定位数据
        NSDictionary *data = [responseObject objectForKey:@"data"];
        if (!data || [data isEqual:[NSNull null]]) return;
        
        // 获取定位数据
        SVALocationDataModel *locationModel = [[SVALocationDataModel alloc] initModelWithDictionaryAndExclude:data];
        
        // 根据定位所在的楼层号来获取对应楼层的数据
        SVAMapDataModel *mapDataModel = [[SVAMapDataViewModel sharedMapViewModel] getMapDataByFloorNo:locationModel.z];
        
                  
        [SVAMapView sharedMap].mapView.delegate = self;
        // 定位在本楼层不需要进行切换
        if ([SVAMapView sharedMap].mapModel.floorNo == mapDataModel.floorNo) {
            // 更改导航栏标题为商场名字
            [SVAMapView sharedMap].getMarketTitleHandler(mapDataModel.place);


            [self startRunloop];
            return;
        }
        
        // 在地图加载完成之后才开始进行下一次定位
        [[SVAMapView sharedMap].mapView loadMapWithMapModel:mapDataModel];
    }];
    [dataTask resume];
}

- (void)mapHasDownloaded:(SVAMapDataModel *)mapDataModel {
    // 更改导航栏标题为商场名字
    [SVAMapView sharedMap].getMarketTitleHandler(mapDataModel.place);
    
    // 地图加载完成之后开始定位线程
    [self startRunloop];
    // 添加商家信息
    [[SVAMapView sharedMap] addShopView];
    [[SVAMapView sharedMap].shopView getShopsWithMapModel:mapDataModel];
    
    [SVAMapView sharedMap].floors = [[SVAMapDataViewModel sharedMapViewModel] getFloorsByPlace:mapDataModel.place];
    [[SVAMapView sharedMap].floorSelection reloadData];
    
    // 自动选择所在楼层
    for (NSInteger i = 0; i < [SVAMapView sharedMap].floors.count; i++) {
        NSInteger floorNumber = ((SVAMapDataModel *)([SVAMapView sharedMap].floors[i])).floorNo;
        if (mapDataModel.floorNo == floorNumber) {
            [[SVAMapView sharedMap].floorSelection selectRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
    
    // 自动选择所在商城
    for (NSInteger i = 0; i < [SVAPopupView sharedPopup].places.count; i++) {
        if ([mapDataModel.place isEqualToString:[SVAPopupView sharedPopup].places[i]]) {
            [[SVAPopupView sharedPopup].storeTableview selectRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            break;
        }
    }
}

- (void)startRunloop {
    dispatch_async(get_location_queue(), ^{
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
        [runloop run];
    });
}

- (void)getLocation {
    /// test data.
//    NSDictionary *data = @{@"idType": @"12", @"timestamp": @"3243472161", @"dataType": @"seller", @"x" : @(arc4random() % 1000 + 0), @"y": @(arc4random() % 1500 + 0), @"z": @10001, @"userID": @"3442", @"path": @"imagePath", @"xo": @"0", @"yo": @"0", @"scale": @"23.4"};
//    NSDictionary *data = @{@"idType": @"12", @"timestamp": @"3243472161", @"dataType": @"seller", @"x" : @(120 + 0), @"y": @(220 + 0), @"z": @10001, @"userID": @"3442", @"path": @"imagePath", @"xo": @"0", @"yo": @"0", @"scale": @"23.4"};
//    SVALocationDataModel *locationData = [[SVALocationDataModel alloc] initModelWithDictionaryAndExclude:data];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(getLocationModel:MessageModels:onMapModel:)]) {
//        [self.delegate getLocationModel:locationData MessageModels:nil onMapModel:[SVAMapView sharedMap].mapModel];
//    }
//    return;
    
    
    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"], @"isPush": @"2"};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[BASE_IP stringByAppendingString:GET_LOCATION]
                                                                                parameters:parameter
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    @weakify(self);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response,
                                                                    id  _Nullable responseObject,
                                                                    NSError * _Nullable error) {
                                                    if ([ScaleStore defaultScale].isHttpRequest) {
                                                        
                                                    
        if (responseObject) {
            @strongify(self);
        
            // 获取定位数据
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            // 存储惯导参数时间戳
            id paramTimeStamp = [responseObject objectForKey:@"paramUpdateTime"];
            [[NSUserDefaults standardUserDefaults] setObject:paramTimeStamp forKey:@"paramUpdateTime"];
            
            if (!data || [data isEqual:[NSNull null]]) return;
            SVALocationDataModel *locationData = [[SVALocationDataModel alloc] initModelWithDictionaryAndExclude:data];
            
            // 获取定位所在的地图数据
            SVAMapDataModel *mapDataModel = [[SVAMapDataViewModel sharedMapViewModel] getMapDataByFloorNo:locationData.z];
            
            // 获取推送信息
            // test message data
//            NSDictionary *message1 = @{@"place": @"oceanstore", @"placeId": @"3243472161", @"shopName": @"KFC", @"timeInterval" : @"1", @"xSpot" : @(20), @"ySpot": @(20), @"floor": @10001, @"rangeSpot": @"34", @"pictruePath": @"imagePath", @"moviePath": @"moviePath", @"id": @"100", @"floorNo": @"10001", @"message": @"it's a message.", @"isEnable": @"1"};
//            NSDictionary *message2 = @{@"place": @"oceanstore", @"placeId": @"3243472161", @"shopName": @"KFC", @"timeInterval" : @"1", @"xSpot" : @(30), @"ySpot": @(30), @"floor": @10001, @"rangeSpot": @"34", @"pictruePath": @"imagePath", @"moviePath": @"moviePath", @"id": @"200", @"floorNo": @"10001", @"message": @"it's a message.", @"isEnable": @"1"};
//            NSDictionary *message3 = @{@"place": @"oceanstore", @"placeId": @"3243472161", @"shopName": @"KFC", @"timeInterval" : @"1", @"xSpot" : @(40), @"ySpot": @(40), @"floor": @10001, @"rangeSpot": @"34", @"pictruePath": @"imagePath", @"moviePath": @"moviePath", @"id": @"300", @"floorNo": @"10001", @"message": @"it's a message.", @"isEnable": @"1"};
//            NSArray<NSDictionary *> *messages = [NSArray arrayWithObjects:message1, message2, message3, nil];
            
            NSArray *messages = [responseObject objectForKey:@"message"];
            NSMutableArray *tempMessage = [NSMutableArray array];
            for (NSDictionary *dictionary in messages) {
                SVALocationMessageModel *model = [[SVALocationMessageModel alloc] initModelWithDictionaryAndExclude:dictionary];
                [tempMessage addObject:model];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getLocationModel:MessageModels:onMapModel:)]) {
                [self.delegate getLocationModel:locationData MessageModels:tempMessage onMapModel:mapDataModel];
            }
        }}
    }];
    [dataTask resume];
}

@end
