//
//  GeneralSettingViewController.h
//  SVA
//
//  Created by XuZongCheng on 15/12/24.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralSettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * genTableView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSArray<NSString *> *keysArray;

@end
