//
//  AdvancedViewController.m
//  SVA
//
//  Created by Zeacone on 16/1/26.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "AdvancedViewController.h"

@interface AdvancedViewController ()

@property (nonatomic, strong) NSArray *advancedArray;

@end

@implementation AdvancedViewController

- (NSArray *)advancedArray {
    if (!_advancedArray) {
        _advancedArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    }
    return _advancedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    for (NSInteger i = 0; i < 4; i++) {
        
        UIButton *buttonIdentifier = ({
            UIButton *button = [UIButton new];
            button;
        });
        [self.view addSubview:buttonIdentifier];
        [buttonIdentifier mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view.mas_width);
            make.width.mas_equalTo(SCREEN_SIZE.width / 4);
            make.height.mas_equalTo(100);
        }];
        
        UILabel *labelIdentifier = ({
            UILabel *label = [UILabel new];
            label;
        });
        [buttonIdentifier addSubview:buttonIdentifier];
        [labelIdentifier mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(buttonIdentifier);
            make.left.mas_equalTo(buttonIdentifier);
            make.right.mas_equalTo(buttonIdentifier);
            make.height.mas_equalTo(buttonIdentifier.mas_width);
        }];
        
        UIImageView *imageIdentifier = ({
            UIImageView *imageview = [UIImageView new];
            imageview.image = [UIImage imageNamed:self.advancedArray[i]];
            imageview;
        });
        [buttonIdentifier addSubview:imageIdentifier];
        [imageIdentifier mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view.mas_width);
            make.width.mas_equalTo(SCREEN_SIZE.width / 4);
            make.height.mas_equalTo(100);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
