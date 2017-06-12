//
//  InheritialViewController.h
//  SVA
//
//  Created by 黄芹 on 16/2/23.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleStore.h"

@interface InheritialViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *datasource;

@end
