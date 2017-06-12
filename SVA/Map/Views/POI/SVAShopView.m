//
//  SVAShopView.m
//  SVA
//
//  Created by 君若见故 on 16/2/24.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAShopView.h"

@interface SVAShopView ()

@property (nonatomic, strong) NSMutableArray<CALayer *> *shopLayers;

@property (nonatomic, strong) NSMutableArray<NSValue *> *shopPoints;

@property (nonatomic, strong) CALayer *startLayer;
@property (nonatomic, strong) CALayer *endLayer;
@property (nonatomic, strong) CAShapeLayer *pathLayer;

@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) CGPoint realCurrentPoint;
@property (nonatomic, assign) CGPoint realStartPoint;
@property (nonatomic, assign) CGPoint realEndPoint;

@end

@implementation SVAShopView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.startLayer = [CALayer layer];
        self.endLayer = [CALayer layer];
        self.pathLayer = [CAShapeLayer layer];
        self.shopLayers = [NSMutableArray array];
        self.shopPoints = [NSMutableArray array];
        self.pushview = [SVAPushView new];
        self.pushview.delegate = self;
        self.layer.sublayerTransform = CATransform3DMakeScale(1 / [ScaleStore defaultScale].scale, 1 / [ScaleStore defaultScale].scale, 0);
    }
    return self;
}

- (void)getShopsWithMapModel:(SVAMapDataModel *)mapModel {
    self.mapModel = mapModel;
    self.shopViewModel = [SVAPOIViewModel new];
    self.shopViewModel.delegate = self;
    [self.shopViewModel getPOIsWithMapDataModel:mapModel];
}

- (void)getShopModels:(NSArray<SVAPOIModel *> *)shopModels {
    self.poiModels = shopModels;
    
    [self addShopLayer];
}

- (void)addShopLayer {
    for (SVAPOIModel *model in self.poiModels) {
        CGPoint shopPoint = [SVACoordinateConversion getPointWithXspot:model.xSpot Yspot:model.ySpot onMapMode:self.mapModel];
        [self wrapNewControl:model.info atPoint:shopPoint];
        [self.shopPoints addObject:[NSValue valueWithCGPoint:shopPoint]];
//        [self drawIcon:shopPoint AndText:model.info];
        
        if ([model.isVip isEqualToString:@"是"] && model.moviePath && [[NSUserDefaults standardUserDefaults] boolForKey:@"VIPKey"]) {
            // 弹框展示VIP用户
            [SVANetworkResource downloadVideoWithVideoName:model.moviePath completeHandler:^(NSURL *pathurl) {
//                [self addVIP:model videoPath:pathurl];
            }];
            [self addVIP:model videoPath:nil];
        }
    }
    [ScaleStore defaultScale].shoplayers = self.shopLayers;
    [ScaleStore defaultScale].shopPoints = self.shopPoints;
}

- (void)addVIP:(SVAPOIModel *)shopModel videoPath:(NSURL *)videoURL {
    
    UIView *backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        view.tag = 2222;
        view;
    });
    
    [KEY_WINDOW addSubview:backView];
    
    UIView *container = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:0.384 green:0.570 blue:0.446 alpha:1.000];
        view.layer.cornerRadius = 3.0;
        view.clipsToBounds = YES;
        view.layer.shadowOffset = CGSizeMake(3, 3);
        view.layer.shadowRadius = 2;
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        view.center = CGPointMake(SCREEN_SIZE.width / 2, SCREEN_SIZE.height / 2);
        view.bounds = CGRectMake(0, 0, SCREEN_SIZE.width * 0.8, SCREEN_SIZE.height * 0.7);
        view;
    });
    [backView addSubview:container];
    
    UIButton *closeButton = ({
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(closeVIPWindow:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"closeVIP_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"closeVIP_highlight"] forState:UIControlStateFocused];
        button;
    });
    [container addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(container.mas_right).with.offset(-5);
        make.top.mas_equalTo(container.mas_top).with.offset(5);
    }];
    
    self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(container.bounds), 200)];
    self.moviePlayer.delegate = self; //IMPORTANT!
    self.moviePlayer.shouldAutoplay = NO;
    
    // create the controls
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
    
    // optionally customize the controls here...
    
     [movieControls setBarColor:[UIColor colorWithRed:195/255.0 green:29/255.0 blue:29/255.0 alpha:0.5]];
     [movieControls setTimeRemainingDecrements:YES];
     [movieControls setFadeDelay:2.0];
     [movieControls setBarHeight:100.f];
     [movieControls setSeekRate:2.f];
     
    
    // assign the controls to the movie player
    [self.moviePlayer setControls:movieControls];
    
    [self.moviePlayer setContentURL:[NSURL URLWithString:@"http://ia800300.us.archive.org/8/items/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto-HawaiianHoliday1937-Video.mp4"]];
    
    // add movie player to your view
    [container addSubview:self.moviePlayer.view];
    
    
    UIImageView *picture = ({
        UIImageView *imageview = [UIImageView new];
        imageview.tag = 12345;
        imageview.userInteractionEnabled = YES;
        [[SVANetworkResource sharedResource] loadLogo:imageview WithPath:shopModel.pictruePath];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBiggerImage)];
        [imageview addGestureRecognizer:tapGesture];
        imageview;
    });
    [container addSubview:picture];
    [picture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container.mas_top).with.offset(260);
        make.left.mas_equalTo(container.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UITextView *messageView = ({
        UITextView *label = [UITextView new];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.editable = NO;
        label.text = shopModel.info;
        label;
    });
    [container addSubview:messageView];
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(picture.mas_right).with.offset(20);
        make.top.mas_equalTo(picture);
        make.right.mas_equalTo(container.mas_right).with.offset(-20);
        make.height.mas_equalTo(60);
    }];
}

