//
//  SMActivityBaseModel.h
//  Lib
//
//  Created by Lwj on 15/10/30.
//  Copyright © 2015年 Successfulmatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SMActivityBaseModel : NSObject<NSCopying>

- (id)initModelWithDictionaryAndExclude:(NSDictionary*)dictionary;

@end
