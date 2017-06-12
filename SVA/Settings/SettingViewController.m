//
//  SettingViewController.m
//  SVA
//
//  Created by Zeacone on 15/12/10.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SettingViewController.h"
#import "GeneralSettingViewController.h"
#import "ViewController.h"
#import "SVAMapView.h"

#define ROW_HEIGHT 50

@interface SettingViewController ()
{
    UITextField * textfield;
    UIAlertController * alert;
    UITextField * login;
    UITextField * password;
   
 }
@property (nonatomic, strong) UIView * dissView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITapGestureRecognizer * dissViewTap;
@end

@implementation SettingViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[SVALocationViewModel sharedLocateViewModel] startRunloop];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[SVALocationViewModel sharedLocateViewModel] stopLocating];
    
}

- (void)viewDidLoad {
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"AppLanguage"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"AppLanguage"];
    }

  
    [super viewDidLoad];
   
    
    [self loadSettingView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = CustomLocalizedString(@"设置",nil);
 }
- (void)loadSettingView {
    
   self.array  = @[CustomLocalizedString(@"通用设置",nil),
                   CustomLocalizedString(@"服务地址",nil),
                   CustomLocalizedString(@"语言选择",nil),
                   CustomLocalizedString(@"高级设置",nil),
                   CustomLocalizedString(@"惯导参数配置", nil),
                   CustomLocalizedString(@"检查更新",nil)];
    
    _dataArray =  [NSMutableArray arrayWithArray:self.array];
 
    UIScrollView * sc =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sc.contentSize = CGSizeMake(self.view.frame.size.width, 720);
    [self.view addSubview:sc];
    self.logoImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"logo"];
        imageView.layer.cornerRadius = 3.0;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [sc addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(sc.mas_centerX);
        make.width.and.height.mas_equalTo(100);
    }];
    
    self.appInfoLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"Indoor Navigation V1.3T_B21";
        label.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [sc addSubview:self.appInfoLabel];
    [self.appInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    self.settingTableView = ({
        UITableView *tableview = [UITableView new];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.layer.borderColor = [UIColor grayColor].CGColor;
        tableview.layer.borderWidth = 1.0;
        tableview.layer.cornerRadius = 3.0;
       
        tableview.separatorInset = UIEdgeInsetsZero;
        tableview.rowHeight = ROW_HEIGHT;
        tableview;
    });
    [sc addSubview:self.settingTableView];
    
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.appInfoLabel.mas_bottom).with.offset(10);
        make.leftMargin.mas_equalTo(self.view).with.offset(20);
        make.rightMargin.mas_equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(ROW_HEIGHT * 6);
    }];
    
    self.saveButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:CustomLocalizedString(@"保存设置",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(saveSetting) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.backgroundColor = [UIColor redColor];
        button;
    });
    [sc addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.settingTableView.mas_bottom).with.offset(20);
        make.leftMargin.mas_equalTo(self.view).with.offset(40);
        make.rightMargin.mas_equalTo(self.view).with.offset(-40);
        make.height.mas_equalTo(50);
    }];
}

/**
 *  保存语言配置
 */
- (void)saveLanguageConfiguration {
    if ([_languageLabel.text isEqualToString:@"简体中文"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"zh-Hans" forKey:@"AppLanguage"];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@"en" forKey:@"AppLanguage"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)checkIPAddressFormat {
    NSString *originString = textfield.text;
    if (!originString || originString.length == 0) {
        
    }
}

- (void)showAlertMessage:(NSString *)message {
    [self addView];
    _dissView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(_saveButton.mas_top).offset(-55);
        make.centerX.mas_equalTo(_dissView);
    }];
    self.containerView.backgroundColor = [UIColor grayColor];
    self.containerView.layer.cornerRadius = 10;
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.textColor = [UIColor whiteColor];
    ;
    if ([textfield.text isEqualToString:@""]) {
        label.text = CustomLocalizedString(@"服务器地址为空!",nil);
    }else{
        label.text = CustomLocalizedString(@"格式错误(ip:port)",nil);
    }
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines =0;
    label.layer.cornerRadius = 10;
    [self.containerView addSubview:label];
}

