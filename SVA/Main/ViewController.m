//
//  ViewController.m
//  SVA
//
//  Created by Zeacone on 15/12/8.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "ViewController.h"
#import "SettingViewController.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/types.h>
#import "SVAPopupView.h"
#import "MMAlertView.h"
#import "MBProgressHUD.h"


#import "SVAPathParser.h"
#import "SVADijkstra.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"AppLanguage"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"AppLanguage"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
#pragma mark -- 切换ip
    [[NSUserDefaults standardUserDefaults] setObject:@"192.168.10.107" forKey:@"IP"];
//    [[NSUserDefaults standardUserDefaults] setObject:[self getIPAddress] forKey:@"IP"];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.removeFromSuperViewOnHide = YES;
            hud.labelText = CustomLocalizedString(@"检测到网络已断开,请检查网络",nil);
            [hud hide:YES afterDelay:3];
        } else {
            if (self.mapView) {
                [self.mapView loadAllNeed];
            }
        }
    }];
    // 启动监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [self mainConfiguration];
    [self loadMainView];
    
    @weakify(self);
    [self.mapView setGetMarketTitleHandler:^(NSString *place) {
        @strongify(self);
        self.navigationItem.title = place;
        NSUserDefaults * userdfa = [NSUserDefaults standardUserDefaults];
        [userdfa setObject:place forKey:@"title"];
    }];
}

// Setting current viewcontroller's status bar style.
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)mainConfiguration {
    self.navigationItem.title = @"SVA";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"market_icon"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(showPopover:)];
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_icon"]
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(showSettings:)];
    self.navigationItem.rightBarButtonItems = @[settingButton];
}

- (void)showPopover:(UIBarButtonItem *)buttonItem {
    
    SVAPopupView *pop = [SVAPopupView sharedPopup];
    [UIView animateWithDuration:.5
                          delay:.0
         usingSpringWithDamping:.6
          initialSpringVelocity:.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
             
             UIControl *tap = [[UIControl alloc] initWithFrame:KEY_WINDOW.frame];
             [tap addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
             [KEY_WINDOW addSubview:tap];
                         [tap addSubview:pop];
             pop.alpha = 1.0;
    } completion:nil];
}

- (void)tap:(UIControl *)tap {
    
    [tap removeFromSuperview];
}

- (void)showSettings:(UIBarButtonItem *)buttonItem {
    
    [[SVALocationViewModel sharedLocateViewModel] stopLocating];
    
    for (UIView *subview in KEY_WINDOW.subviews) {
        if (subview.tag == 1111) {
            [subview removeFromSuperview];
        }
    }
    SettingViewController *settingController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)loadMainView {
    self.mapView = [SVAMapView sharedMap];
    self.mapView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
    [self.view addSubview:self.mapView];
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is pdp_ip0 which is the 3/4G connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
