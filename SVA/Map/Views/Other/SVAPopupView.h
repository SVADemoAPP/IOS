//
//  SVAPopupView.h
//  SVA
//
//  Created by Zeacone on 15/12/9.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVAPopupView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UITableView *storeTableview;

+ (instancetype)sharedPopup;

@end