-(void)saveSetting {
    // 1. 保存语言配置
    [self saveLanguageConfiguration];
    
    // 2. 检测IP地址合法性
//    [self checkIPAddressFormat];
    
    NSString *string1 = textfield.text;
    NSString *string2 =@":";
    
    if ([string1 rangeOfString:string2].location !=NSNotFound) {
        
        NSArray * array = [textfield.text componentsSeparatedByString:@":"];
       
        if (array.count ==2) {
        
            NSString * string3 = [NSString stringWithFormat:@"%@",array[0]];
        
            NSString * string4 = [NSString stringWithFormat:@"%@",array[1]];
        
            NSString * stringip = @"(^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(00?\\d|1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(00?\\d|1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(00?\\d|1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$)";
            NSPredicate * ip =[NSPredicate predicateWithFormat:@"SELF MATCHES%@",stringip];
       
            NSString * Stringport = @"/^[1-9]$|(^[1-9][0-9]$)|(^[1-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9]$)|(^[1-6][0-5][0-5][0-3][0-5]$)/";
            NSPredicate * port = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",Stringport];
            
            if ([ip evaluateWithObject:string3] &&[port evaluateWithObject:string4]) {
           
                [self.navigationController popViewControllerAnimated:YES];
                NSString *address = [@"http://" stringByAppendingString:textfield.text];
                if (![address isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SERVER_IP_KEY]]) {
                    [[NSUserDefaults standardUserDefaults]setObject:address forKey:SERVER_IP_KEY];
                    [[SVAMapView sharedMap] loadAllNeed];
                }
            }else{
                [self addView];
                _dissView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(200);
                    make.height.mas_equalTo(40);
                    make.bottom.mas_equalTo(_saveButton.mas_top).offset(-55);
                    make.centerX.mas_equalTo(_dissView);
                }];
                self.containerView.backgroundColor = [UIColor grayColor];
                self.containerView.layer.cornerRadius = 10;
                self.containerView.alpha = 1;
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
                label.textColor = [UIColor whiteColor];
               ;
                if ([textfield.text isEqualToString:@""]) {
                    label.text = CustomLocalizedString(@"服务器地址为空!",nil);
                }else{
                    label.text = CustomLocalizedString(@"格式错误(ip:port)",nil);
                }
                label.font = [UIFont systemFontOfSize:15];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.numberOfLines =0;
                label.layer.cornerRadius = 10;
                [self.containerView addSubview:label];

            
            }
        
        }else{
            [self addView];
            _dissView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(200);
                make.height.mas_equalTo(40);
                make.bottom.mas_equalTo(_saveButton.mas_top).offset(-55);
                make.centerX.mas_equalTo(_dissView);
            }];
            self.containerView.backgroundColor = [UIColor grayColor];
            self.containerView.layer.cornerRadius = 10;
            self.containerView.alpha = 1;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
            label.textColor = [UIColor whiteColor];
          
            if ([textfield.text isEqualToString:@""]) {
                label.text = CustomLocalizedString(@"服务器地址为空!",nil);
            } else {
                label.text = CustomLocalizedString(@"格式错误(ip:port)",nil);
            }
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines =0;
            label.layer.cornerRadius = 10;
            [self.containerView addSubview:label];
        }
    }else{
         [self addView];
        _dissView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(_saveButton.mas_top).offset(-55);
            make.centerX.mas_equalTo(_dissView);
        }];
        self.containerView.backgroundColor = [UIColor grayColor];
        self.containerView.layer.cornerRadius = 10;
        self.containerView.alpha = 1;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        label.textColor = [UIColor whiteColor];
        
        if ([textfield.text isEqualToString:@""]) {
            label.text = CustomLocalizedString(@"服务器地址为空!",nil);
        }else{
        label.text = CustomLocalizedString(@"格式错误(ip:port)",nil);
        }
            label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.numberOfLines =0;
        label.layer.cornerRadius = 10;
        [self.containerView addSubview:label];
    }
    [self performSelector:@selector(hideSettingView) withObject:nil afterDelay:1.0f];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    if ((indexPath.row == 0) || (indexPath.row == 3)){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 1) {
        
        textfield = [SettingViewController initwithtitle:BASE_IP];
        textfield.delegate = self;
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.clearButtonMode = UITextFieldViewModeUnlessEditing;
        textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
       // textfield.secureTextEntry = YES;
        [cell addSubview:textfield];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(5);
            make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-5);
            make.right.equalTo(cell.mas_right).offset(-16);
            make.width.mas_equalTo(150);
        }];
    }
    if (indexPath.row ==2) {
        _languageLabel = [[UILabel alloc]init];
        _languageLabel.text = CustomLocalizedString(@"简体中文",nil);
        _languageLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_languageLabel];
        [_languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.right.equalTo(cell.mas_right).offset(-16);
            make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-10);
            make.width.mas_equalTo(80);
        }];
    }

    if (indexPath.row ==4) {
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row ==5) {
        
        UILabel * editionlabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 120, 30)];
        editionlabel.text = CustomLocalizedString(@"已是最新版本",nil);
        editionlabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:editionlabel];
        [editionlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(14);
            make.right.equalTo(cell.mas_right).offset(-16);
        }];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


