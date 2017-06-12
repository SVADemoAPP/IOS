//
//  SVAPushView.h
//  SVA
//
//  Created by Zeacone on 16/3/10.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SVAPushViewDelegate <NSObject>

- (void)setStart:(NSValue *)startValue End:(NSValue *)endValue;

@end

@interface SVAPushView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<SVAPushViewDelegate> delegate;
@property (nonatomic, strong) NSValue *point;

- (void)addPopViewWithMessage:(NSString *)message logoPath:(NSString *)logoPath point:(NSValue *)point isShop:(BOOL)isShop;

- (void)removePopupView;

@end
