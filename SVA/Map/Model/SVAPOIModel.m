//
//  SVAPOIModel.m
//  SVA
//
//  Created by Zeacone on 15/12/23.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVAPOIModel.h"

@implementation SVAPOIModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    self.place = [aDecoder decodeObjectForKey:@"place"];
    self.placeId = ((NSNumber *)[aDecoder decodeObjectForKey:@"placeId"]).integerValue;
    self.floor = [aDecoder decodeObjectForKey:@"floor"];
    self.xSpot = ((NSNumber *)[aDecoder decodeObjectForKey:@"xSpot"]).doubleValue;
    self.ySpot = ((NSNumber *)[aDecoder decodeObjectForKey:@"ySpot"]).doubleValue;
    self.info = [aDecoder decodeObjectForKey:@"info"];
    self.isEnable = [aDecoder decodeObjectForKey:@"isEnable"];
    self.pictruePath = [aDecoder decodeObjectForKey:@"pictruePath"];
    self.moviePath = [aDecoder decodeObjectForKey:@"moviePath"];
    self.isVip = [aDecoder decodeObjectForKey:@"isVip"];
    self.id = [aDecoder decodeObjectForKey:@"id"];
    self.floorNo = [aDecoder decodeObjectForKey:@"floorNo"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.place forKey:@"place"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.placeId] forKey:@"placeId"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.xSpot] forKey:@"xSpot"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.ySpot] forKey:@"ySpot"];
    [aCoder encodeObject:self.info forKey:@"info"];
    [aCoder encodeObject:self.isEnable forKey:@"isEnable"];
    [aCoder encodeObject:self.pictruePath forKey:@"pictruePath"];
    [aCoder encodeObject:self.moviePath forKey:@"moviePath"];
    [aCoder encodeObject:self.isVip forKey:@"isVip"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.floor forKey:@"floor"];
    [aCoder encodeObject:self.floorNo forKey:@"floorNo"];
}

@end
