//
//  SVAPopupView.m
//  SVA
//
//  Created by Zeacone on 15/12/9.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVAPopupView.h"
#import "SVALaunchViewController.h"

@implementation SVAPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 5.0;
        self.clipsToBounds = YES;
        [self configure];
    }
    return self;
}

+ (instancetype)sharedPopup {
    static SVAPopupView *popup = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popup = [[SVAPopupView alloc] initWithFrame:CGRectMake(10, 60, 150, 250)];
    });
    return popup;
}

- (NSArray *)places {
    if (!_places) {
        _places = [NSArray array];
    }
    _places = [SVAMapDataViewModel sharedMapViewModel].places;
    return _places;
}

- (void)configure {
     self.storeTableview = ({
        UITableView *tableview = [UITableView new];
        tableview.tag = 11;
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview;
    });
    [self addSubview:self.storeTableview];
    [self.storeTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.places[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    [UIView animateWithDuration:.5
                          delay:0.0
         usingSpringWithDamping:.6
          initialSpringVelocity:.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
       
        
    }];
    
       if ([[NSUserDefaults standardUserDefaults] objectForKey:@"title"]!=self.places[indexPath.row]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMap" object:self.places[indexPath.row] userInfo:@{@"placeid": [SVAMapDataViewModel sharedMapViewModel].placeIDs[indexPath.row]}];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
