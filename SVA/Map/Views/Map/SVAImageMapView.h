//
//  SVAImageMapView.h
//  SVA
//
//  Created by Zeacone on 16/3/7.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVAImageMapView : UIView

- (void)loadImageMapWithName:(NSString *)imageName handler:(void(^)())handler;

@end
