//
//  SettingViewController.h
//  SVA
//
//  Created by Zeacone on 15/12/10.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InheritialViewController.h"

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView    *logoImageView;
@property (nonatomic, strong) UILabel        *appInfoLabel;
@property (nonatomic, strong) UITableView    *settingTableView;
@property (nonatomic, strong) UIButton       *saveButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel        *languageLabel;
@property (nonatomic, strong) UILabel        *postLabel;
@property (nonatomic, strong) NSArray        *array;

@end
