//
//  SVARouteDataViewModel.h
//  SVA
//
//  Created by Zeacone on 16/1/31.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVARouteData.h"

@interface SVARouteDataViewModel : NSObject

- (void)getRouteData:(void(^)(NSMutableArray<SVARouteData *> *data))compeletionHandler;

@end
