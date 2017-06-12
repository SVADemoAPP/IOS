//
//  INSQueue.m
//  INS
//
//  Created by Zeacone on 16/4/14.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "INSQueue.h"

@interface INSQueue ()
{
    NSMutableArray *container_array;
    dispatch_queue_t fetch_queue;
    NSLock *lock;
}

@end

@implementation INSQueue

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    
    self = [super init];
    if (self) {
        container_array = [NSMutableArray new];
        fetch_queue = queue;
        lock = [NSLock new];
    }
    return self;
}

- (NSInteger)count {
    return container_array.count;
}

- (NSArray *)fetchQueueData {
    return [container_array copy];
}

- (void)enqueue:(id)obj {
    
    [lock lock];
//    dispatch_barrier_async(fetch_queue, ^{
        [container_array addObject:obj];
        if (container_array.count > 60) {
            [container_array removeObjectAtIndex:0];
        }
//    });
    [lock unlock];
}


- (id)dequeue {
    
    __block id obj = nil;
    if(container_array.count > 0) {
        
        dispatch_barrier_async(fetch_queue, ^{
            obj = [container_array firstObject];
            [container_array removeObjectAtIndex:0];
        });
    }
    return obj;
}

- (void)clear {
    
    dispatch_barrier_async(fetch_queue, ^{
        [container_array removeAllObjects];
    });
}

@end
