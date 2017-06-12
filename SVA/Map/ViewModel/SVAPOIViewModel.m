//
//  SVAPOIViewModel.m
//  SVA
//
//  Created by Zeacone on 15/12/23.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVAPOIViewModel.h"

#define GET_POI @"/sva/api/getSellerInfo?floorNo="

@implementation SVAPOIViewModel

+ (instancetype)sharedPOIViewModel {
    static SVAPOIViewModel *poiViewModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        poiViewModel = [[SVAPOIViewModel alloc] init];
    });
    return poiViewModel;
}

- (void)getPOIsWithMapDataModel:(SVAMapDataModel *)model {
    
    self.mapModel = model;
    NSString *middleAddress = [BASE_IP stringByAppendingString:GET_POI];
    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"],
                                @"isPush": @"2"};
    @weakify(self);
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[middleAddress stringByAppendingFormat:@"%@", @(self.mapModel.floorNo)]
                                                                                parameters:parameter
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response,
                                                                    id  _Nullable responseObject,
                                                                    NSError * _Nullable error) {
        @strongify(self);
        NSArray *poiData = [responseObject objectForKey:@"data"];
        NSMutableArray<SVAPOIModel *> *shopModels = [NSMutableArray array];
        
        for (NSDictionary *dictionary in poiData) {
            SVAPOIModel *model = [[SVAPOIModel alloc] initModelWithDictionaryAndExclude:dictionary];
            [shopModels addObject:model];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(getShopModels:)]) {
            [self.delegate getShopModels:shopModels];
        }
    }];
    [dataTask resume];
}

@end
