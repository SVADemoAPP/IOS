//
//  LocateModel.m
//  SVA
//
//  Created by Zeacone on 15/12/21.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVALocationModel.h"

@implementation SVALocationDataModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    self.idType = [aDecoder decodeObjectForKey:@"idType"];
    self.timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
    self.dataType = [aDecoder decodeObjectForKey:@"dataType"];
    self.x = ((NSNumber *)[aDecoder decodeObjectForKey:@"x"]).doubleValue;
    self.y = ((NSNumber *)[aDecoder decodeObjectForKey:@"y"]).doubleValue;
    self.z = ((NSNumber *)[aDecoder decodeObjectForKey:@"z"]).doubleValue;
    self.userID = [aDecoder decodeObjectForKey:@"userID"];
    self.path = [aDecoder decodeObjectForKey:@"path"];
    self.xo = [aDecoder decodeObjectForKey:@"xo"];
    self.yo = [aDecoder decodeObjectForKey:@"yo"];
    self.scale = [aDecoder decodeObjectForKey:@"scale"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idType forKey:@"idType"];
    [aCoder encodeObject:self.timestamp forKey:@"timestamp"];
    [aCoder encodeObject:self.dataType forKey:@"dataType"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.x] forKey:@"x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.y] forKey:@"y"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.z] forKey:@"z"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.xo forKey:@"xo"];
    [aCoder encodeObject:self.yo forKey:@"yo"];
    [aCoder encodeObject:self.scale forKey:@"scale"];
}

@end

@implementation SVALocationMessageModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    self.place = [aDecoder decodeObjectForKey:@"place"];
    self.placeId = [aDecoder decodeObjectForKey:@"placeId"];
    self.shopName = [aDecoder decodeObjectForKey:@"shopName"];
    self.xSpot = ((NSNumber *)[aDecoder decodeObjectForKey:@"xSpot"]).doubleValue;
    self.ySpot = ((NSNumber *)[aDecoder decodeObjectForKey:@"ySpot"]).doubleValue;
    self.floor = [aDecoder decodeObjectForKey:@"floor"];
    self.rangeSpot = ((NSNumber *)[aDecoder decodeObjectForKey:@"rangeSpot"]).doubleValue;
    self.pictruePath = [aDecoder decodeObjectForKey:@"pictruePath"];
    self.moviePath = [aDecoder decodeObjectForKey:@"moviePath"];
    self.id = [aDecoder decodeObjectForKey:@"id"];
    self.floorNo = [aDecoder decodeObjectForKey:@"floorNo"];
    self.message = [aDecoder decodeObjectForKey:@"message"];
    self.isEnable = [aDecoder decodeObjectForKey:@"isEnable"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.place forKey:@"place"];
    [aCoder encodeObject:self.placeId forKey:@"placeId"];
    [aCoder encodeObject:self.shopName forKey:@"shopName"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.xSpot] forKey:@"xSpot"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.ySpot] forKey:@"ySpot"];
    [aCoder encodeObject:self.floor forKey:@"floor"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.rangeSpot] forKey:@"rangeSpot"];
    [aCoder encodeObject:self.pictruePath forKey:@"pictruePath"];
    [aCoder encodeObject:self.moviePath forKey:@"moviePath"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.floorNo forKey:@"floorNo"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.isEnable forKey:@"isEnable"];
}

@end

@implementation SVALocationModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    self.message = [aDecoder decodeObjectForKey:@"message"];
    self.data = [aDecoder decodeObjectForKey:@"data"];
    self.error = [aDecoder decodeObjectForKey:@"error"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.error forKey:@"error"];
}

@end