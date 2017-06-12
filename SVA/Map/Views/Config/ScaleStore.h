//
//  ScaleStore.h
//  SVA
//
//  Created by 君若见故 on 16/2/19.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用来存储形变比例
 */
@interface ScaleStore : NSObject

@property (nonatomic,assign ) CGFloat        scale;
@property (nonatomic, assign) CGFloat        rotation;
@property (nonatomic,assign ) BOOL           isHttpRequest;
@property (nonatomic, strong) NSMutableArray *inheritialParameters;
@property (nonatomic, strong) NSMutableArray *shoplayers;
@property (nonatomic, strong) NSMutableArray *pushlayers;
@property (nonatomic, strong) NSMutableArray *shopPoints;
@property (nonatomic, strong) NSMutableArray *pushPoints;

+(instancetype)defaultScale;

@end
