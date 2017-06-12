//
//  SVAImageMapView.m
//  SVA
//
//  Created by Zeacone on 16/3/7.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAImageMapView.h"

@implementation SVAImageMapView

- (void)loadImageMapWithName:(NSString *)imageName handler:(void (^)())handler {
    if (!imageName) return;
    
    UIImageView *imageMap = ({
        UIImageView *imageview = [UIImageView new];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview;
    });
    [self addSubview:imageMap];
    [imageMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.bounds.size);
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
    }];
    [[SVANetworkResource sharedResource] loadImage:imageMap WithPath:imageName compeletionHandler:^{
        handler();
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
