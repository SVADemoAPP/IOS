//
//  SVALaunchViewController.m
//  SVA
//
//  Created by 一样 on 16/2/17.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVALaunchViewController.h"
#import "SVAWelcomeViewController.h"
#import "ViewController.h"

static NSInteger AGREE_TAG = 888;
static NSInteger DISAGREE_TAG = 999;

@interface SVALaunchViewController ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation SVALaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pushMessageKey"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mapScaleKey"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"switchFloorKey"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pathFilterKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"insKey"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"followLocationKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"pathAdjustKey"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"VIPKey"];
}

-(void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.containerView = ({
        UIView *view = [UIView new];
        view.layer.cornerRadius = 10.0;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width * 3.0 / 4.0, SCREEN_SIZE.height * 3.0/4.0));
        make.center.mas_equalTo(self.view);
    }];
    
    UIButton *agreeButton = ({
        UIButton *button = [UIButton new];
        button.tag = AGREE_TAG;
        [button setTitle:@"Agree" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickResponse:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithRed:100 / 255.0 green:200 / 255.0 blue:240 / 255.0 alpha:1];
        button;
    });
    [self.containerView addSubview:agreeButton];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.containerView);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.containerView);
        make.right.mas_equalTo(self.containerView.mas_centerX);
    }];
    
    UIButton *disagreeButton = ({
        UIButton *button = [UIButton new];
        button.tag = DISAGREE_TAG;
        [button setTitle:@"Disagree" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickResponse:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithRed:100 / 255.0 green:200 / 255.0 blue:240 / 255.0 alpha:1];;
        button;
    });
    [self.containerView addSubview:disagreeButton];
    [disagreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.containerView);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.containerView.mas_centerX);
        make.right.mas_equalTo(self.containerView);
    }];
    
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"Privacy Statement";
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:100 / 255.0 green:200 / 255.0 blue:240 / 255.0 alpha:1];
        label;
    });
    [self.containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView);
        make.centerX.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.containerView);
        make.height.mas_equalTo(40);
    }];
    
    UIScrollView *scrollContent = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.contentSize = CGSizeMake(SCREEN_SIZE.width * 3.0/4.0, 1000);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView;
    });
    [self.view addSubview:scrollContent];
    [scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView);
        make.width.mas_equalTo(SCREEN_SIZE.width * 3.0/4.0);
        make.top.mas_equalTo(self.containerView.mas_top).with.offset(40);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).with.offset(-40);
    }];
    
    NSBundle *mainbundle =[NSBundle mainBundle];
    NSString *textPath = [mainbundle pathForResource:@"user_agreement" ofType:@"txt"];
    NSString *string = [[NSString alloc]initWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:nil];
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(SCREEN_SIZE.width * 3.0/4.0, 1000) lineBreakMode:NSLineBreakByWordWrapping];
//    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = string;
        label.numberOfLines = 0;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        label;
    });
    [scrollContent addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.top.mas_equalTo(scrollContent);
        make.left.mas_equalTo(scrollContent);
    }];
}

- (void)clickResponse:(UIButton *)button {
    
    if (button.tag == DISAGREE_TAG) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"privacyKey"];
        exit(0);
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"privacyKey"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [self presentViewController:[SVAWelcomeViewController new] animated:YES completion:nil];
    } else {
        ViewController *controller = [[ViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
        self.view.window.rootViewController = navigationController;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
