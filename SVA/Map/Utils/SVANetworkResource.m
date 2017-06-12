//
//  SVANetworkResource.m
//  SVA
//
//  Created by Zeacone on 15/12/28.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVANetworkResource.h"

@implementation SVANetworkResource

+ (instancetype)sharedResource {
    static SVANetworkResource *resource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resource = [[SVANetworkResource alloc] init];
    });
    return resource;
}

- (void)downloadSVGFileWithFilename:(NSString *)filename completionHandler:(void(^)(NSURL *filepath))handler {
    NSString *tempPath = [BASE_IP stringByAppendingString:@"/sva/upload"];
    NSString *fullPath = [tempPath stringByAppendingPathComponent:filename];
    
    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"],
                                @"isPush": @"2"};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                 URLString:fullPath
                                                                                parameters:parameter
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            handler(filePath);
        } else {
            handler(nil);
        }
    }];
    [downloadTask resume];
}

- (void)downloadPathFilterWithFilename:(NSString *)filename CompletionHandler:(void(^)(NSURL *filepath))completionHandler {
    NSString *tempPath = [BASE_IP stringByAppendingString:@"/sva/upload"];
    NSString *fullPath = [tempPath stringByAppendingPathComponent:filename];
    
//    NSDictionary *parameter = @{@"ip": (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"],
//                                @"isPush": @"2"};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                 URLString:fullPath
                                                                                parameters:nil
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response,
                          NSURL * _Nullable filePath,
                          NSError * _Nullable error) {
        if (!error) {
            completionHandler(filePath);
        }
    }];
    [downloadTask resume];
}

- (void)downloadPathFileWithMapModel:(SVAMapDataModel *)mapModel {
    NSString *tempPath = [BASE_IP stringByAppendingString:@"/sva/upload"];
    NSString *fullPath = [tempPath stringByAppendingPathComponent:mapModel.pathFile];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                 URLString:fullPath
                                                                                parameters:nil
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];
        NSString *tmpPath = [NSString stringWithFormat:@"%@%@.xml", mapModel.place, mapModel.floor];
        return [documentsDirectoryURL URLByAppendingPathComponent:tmpPath];
    } completionHandler:^(NSURLResponse * _Nonnull response,
                          NSURL * _Nullable filePath,
                          NSError * _Nullable error) {
    }];
    [downloadTask resume];
}

- (void)loadImage:(UIImageView *)imageView WithPath:(NSString *)path compeletionHandler:(void(^)())handler {
    if (!path) return;
    
    
    NSString *fullPath = [BASE_IP stringByAppendingString:@"/sva/upload/"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = CustomLocalizedString(@"下载地图中...",nil);
   
    [imageView sd_setImageWithURL:[NSURL URLWithString:[fullPath stringByAppendingString:path]]
                 placeholderImage:[UIImage imageNamed:@"bb.jpg"]
                          options:SDWebImageHighPriority
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             handler();
                             NSAssert([NSThread isMainThread], @"Need run this on main thread.");
                             [hud hide:YES];
                             [hud removeFromSuperview];
                         }];
}

- (void)loadLogo:(UIImageView *)imageView WithPath:(NSString *)path {
    
    imageView.image = [UIImage imageNamed:@"failed.png"];
    if (!path) return;
    NSString *fullPath = [BASE_IP stringByAppendingString:@"/sva/upload/"];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[fullPath stringByAppendingString:path]]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[fullPath stringByAppendingString:path]]
//                 placeholderImage:[UIImage imageNamed:@"huawei.jpg"]
//                          options:SDWebImageHighPriority
//                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                             
//                         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                         }];
}

+ (void)downloadVideoWithVideoName:(NSString *)name completeHandler:(void (^)(NSURL *))handler {
    NSString *tempPath = [BASE_IP stringByAppendingString:@"/sva/upload"];
    NSString *fullPath = [tempPath stringByAppendingPathComponent:name];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                 URLString:fullPath
                                                                                parameters:nil
                                                                                     error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response,
                          NSURL * _Nullable filePath,
                          NSError * _Nullable error) {
        handler(filePath);
    }];
    [downloadTask resume];
}

@end
