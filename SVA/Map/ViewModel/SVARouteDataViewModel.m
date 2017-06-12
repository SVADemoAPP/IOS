//
//  SVARouteDataViewModel.m
//  SVA
//
//  Created by Zeacone on 16/1/31.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVARouteDataViewModel.h"

#define GET_ROUTE @"/sva/api/getRouteData"

@implementation SVARouteDataViewModel

- (void)getRouteData:(void (^)(NSMutableArray<SVARouteData *> *))compeletionHandler {
    
    NSString *fullAddress = [BASE_IP stringByAppendingString:GET_ROUTE];
    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"],
                                @"isPush": @"2"};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                 URLString:fullAddress
                                                                                parameters:parameter
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response,
                                                                    id  _Nullable responseObject,
                                                                    NSError * _Nullable error) {
                                                    if (!error) {
                                                        NSArray *routeInformation = [responseObject objectForKey:@"data"];
                                                        NSMutableArray<SVARouteData *> *tempArray = [NSMutableArray array];
                                                        for (NSDictionary *dictionary in routeInformation) {
                                                            SVARouteData *route = [[SVARouteData alloc] initModelWithDictionaryAndExclude:dictionary];
                                                            [tempArray addObject:route];
                                                        }
                                                        compeletionHandler(tempArray);
                                                    }
                                                }];
    [dataTask resume];
}

@end