-(void)showBiggerImage {
    
    UIImageView *image = (UIImageView *)[KEY_WINDOW viewWithTag:12345];
    [SJAvatarBrowser showImage:image];
}

- (void)closeVIPWindow:(UIButton *)sender {
    UIView *view = [KEY_WINDOW viewWithTag:2222];
    [view removeFromSuperview];
}

- (void)wrapNewControl:(NSString *)message atPoint:(CGPoint)point {
    
    CGRect stringRect = [message boundingRectWithSize:CGSizeMake(200, 30)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}
                                              context:nil];
    
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 8 + stringRect.size.width, 8);
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = point;
    [self.layer addSublayer:layer];
    
    // Add image flags
    UIImage *image = [UIImage imageNamed:@"shop_icon"];
    CALayer *imagelayer = [CALayer layer];
    imagelayer.frame = CGRectMake(0, 0, 8, 8);
    imagelayer.contents = (__bridge id _Nullable)(image.CGImage);
    imagelayer.contentsScale = [UIScreen mainScreen].scale;
    
    [layer addSublayer:imagelayer];
    
    [self.shopLayers addObject:imagelayer];
    
    
    // Add text layer to show message.
    CATextLayer *textlayer = [CATextLayer layer];
    textlayer.frame = CGRectMake(CGRectGetMaxX(imagelayer.frame), CGRectGetMinY(imagelayer.frame), stringRect.size.width, stringRect.size.height);
    textlayer.string = message;
    textlayer.fontSize = 8;
    textlayer.foregroundColor = [UIColor lightGrayColor].CGColor;
    textlayer.font = CFBridgingRetain([UIFont systemFontOfSize:8].fontName);
    textlayer.foregroundColor = [UIColor blackColor].CGColor;
    textlayer.alignmentMode = kCAAlignmentLeft;
    textlayer.contentsScale = [UIScreen mainScreen].scale;
    
    [layer addSublayer:textlayer];
}

- (void)removeShopLayer {
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

- (void)addStartLayer:(CGPoint)point {
    [self addPathFlags:point type:self.startLayer];
}

- (void)addEndLayer:(CGPoint)point {
    [self addPathFlags:point type:self.endLayer];
}

- (void)addPathFlags:(CGPoint)point type:(CALayer *)layer {
    if (CGPointEqualToPoint(point, self.currentPoint)) {
        [self.pathLayer removeFromSuperlayer];
//        return;
    }
    
    UIImage *image;
    if ([layer isEqual:self.endLayer]) {
        image = [UIImage imageNamed:@"end_eng"];
        self.realEndPoint = self.realCurrentPoint;
    } else {
        image = [UIImage imageNamed:@"start_eng"];
        self.realStartPoint = self.realCurrentPoint;
    }
    layer.contents = (__bridge id _Nullable)(image.CGImage);
    layer.bounds = CGRectMake(0, 0, 25, 34);
    layer.anchorPoint = CGPointMake(0.5, 1.0);
    layer.position = point;
    layer.zPosition = 10;
    layer.hidden = NO;
    layer.affineTransform = CGAffineTransformMakeScale(1 / [ScaleStore defaultScale].scale, 1 / [ScaleStore defaultScale].scale);
    layer.affineTransform = CGAffineTransformRotate(layer.affineTransform, -[ScaleStore defaultScale].rotation);
    self.currentPoint = point;
    [self.layer addSublayer:layer];
    
    BOOL hasStart = NO, hasEnd = NO;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isEqual:self.startLayer]) {
            hasStart = YES;
        } else if ([layer isEqual:self.endLayer]) {
            hasEnd = YES;
        }
    }
    
    if (hasStart && hasEnd && !CGPointEqualToPoint(self.startLayer.position, self.endLayer.position)) {
        [self addPathLayer];
    }
}

