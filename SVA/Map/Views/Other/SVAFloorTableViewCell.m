//
//  SVAFloorTableViewCell.m
//  SVA
//
//  Created by Zeacone on 15/12/15.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "SVAFloorTableViewCell.h"

@implementation SVAFloorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, 40, 40);
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.floorLabel = ({
            UILabel *label =[UILabel new];
            label.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame) - 10, CGRectGetWidth(self.frame) - 10);
            label.center = self.center;
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        [self addSubview:self.floorLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.floorLabel.backgroundColor = colorFromRGB(41, 108, 254, 1);
        self.floorLabel.textColor = [UIColor whiteColor];
        self.floorLabel.layer.cornerRadius = (CGRectGetWidth(self.frame) - 10) / 2.0;
        self.floorLabel.clipsToBounds = YES;
    } else {
        self.floorLabel.backgroundColor = [UIColor clearColor];
        self.floorLabel.textColor = [UIColor blackColor];
    }
}

@end
