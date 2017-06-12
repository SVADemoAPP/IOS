//
//  InheritialViewController.m
//  SVA
//
//  Created by 黄芹 on 16/2/23.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "InheritialViewController.h"

@interface InheritialViewController ()

@end

@implementation InheritialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    
    self.datasource = @[CustomLocalizedString(@"默认航向角", nil),
                        CustomLocalizedString(@"加速度灵敏度", nil),
                        CustomLocalizedString(@"默认步长", nil),
                        CustomLocalizedString(@"最快速度门限", nil),
                        CustomLocalizedString(@"平行误差权重", nil),
                        CustomLocalizedString(@"垂直误差权重", nil),
                        CustomLocalizedString(@"静止速度门限", nil),
                        CustomLocalizedString(@"静止门限次数", nil),
                        CustomLocalizedString(@"重定位误差门限", nil),
                        CustomLocalizedString(@"重定位门限次数", nil),
                        CustomLocalizedString(@"滤波窗长", nil)];
    [self setupUI];
}

- (void)setupUI {
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"%f",self.view.frame.size.width);
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 667);
    [self.view addSubview:scrollView];
   
    
    UITableView *table = ({
        UITableView *tableview = [UITableView new];
        tableview.rowHeight = 40;
        tableview.dataSource = self;
        tableview.delegate = self;
        tableview.layer.cornerRadius = 5.0;
        tableview.layer.borderColor = [UIColor blackColor].CGColor;
        tableview.layer.borderWidth = 1.0;
        tableview;
    });
    [scrollView addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView).with.offset(40);
        make.left.mas_equalTo(self.view).with.offset(20);
        make.right.mas_equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(440);

        
        
    }];
    
    UIButton *saveButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:CustomLocalizedString(@"保存设置", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor redColor];
        button;
    });
    [scrollView addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(table);
        make.right.mas_equalTo(table);
        make.top.mas_equalTo(table.mas_bottom).with.offset(60);
        make.height.mas_equalTo(40);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"inheritial";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UITextField *textfield = [UITextField new];
    if (((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"inherit"])) {
        NSNumber *number = ((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"inherit"])[indexPath.row];
        textfield.text = [NSString stringWithFormat:@"%@", number];
    }
    textfield.delegate = self;
    textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textfield.tag = 333+indexPath.row;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:textfield];
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(5);
        make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-5);
        make.right.equalTo(cell.mas_right).offset(-16);
        make.width.mas_equalTo(70);
    }];
    
    cell.textLabel.text = self.datasource[indexPath.row];
    
    return cell;
}

- (void)saveButton {
    NSMutableArray *value = [NSMutableArray array];
    for (NSInteger i = 0; i < self.datasource.count; i++) {
        UITextField *textfield = [self.view viewWithTag:333+i];
        [value addObject:textfield.text];
    }
    
    [ScaleStore defaultScale].inheritialParameters = value;
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"inherit"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
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
