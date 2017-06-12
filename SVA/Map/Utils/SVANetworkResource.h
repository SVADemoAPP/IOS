//
//  SVANetworkResource.h
//  SVA
//
//  Created by Zeacone on 15/12/28.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVANetworkResource : NSObject

+ (instancetype)sharedResource;
- (void)loadImage:(UIImageView *)imageView WithPath:(NSString *)path compeletionHandler:(void(^)())handler;
- (void)downloadSVGFileWithFilename:(NSString *)filename completionHandler:(void(^)(NSURL *filepath))handler;
- (void)downloadPathFilterWithFilename:(NSString *)filename CompletionHandler:(void(^)(NSURL *filepath))completionHandler;
- (void)downloadPathFileWithMapModel:(SVAMapDataModel *)mapModel;
- (void)loadLogo:(UIImageView *)imageView WithPath:(NSString *)path;

+ (void)downloadVideoWithVideoName:(NSString *)name completeHandler:(void(^)(NSURL *pathurl))handler;

@end
