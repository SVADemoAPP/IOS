//
//  SVAInheritViewModel.h
//  SVA
//
//  Created by XuZongCheng on 16/2/21.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVAInheritialModel.h"

@interface SVAInheritViewModel : NSObject

+ (void)getInhertialData:(void(^)(SVAInheritialModel *inheritialModel))handler;

@end
