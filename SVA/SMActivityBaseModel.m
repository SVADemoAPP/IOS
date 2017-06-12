//
//  SMActivityBaseModel.m
//  Lib
//
//  Created by Lwj on 15/10/30.
//  Copyright © 2015年 Successfulmatch. All rights reserved.
//

#import "SMActivityBaseModel.h"

@implementation SMActivityBaseModel

- (instancetype) initModelWithDictionaryAndExclude:(NSDictionary*)dictionary
{
    SMActivityBaseModel *model = [[self.class alloc] init];
    NSArray* cols = [model getPropertyList];
    for (int i=0; i<[cols count]; i++) {
        id col= [cols objectAtIndex:i];
        if([[dictionary allKeys] containsObject:col])
        {

            if ([dictionary objectForKey:col] == [NSNull null]) {
//                [model setValue:nil forKey:col];
            } else {
                if ([col isMemberOfClass:[NSNumber class]]) {
                    ;
                }
                [model setValue:[dictionary objectForKey:col] forKey:col];
            }
        }
    }
    return model;
}

-(NSString *)jsonStringWithString:(NSString *) string {
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

- (NSString *)jsonStringWithArray:(NSArray *)array {
    //    NSMutableString *reString = [NSMutableString string];
    //    [reString appendString:@"["];
    //    NSMutableArray *values = [NSMutableArray array];
    //    for (id valueObj in array) {
    //        NSString *value = [NSString jsonStringWithObject:valueObj];
    //        if (value) {
    //            [values addObject:[NSString stringWithFormat:@"%@",value]];
    //        }
    //    }
    //    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    //    [reString appendString:@"]"];
    //    return reString;
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSString stringWithFormat:@"\"type\":\"%@\",\"type_id\":\"%@\",\"count\":\"%@\"",array[0],array[1],array[2]]];
    
    
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"},"];
    return reString;
    
}


- (NSString *)toJsonString:(NSDictionary *)dic {
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark - 根据键值对初始化对象各属性,排除对象需要初始化的属性

- (instancetype)initModelWithDictionaryAndExclude:(NSDictionary*)dictionary andExclude:(NSArray*)exclude
{
    SMActivityBaseModel *model = [[self.class alloc] init];
    NSArray* cols = [model getPropertyList];
    for (int i=0; i<[cols count]; i++) {
        NSString* col= [cols objectAtIndex:i];
        if([[dictionary allKeys] containsObject:col] && ![exclude containsObject:col])
        {
            [model setValue:([dictionary objectForKey:col] == [NSNull null] ? @"" : [dictionary objectForKey:col]) forKey:col];
        }
    }
    return model;
}

- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource {
    BOOL ret = NO;
    for (NSString *key in [self getPropertyList]) {
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }else{
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            //该值不为NSNULL，并且也不为nil
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                [self setValue:propertyValue forKey:key];
            }
        }
    }
    return ret;
}

- (id)copyWithZone:(NSZone *)zone {
    SMActivityBaseModel *model = [self.class allocWithZone:zone];
    NSArray *propertyNames = [self getPropertyList:self.class];
    for (NSString *name in propertyNames) {
        [model setValue:[self valueForKey:name] forKey:name] ;
    }
    return model;
}


#pragma mark - 获取对象所包含的所有属性-当前类

-(NSArray *)getPropertyList{
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        NSString *propertyName = [self typeWithObjectType:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];

            [propertyArray addObject:propertyName];
    }
    free(properties);
    return propertyArray;
}

-(NSString *)typeWithObjectType:(NSString *)ocType
{
    NSString *type = [ocType componentsSeparatedByString:@","][0];
//    type = [type stringByReplacingOccurrencesOfString:@"T" withString:@""];
    return type;
}
#pragma mark - 获取对象所包含的所有属性-包含父类

-(NSArray *)getPropertyList:(Class)class{
    if(class == [NSObject class]){
        return nil;
    }
    u_int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    
    [propertyArray addObjectsFromArray: [self getPropertyList:class.superclass]];
    
    return propertyArray;
}

@end

