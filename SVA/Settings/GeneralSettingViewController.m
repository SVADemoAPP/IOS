//
//  GeneralSettingViewController.m
//  SVA
//
//  Created by XuZongCheng on 15/12/24.
//  Copyright © 2015年 huawei. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CONFIGURATION_TAG) {
    PUSH_MESSAGE_TAG = 10000,
    ANIMATION_TAG,
    PRIVACY_TAG,
    MAP_SCALE_TAG,
    AUTO_SWITCH_FLOOR_TAG,
    FOLLOW_LOCATION_TAG,
    INS_TAG,
    PATH_FILTER_TAG,
//    PATH_ADJUST_TAG,
    VIP_TAG,
    MAIN_HEAD_TAG
};

#import "GeneralSettingViewController.h"
#import "SVAUnsubscribeViewModel.h"

#define ROW_HEIGHT 50

@interface GeneralSettingViewController ()
@end

@implementation GeneralSettingViewController

- (void)viewDidLoad {
    
    self.title = CustomLocalizedString(@"通用设置",nil);
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"AppLanguage"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"AppLanguage"];
    }
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.dataArray = @[CustomLocalizedString(@"接收推送",nil),
                       CustomLocalizedString(@"开/关动画",nil),
                       CustomLocalizedString(@"隐私授权", nil),
                       CustomLocalizedString(@"显示地图标尺",nil),
                       CustomLocalizedString(@"自动切换楼层",nil),
                       CustomLocalizedString(@"定位跟随",nil),
                       CustomLocalizedString(@"惯导辅助增强",nil),
                       CustomLocalizedString(@"路径滤波", nil),
//                       CustomLocalizedString(@"路径规划",nil),
                       CustomLocalizedString(@"VIP", nil),
                       CustomLocalizedString(@"主航向开关", nil)];
    
    self.keysArray = @[@"pushMessageKey",
                       @"animationKey",
                       @"privacyKey",
                       @"mapScaleKey",
                       @"switchFloorKey",
                       @"followLocationKey",
                       @"insKey",
                       @"pathFilterKey",
//                       @"pathAdjustKey",
                       @"VIPKey",
                       @"mainHeadKey"];
    
    UIScrollView * scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 667);
    [self.view addSubview:scrollView];
   
    self.genTableView = [[UITableView alloc]initWithFrame:CGRectMake(25, 60, SCREEN_SIZE.width - 50, 500) style:UITableViewStylePlain];
    self.genTableView.dataSource = self;
    self.genTableView.delegate =self;
    self.genTableView.rowHeight = 50;
    self.genTableView.layer.borderWidth = 1.0;
    self.genTableView.layer.cornerRadius = 5.0;
    
    self.genTableView.scrollEnabled =   NO;
    self.genTableView.separatorInset = UIEdgeInsetsZero;

    self.genTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [scrollView addSubview:self.genTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Add switch button to control functions
    UISwitch *switchButton = [UISwitch new];
    switchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:self.keysArray[indexPath.row]];
    switchButton.tag = indexPath.row + 10000;
    [switchButton addTarget:self action:@selector(isOn:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:switchButton];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).with.offset(14);
        make.right.mas_equalTo(cell.mas_right).with.offset(-16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];

    return cell;
}

-(void)isOn:(UISwitch*)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:self.keysArray[sender.tag - 10000]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (sender.tag == MAP_SCALE_TAG) {
        [SVAMapView sharedMap].scale.hidden = sender.on ? NO : YES;
        [SVAMapView sharedMap].scaleImage.hidden = sender.on ? NO : YES;
//        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"generalSetting10003"];
    } else if (sender.tag == PRIVACY_TAG) {
        NSUInteger placeid = ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"currentplaceid"]).integerValue;
        if (sender.on) {
            
        } else {
            [SVAUnsubscribeViewModel startUnsubscriptionWith:placeid];
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"generalSetting10002"];
        }
    } else if (sender.tag == INS_TAG) {
        
    } else if (sender.tag == ANIMATION_TAG) {
        if (sender.on == YES) {
            [[NSUserDefaults standardUserDefaults] setObject:@"is" forKey:@"ANIMATION_TAG"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"ANIMATION_TAG"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
