//
//  SVAUnsubscribeViewModel.m
//  SVA
//
//  Created by 一样 on 16/2/17.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAUnsubscribeViewModel.h"

#define GET_UNSUBSCRIPTION @"/sva/api/unsubscription?storeId="

@implementation SVAUnsubscribeViewModel

+ (void)startUnsubscriptionWith:(NSUInteger)placeid {
    // Deal with the address with place id.
    NSString *finalAddress = [GET_UNSUBSCRIPTION stringByAppendingString:[NSString stringWithFormat:@"%@&ip=%@", @(placeid), (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"]]];
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
                                                }];
    [dataTask resume];
}

@end
