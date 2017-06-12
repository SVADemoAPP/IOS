//
//  SVAInheritViewModel.m
//  SVA
//
//  Created by XuZongCheng on 16/2/21.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAInheritViewModel.h"

#define GET_INHERITIAL_PARAM @"/sva/api/getDataParam"

@implementation SVAInheritViewModel

+ (void)getInhertialData:(void(^)(SVAInheritialModel *inheritialModel))handler {
    
    NSString *fullAddress = [BASE_IP stringByAppendingString:GET_INHERITIAL_PARAM];
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
                                                    if (responseObject) {
                                                        NSArray *datas = (NSArray *)responseObject[@"data"];
                                                        NSDictionary *parameter = (NSDictionary *)[datas firstObject];
                                                        SVAInheritialModel *model = [[SVAInheritialModel alloc] initModelWithDictionaryAndExclude:parameter];
                                                        handler(model);
                                                    }
                                                }];
    [dataTask resume];
}

@end
