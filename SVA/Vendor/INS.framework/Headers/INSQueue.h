//
//  INSQueue.h
//  INS
//
//  Created by Zeacone on 16/4/14.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INSQueue : NSObject

- (instancetype)initWithQueue:(dispatch_queue_t)queue;

- (void)enqueue:(id)anObject;

- (id)dequeue;

- (void)clear;

- (NSInteger)count;

- (NSArray *)fetchQueueData;

@property (nonatomic, readonly) NSInteger count;

@end
