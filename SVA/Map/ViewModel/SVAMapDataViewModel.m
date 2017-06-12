//
//  MapViewModels.m
//  SVA
//
//  Created by Zeacone on 15/12/21.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVAMapDataViewModel.h"

#define GET_MAP @"/sva/api/getMapDataByIp"
#define GET_SUBSCRIPTION @"/sva/api/subscription?storeId="

@implementation SVAMapDataViewModel

+ (instancetype)sharedMapViewModel {
    static SVAMapDataViewModel *viewModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewModel = [[SVAMapDataViewModel alloc] init];
    });
    return viewModel;
}

- (NSMutableArray *)places {
    if (!self.models) return nil;
    if (!_places) {
        _places = [NSMutableArray array];
    }
    [_places removeAllObjects];
    for (NSDictionary *dictionary in self.models) {
        SVAMapDataModel *model = [[SVAMapDataModel alloc] initModelWithDictionaryAndExclude:dictionary];
//        [[SVANetworkResource sharedResource] downloadSVGFileWithFilename:model.svg completionHandler:nil];
        // Archive the map data to local.
        if (![_places containsObject:model.place]) {
            [_places addObject:model.place];
        }
    }
    return _places;
}

- (NSMutableArray *)placeIDs {
    if (!self.models) return nil;
    if (!_placeIDs) {
        _placeIDs = [NSMutableArray array];
    }
    for (NSDictionary *dictionary in self.models) {
        SVAMapDataModel *model = [[SVAMapDataModel alloc] initModelWithDictionaryAndExclude:dictionary];
        if (![_placeIDs containsObject:[NSNumber numberWithInteger:model.placeId]]) {
            [_placeIDs addObject:[NSNumber numberWithInteger:model.placeId]];
        }
    }
    return _placeIDs;
}

- (NSMutableArray *)floors {
    if (!_floors) {
        _floors = [NSMutableArray array];
    }
    return _floors;
}

- (NSMutableArray *)getFloorsByPlace:(NSString *)place {
    if (!self.models) return nil;
    [self.floors removeAllObjects];
    for (NSDictionary *dictionary in self.models) {
        SVAMapDataModel *model = [[SVAMapDataModel alloc] initModelWithDictionaryAndExclude:dictionary];
        if ([model.place isEqualToString:place] && ![self.floors containsObject:model]) {
            [self.floors addObject:model];
        }
    }
    return self.floors;
}

- (SVAMapDataModel *)getMapDataByFloorNo:(NSUInteger)floorNo {
    if (!self.models) return nil;
    SVAMapDataModel *model;
    for (NSDictionary *dictionary in self.models) {
         model = [[SVAMapDataModel alloc] initModelWithDictionaryAndExclude:dictionary];
        if (model.floorNo == floorNo) {
            break;
        }
    }
    return model;
}

- (void)getMapInfo {
    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"],
                                @"isPush": @"2"};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[BASE_IP stringByAppendingString:GET_MAP]
                                                                                parameters:parameter
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    @weakify(self);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response,
                                                                    id  _Nullable responseObject,
                                                                    NSError * _Nullable error) {
        @strongify(self);
        if (!error) {
            self.models = [responseObject objectForKey:@"data"];
        }
        self.completeHandler();
    }];
    [dataTask resume];
}

- (void)startSubscriptionWith:(NSUInteger)placeid {
    // Deal with the address with place id.
    NSString *finalAddress = [GET_SUBSCRIPTION stringByAppendingString:[NSString stringWithFormat:@"%@&ip=%@", @(placeid), (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"]]];
    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"],
                                @"isPush": @"2"};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[BASE_IP stringByAppendingString:finalAddress]
                                                                                parameters:parameter
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                  //  NSLog(@"subscription");
                                                    [[NSUserDefaults standardUserDefaults] setObject:@(placeid) forKey:@"currentplaceid"];
                                                }];
    [dataTask resume];
}

@end
