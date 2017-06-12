//
//  LeadViewController.m
//  SVA
//
//  Created by XuZongCheng on 15/12/24.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVAWelcomeViewController.h"
#import "ViewController.h"

@interface SVAWelcomeViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation SVAWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)createView
{
    
    _scView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];

    _scView.backgroundColor= [UIColor whiteColor];
    _scView.contentSize = CGSizeMake(SCREEN_SIZE.width * 3, SCREEN_SIZE.height);
    _scView.pagingEnabled =YES;
    _scView.bounces =NO;
    

    [self.view addSubview:_scView];
    [self agree];
}

-(void)agree {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    self.containerView.hidden = YES;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width * i, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide%@", @(i + 1)] ofType:@"png"];
        imageview.image = [UIImage imageWithContentsOfFile:imagePath];
        [_scView addSubview:imageview];
        
        if (i == 2) {
            imageview.userInteractionEnabled = YES;
            UIButton *startButton = ({
                UIButton *button = [UIButton new];
                button.layer.cornerRadius = 2;
                button.backgroundColor = [UIColor colorWithRed:0.205 green:0.556 blue:0.463 alpha:1.000];
                [button addTarget:self action:@selector(gotonext) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"Start" forState:UIControlStateNormal];
                button;
            });
            [imageview addSubview:startButton];
            [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-50);
                make.left.mas_equalTo(40);
                make.right.mas_equalTo(-40);
                make.height.mas_equalTo(50);
            }];
        }
    }
}

- (void)disAgree {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everLaunched"];
    exit(0);
}

-(void)gotonext {
    ViewController * vc = [[ViewController alloc]init];
    UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
    self.view.window.rootViewController = nc;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