+ (UITextField*)initwithtitle:(NSString*)title
{
    UITextField * textField = [[UITextField alloc]init];
    textField.adjustsFontSizeToFitWidth = YES;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * str = [defaults objectForKey:@"SERVER_IP"];
    textField.text = str.length == 0 ? @"61.91.240.238:8082" : [str substringFromIndex:7];
    
    return textField;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textfield endEditing:YES];
    [textfield resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _settingTableView.userInteractionEnabled = NO;
    


    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _settingTableView.userInteractionEnabled = YES;


    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0) {
        
        GeneralSettingViewController * generVC = [[GeneralSettingViewController alloc]init];
        
        [self.navigationController pushViewController:generVC animated:YES];
        
    }
    if (indexPath.row == 2) {
        [self addView];
        self.containerView.frame = CGRectMake(50, (SCREEN_SIZE.height - 100) / 2, SCREEN_SIZE.width - 100, 100);
        self.containerView.backgroundColor = [UIColor grayColor];
        self.containerView.layer.cornerRadius  = 5;
        self.containerView.layer.masksToBounds = YES;
        NSArray * array = @[@"简体中文",@"English"];
    
        for (int i = 0; i < 2; i++) {
            UIButton *languageBt = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 50, SCREEN_SIZE.width - 100, 50)];
            [languageBt setTitle:array[i] forState:UIControlStateNormal];
            [languageBt addTarget:self action:@selector(languageChoose:) forControlEvents:UIControlEventTouchUpInside];
            languageBt.backgroundColor = [UIColor whiteColor];
            [languageBt setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [self.containerView addSubview:languageBt];
        }
     }
    if (indexPath.row ==3) {
        alert  = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"口令验证",nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        NSString * str = CustomLocalizedString(@"用户名",nil);;
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder=str;
            textField.keyboardType = UIKeyboardTypeAlphabet;
         }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            NSString * str1 =CustomLocalizedString(@"密码",nil);
            textField.placeholder=str1;
             textField.secureTextEntry = YES;
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        }];

        UIAlertAction * okAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            // TODO 验证口令正确性
            
            password = alert.textFields.lastObject;
            
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
        if (indexPath.row == 4) {
            [self.navigationController pushViewController:[InheritialViewController new] animated:YES];
        }
    
    if (indexPath.row ==1) {
        
    }
}

-(void)languageChoose:(UIButton*)button {
    _languageLabel.text = button.titleLabel.text;
    [self hideSettingView];
}

-(void)addView
{
    
    _dissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    
    _dissView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    _dissViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDissViewTap:)];
    [_dissView addGestureRecognizer:_dissViewTap];
    
    [KEY_WINDOW addSubview:_dissView];
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.hidden = NO;
    [_dissView addSubview:self.containerView];
}


#pragma mark 隐藏覆盖层 hideView
-(void)hideSettingView {
    _dissView.hidden = YES;
    self.containerView.hidden = YES;
}

#pragma mark  手势取消覆盖层 onDissViewTap:(UITapGestureRecognizer *) gesture
- (void)onDissViewTap:(UITapGestureRecognizer *) gesture
{
    [gesture.view removeFromSuperview];
}

@end