- (void)addPathLayer {
    
    [self.pathLayer removeFromSuperlayer];
    
    NSArray<NSValue *> *array = [SVAFindPath findPathWithStart:self.realStartPoint end:self.realEndPoint onModel:self.mapModel];
    
    //    NSMutableArray *array = [new findPathStartX:start.x
    //                                          statY:start.y
    //                                           endX:end.x
    //                                           endY:end.y
    //                                       filePath:self.mapDataModel.keyWord];
    
    if (!array || array.count == 0) {
#warning 无数据提示
        // 添加无路径规划文件提示
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startLayer.position];
    
    for (NSValue *pointValue in array) {
        CGPoint pathPoint = [SVACoordinateConversion getPathPointWithXspot:pointValue.CGPointValue.x / self.mapModel.scale.doubleValue Yspot:pointValue.CGPointValue.y / self.mapModel.scale.doubleValue onMapMode:self.mapModel];
        [path addLineToPoint:pathPoint];
    }
    [path addLineToPoint:self.endLayer.position];
    
    self.pathLayer = [CAShapeLayer layer];
    self.pathLayer.path = path.CGPath;
    self.pathLayer.lineJoin = kCALineJoinBevel;
    self.pathLayer.strokeColor = [UIColor greenColor].CGColor;
    self.pathLayer.fillColor = [UIColor clearColor].CGColor;
    self.pathLayer.zPosition = 9;
    [self.layer addSublayer:self.pathLayer];
}

- (void)changeScale:(CGFloat)scale Rotation:(CGFloat)rotation {
    
    for (CALayer *layer in self.layer.sublayers) {

        if ([layer isEqual:self.pathLayer]) {
            continue;
        }
        
        layer.affineTransform = CGAffineTransformIdentity;
        layer.affineTransform = CGAffineTransformMakeScale(1 / scale, 1 / scale);
        layer.affineTransform = CGAffineTransformRotate(layer.affineTransform, -rotation);
    }
}

- (void)resetAll {
    self.pathLayer.hidden = YES;
    self.startLayer.hidden = YES;
    self.endLayer.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.pushview removePopupView];
    
    for (NSValue *value in self.shopPoints) {
        CGPoint tempPoint = value.CGPointValue;
        if (!CGRectContainsPoint(CGRectMake(tempPoint.x - 5, tempPoint.y - 5, 10, 10), touchPoint)) {
            continue;
        }
        
        NSInteger index = [self.shopPoints indexOfObject:value];
        self.realCurrentPoint = [self getRealShopPointWithShopModel:self.poiModels[index]];
        
        [self.pushview addPopViewWithMessage:self.poiModels[index].info logoPath:self.poiModels[index].pictruePath point:value isShop:YES];
        break;
    }
}

#pragma mark - Set start and final.
- (void)setStart:(NSValue *)startValue End:(NSValue *)endValue {
    if (startValue) {
        [self addStartLayer:startValue.CGPointValue];
    } else if (endValue) {
        [self addEndLayer:endValue.CGPointValue];
    } else {
        // 清除路径
        [self.pathLayer removeFromSuperlayer];
        [self.startLayer removeFromSuperlayer];
        [self.endLayer removeFromSuperlayer];
    }
}

- (CGPoint)getRealShopPointWithShopModel:(SVAPOIModel *)shopModel {
    CGPoint realPoint;
    if ([self.mapModel.coordinate isEqualToString:@"ul"]) {
        realPoint = CGPointMake(shopModel.xSpot * self.mapModel.scale.doubleValue, shopModel.ySpot * self.mapModel.scale.doubleValue);
    }
    else if ([self.mapModel.coordinate isEqualToString:@"ll"]) {
        realPoint = CGPointMake(shopModel.xSpot * self.mapModel.scale.doubleValue, self.mapModel.imgHeight - shopModel.ySpot * self.mapModel.scale.doubleValue);
    }
    else if ([self.mapModel.coordinate isEqualToString:@"ur"]) {
        realPoint = CGPointMake(self.mapModel.imgWidth - shopModel.xSpot * self.mapModel.scale.doubleValue, shopModel.ySpot * self.mapModel.scale.doubleValue);
    }
    else {
        realPoint = CGPointMake(self.mapModel.imgWidth - shopModel.xSpot * self.mapModel.scale.doubleValue, self.mapModel.imgHeight - shopModel.ySpot * self.mapModel.scale.doubleValue);
    }
    return realPoint;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
