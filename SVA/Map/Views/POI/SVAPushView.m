//
//  SVAPushView.m
//  SVA
//
//  Created by Zeacone on 16/3/10.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAPushView.h"

@implementation SVAPushView

- (void)addPopViewWithMessage:(NSString *)message logoPath:(NSString *)logoPath point:(NSValue *)point isShop:(BOOL)isShop {
    
    self.point = point;
    UIView *popupView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        view.backgroundColor = [UIColor colorWithRed:49/255.0 green:133/255.0 blue:255/255.0 alpha:1.0];
        view.tag = 1111;
        
        // Add pan gesture.
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
        panGesture.delegate = self;
        [view addGestureRecognizer:panGesture];
        
        // Add swipe gesture to show detail information.
        UISwipeGestureRecognizer *swipeShowGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToShowView:)];
        swipeShowGesture.delegate = self;
        swipeShowGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [view addGestureRecognizer:swipeShowGesture];
        
        UISwipeGestureRecognizer *swipeCloseGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToCloseView:)];
        swipeCloseGesture.delegate = self;
        swipeCloseGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [view addGestureRecognizer:swipeCloseGesture];
        
        view;
    });
    
    UIImageView *logo = ({
        UIImageView *imageview = [UIImageView new];
        [[SVANetworkResource sharedResource] loadLogo:imageview WithPath:logoPath];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview;
    });
    [popupView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_SIZE.height / 6);
        make.height.mas_equalTo(SCREEN_SIZE.height / 6);
        make.left.mas_equalTo(popupView);
        make.top.mas_equalTo(popupView);
    }];
    
    UITextView *messageLabel = ({
        UITextView *label = [UITextView new];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.editable = NO;
        label.text = message;
        label;
    });
    [popupView addSubview:messageLabel];
    //    CGRect stringRect = [message boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width * 5/6, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logo.mas_right);
        make.right.mas_equalTo(popupView);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(popupView).offset(0);
    }];
    
    CGFloat buttonWidth = (SCREEN_SIZE.width - SCREEN_SIZE.height / 6 - 45) / 2.0;
    
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height/6, SCREEN_SIZE.width, SCREEN_SIZE.height/3)];
    showView.backgroundColor = [UIColor whiteColor];
    [popupView addSubview:showView];
    
    
    UIImageView * showPicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.height/4, SCREEN_SIZE.height/4)];
    showPicture.contentMode = UIViewContentModeScaleAspectFill;
    showPicture.backgroundColor = [UIColor colorWithRed:34/255.0 green:104/255.0 blue:255/255.0 alpha:1];
    
    [[SVANetworkResource sharedResource] loadLogo:showPicture WithPath:logoPath];
    showPicture.center = showView.center;
    [popupView addSubview:showPicture];
    
    if (isShop) {
        UIButton *deleteButton = ({
            UIButton *button = [UIButton new];
            [button addTarget:self action:@selector(deletePath:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"deletepath"] forState:UIControlStateNormal];
            button;
        });
        [popupView addSubview:deleteButton];
        
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(logo.mas_bottom).with.offset(-10);
            make.right.equalTo(popupView).offset(-5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
        UIButton *from = ({
            UIButton *button = [UIButton new];
            //        button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:CustomLocalizedString(@"起点",nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"start_path"] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, buttonWidth - 20);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
            [button addTarget:self action:@selector(setStartLocation:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [popupView addSubview:from];
        [from mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(logo.mas_right).offset(5);
            make.bottom.mas_equalTo(logo.mas_bottom).with.offset(-10);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(30);
        }];
        
        UIButton *to = ({
            UIButton *button = [UIButton new];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:CustomLocalizedString(@"终点",nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"end_path"] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, buttonWidth - 20);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
            [button addTarget:self action:@selector(setEndLocation:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [popupView addSubview:to];
        [to mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(deleteButton.mas_left).with.offset(-5);
            make.bottom.mas_equalTo(logo.mas_bottom).with.offset(-10);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(30);
        }];
    }
    
    [KEY_WINDOW addSubview:popupView];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         popupView.transform = CGAffineTransformMakeTranslation(0, -SCREEN_SIZE.height / 6);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)removePopupView {
    UIView *view = [KEY_WINDOW viewWithTag:1111];
    [UIView animateWithDuration:.5
                          delay:.0
         usingSpringWithDamping:.4
          initialSpringVelocity:.0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            view.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                            [view removeFromSuperview];
                        }];
}

- (void)dragView:(UIPanGestureRecognizer *)pan {
    
}

- (void)swipeToShowView:(UISwipeGestureRecognizer *)show {
    
    [UIView animateWithDuration:.5
                          delay:.0
         usingSpringWithDamping:.4
          initialSpringVelocity:.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         show.view.transform = CGAffineTransformMakeTranslation(0, -SCREEN_SIZE.height / 2);
                         
                     }completion:^(BOOL finished) {
                     }];
}

- (void)swipeToCloseView:(UISwipeGestureRecognizer *)close {
    [UIView animateWithDuration:.5
                          delay:.0
         usingSpringWithDamping:.4
          initialSpringVelocity:.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         close.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                         [close.view removeFromSuperview];
                     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setStartLocation:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setStart:End:)]) {
        [self.delegate setStart:self.point End:nil];
    }
}

- (void)setEndLocation:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setStart:End:)]) {
        [self.delegate setStart:nil End:self.point];
    }
}

-(void)deletePath:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setStart:End:)]) {
        [self.delegate setStart:nil End:nil];
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
