//
//  SVAMapView.m
//  SVA
//
//  Created by Zeacone on 15/12/10.
//  Copyright © 2015年 huawei. All rights reserved.
//

#define KCONTENTSIZE CGSizeMake([UIScreen mainScreen].bounds.size.width*1.7, [UIScreen mainScreen].bounds.size.height*1.5)
//放大系数
#define kscael 1.1
//缩小系数
#define kscael2 0.9
//初始化大小
#define kinitscale 1

#import "SVAMapView.h"
#import "SVALaunchViewController.h"


static NSString *identifier = @"identifier";
static NSInteger AGREE_TAG = 888;
static NSInteger DISAGREE_TAG = 999;

@interface SVAMapView ()

@property (nonatomic, strong) UIView * bgView;

//@property (nonatomic, assign) BOOL  isButtonEnter;

@end
@implementation SVAMapView

+ (instancetype)sharedMap {
    static SVAMapView *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = [[SVAMapView alloc] init];
//        [map loadAllNeed];
        map.scaleStore = [ScaleStore defaultScale];
    });
    return map;
}

- (void)locationPoint:(NSDictionary *)locationPoint
{
    NSString *tempStr = [locationPoint valueForKey:@"userInfo"][@"new"];
    NSString *str = [NSString stringWithFormat:@"%@",tempStr];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"{},"];
    NSArray *tempArr = [str componentsSeparatedByCharactersInSet:set];
    CGFloat x = [tempArr[1] floatValue];
    CGFloat y = [tempArr[2] floatValue];
    
    //校正视图位置，使之一直保持在屏幕中间
//    self.mapView.center = CGPointMake(x * self.lastScale, y * self.lastScale);
//    self.contentScrollView.center = CGPointMake(x * self.lastScale, y * self.lastScale);
    
    //初始化地图即进行缩放
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.oldCenter = CGPointMake(size.width/2, (size.height-64)/2);
//    self.mapView.transform = CGAffineTransformScale(self.mapView.transform, kinitscale, kinitscale);
//    self.lastScale = self.lastScale * kinitscale;
    [UIView animateWithDuration:0.25f animations:^{
        //校正视图位置，使之一直保持在屏幕中间
        //    self.mapView.center = CGPointMake(x * kinitscale, y *kinitscale);
//        self.contentScrollView.contentOffset = CGPointMake(x + x * (self.lastScale - 1) * (self.lastScale - 1) * (self.lastScale - 1) / self.lastScale - self.oldCenter.x, y - self.oldCenter.y + y * (self.lastScale - 1) * (self.lastScale - 1) * (self.lastScale - 1) / self.lastScale);
        self.contentScrollView.contentOffset = CGPointMake(x * self.scaleStore.scale - self.oldCenter.x, y * self.scaleStore.scale - self.oldCenter.y);
        //动态改变容器大小
//        self.contentScrollView.contentSize = CGSizeMake(KCONTENTSIZE.width + self.contentScrollView.contentOffset.x,KCONTENTSIZE.height + self.contentScrollView.contentOffset.y);
//        self.scaleStore.scale = self.lastScale;
    }];
//    NSLog(@"---2=%f",self.self.lastScale);
    NSLog(@"---%f",self.scaleStore.scale);
}

- (NSMutableArray *)floors {
    if (!_floors) {
        _floors = [NSMutableArray array];
//        _floors = [[SVAMapDataViewModel sharedMapViewModel] getFloorsByPlace:1];
    }
    return _floors;
}

/**
 *
 *  Load map view and components and start getting network data.
 *
 *  @return No return value.
 */
- (void)loadAllNeed {
    self.lastScale = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadMap:)
                                                 name:@"loadMap"
                                               object:nil];
    self.backgroundColor = [UIColor whiteColor];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadMapView];
        [self loadMapAndComponents];
    });
    
    @weakify(self);
    [[SVAMapDataViewModel sharedMapViewModel] getMapInfo];
    [[SVAMapDataViewModel sharedMapViewModel] setCompleteHandler:^{
        @strongify(self);
        // Get market name.
        NSString *place = [[SVAMapDataViewModel sharedMapViewModel].places firstObject];
        NSUInteger placeid = ((NSNumber *)[[SVAMapDataViewModel sharedMapViewModel].placeIDs firstObject]).integerValue;
        [self reloadMapWithPlace:place andPlaceID:placeid];
        
        [[SVAPopupView sharedPopup].storeTableview reloadData];
    }];
}

/**
 *
 *  Change market.
 *
 *  @return No return values.
 */
- (void)loadMap:(NSNotification *)noti {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"privacyKey"]) {
        //添加定位授权
        [self authorization];
    }
    [[SVALocationViewModel sharedLocateViewModel] stopLocating];
    self.locate.selected = NO;
    self.lastScale = 1;
    self.scaleStore.scale = self.lastScale;
    NSString *place = (NSString *)[noti object];
    NSUInteger placeid = ((NSNumber *)[noti userInfo][@"placeid"]).integerValue;
    [self reloadMapWithPlace:place andPlaceID:placeid];
    self.getMarketTitleHandler(place);
}

//定位授权
-(void)authorization
{
    self.bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    [self addSubview:self.bgView];
    
    UIView * containerView = [[UIView alloc]init];
    
    containerView = ({
        UIView *view = [UIView new];
        view.layer.cornerRadius = 10.0;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.bgView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width * 3.0/4.0, SCREEN_SIZE.height * 3.0/4.0));
        make.center.mas_equalTo(self);
    }];
    
    UIButton *agreeButton = ({
        UIButton *button = [UIButton new];
        button.tag = AGREE_TAG;
        [button setTitle:@"Agree" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickResponse:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithRed:100 / 255.0 green:200 / 255.0 blue:240 / 255.0 alpha:1];
        button;
    });
    [containerView addSubview:agreeButton];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(containerView);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(containerView);
        make.right.mas_equalTo(containerView.mas_centerX);
    }];
    
    UIButton *disagreeButton = ({
        UIButton *button = [UIButton new];
        button.tag = DISAGREE_TAG;
        [button setTitle:@"Disagree" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickResponse:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithRed:100 / 255.0 green:200 / 255.0 blue:240 / 255.0 alpha:1];;
        button;
    });
    [containerView addSubview:disagreeButton];
    [disagreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(containerView);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(containerView.mas_centerX);
        make.right.mas_equalTo(containerView);
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
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView);
        make.centerX.mas_equalTo(containerView);
        make.width.mas_equalTo(containerView);
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
    [self.bgView addSubview:scrollContent];
    [scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView);
        make.width.mas_equalTo(SCREEN_SIZE.width * 3.0/4.0);
        make.top.mas_equalTo(containerView.mas_top).with.offset(40);
        make.bottom.mas_equalTo(containerView.mas_bottom).with.offset(-40);
    }];
    
    NSBundle *mainbundle =[NSBundle mainBundle];
    NSString *textPath = [mainbundle pathForResource:@"user_agreement" ofType:@"txt"];
    NSString *string = [[NSString alloc]initWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:nil];
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
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
    
    [self.bgView removeFromSuperview];
    
    if (button.tag == DISAGREE_TAG) {
        return;
    }
    
   // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"privacyKey"];
}

/**
 *
 *  当初次进入 app 以及选择切换商场之后，重新加载地图以及 POI 点
 *
 *  @return No return value.
*/
- (void)reloadMapWithPlace:(NSString *)place andPlaceID:(NSUInteger)placeid {
    
    //切换商场后，把容器scrollView偏移初始化，保证切换后新视图在当前屏幕中央可见
    self.contentScrollView.contentOffset = CGPointMake(0, 0);
    // Resubscription when place changes.
    [[SVAMapDataViewModel sharedMapViewModel] startSubscriptionWith:placeid];
    // This notify reminds UINavigationController to change its title to current place.
    self.getMarketTitleHandler(place);
    // Get floors by market's name.
    self.floors = [[SVAMapDataViewModel sharedMapViewModel] getFloorsByPlace:place];
    // Load map of first floors, it may be a svg, png or jpg.
    [self.mapView loadMapWithMapModel:(SVAMapDataModel *)[self.floors firstObject]];
    self.mapModel = (SVAMapDataModel *)[self.floors firstObject];
    // Reset floor selection.
    [self.floorSelection reloadData];
    // Reset scale to 1.0
    [self modifyScaleWithOriginScale:1.0];
    // Get information of all pois.
    [[SVAPOIViewModel sharedPOIViewModel] getPOIsWithMapDataModel:(SVAMapDataModel *)[self.floors firstObject]];
    [self.locView removeLocationPoint];
    [self.locView removePoint];
    [self addShopView];
    [self.shopView getShopsWithMapModel:(SVAMapDataModel *)[self.floors firstObject]];
    // Add POI
    // Select first floor.
    if (self.floors.count != 0) {
        [self.floorSelection selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    self.mapView.transform =  CGAffineTransformIdentity;
//    [self changeBig:kinitscale];
}

// 是地图显示为scl倍大小
- (void)changeBig:(CGFloat)scl {

    //初始化地图即进行缩放
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.oldCenter = CGPointMake(size.width/2, (size.height-64)/2);
    self.mapView.transform = CGAffineTransformScale(self.mapView.transform, scl, scl);
    self.locView.frame = self.mapView.frame;
    self.lastScale = self.lastScale * scl;
    //校正视图位置，使之一直保持在屏幕中间
    self.mapView.center = CGPointMake(self.mapView.center.x*scl, self.mapView.center.y*scl);
    self.contentScrollView.contentOffset = CGPointMake(self.mapView.center.x-self.oldCenter.x, self.mapView.center.y-self.oldCenter.y);
    //动态改变容器大小
    self.contentScrollView.contentSize = CGSizeMake(KCONTENTSIZE.width+self.contentScrollView.contentOffset.x,KCONTENTSIZE.height+self.contentScrollView.contentOffset.y);
    self.scaleStore.scale = self.lastScale;
}

- (void)loadMapView {

    //添加旋转手势
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateScroll:)];
    rotate.delegate = self;
    [self addGestureRecognizer:rotate];
//    添加缩放手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandle:)];
    pinch.delegate = self;
    [self addGestureRecognizer:pinch];
    
    self.contentScrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [UIColor whiteColor];
       CGSize size = [UIScreen mainScreen].bounds.size;
        //设置初始容器大小，可变区域较小
        scrollView.contentSize = CGSizeMake(size.width*1.5,size.height*1.2);
        scrollView.delegate = self;
        scrollView.bouncesZoom = NO;
        scrollView.bounces = NO;
        scrollView.contentMode = UIViewContentModeCenter;
        [scrollView zoomToRect:self.frame animated:YES];
        scrollView;
    });
    [self addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    self.mapView = ({
        SVAMap *map = [SVAMap new];
        map.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
        map;
    });
    [self.contentScrollView addSubview:self.mapView];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    self.lastRotation = atan2(self.mapView.transform.b, self.mapView.transform.a);

    return YES;
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

/**
 *  加载最基本的地图组件
 */
- (void)loadMapAndComponents {
    
    /**
     *  楼层的显示以及选择。
     *  通过上下两个按钮分别选择上一层楼和下一层楼，楼层的显示由 UITableView 的单个 cell
     *  来显示，数据源需要设置为逆序。
     *
     */
    // 楼层显示以及选择视图
    self.floorView = ({
        UIImageView *view = [UIImageView new];
        view.backgroundColor = [UIColor whiteColor];
        view.image = [UIImage imageNamed:@"floor_background"];
        view.layer.cornerRadius = 3.0f;
        view.clipsToBounds = YES;
        view;
    });
    [self addSubview:self.floorView];
    [self.floorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 130));
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
    }];
    
  //   楼层选择的表视图
    self.floorSelection = ({
        UITableView *tableview = [UITableView new];
        [tableview registerClass:[SVAFloorTableViewCell class] forCellReuseIdentifier:identifier];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = [UIColor clearColor];
        tableview.backgroundView = nil;
        tableview.opaque = NO;
        tableview.separatorStyle = UITableViewCellSelectionStyleNone;
        tableview.separatorInset = UIEdgeInsetsZero;
        tableview.rowHeight = 40;
        tableview;
    });
    [self addSubview:self.floorSelection];
    [self.floorSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.floorView.mas_top).with.offset(25);
        make.left.mas_equalTo(self.floorView);
        make.right.mas_equalTo(self.floorView);
        make.bottom.mas_equalTo(self.floorView.mas_bottom).with.offset(-25);
    }];
    
    /**
     *  定位开关按钮
     *
     *
     */
    self.locate = ({
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(enableOrDisableLocate:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"locate_disable"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"locate_enable"] forState:UIControlStateSelected];
        button;
    });
    [self addSubview:self.locate];
    [self.locate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-160);
    }];
    
    /**
     *  比例尺
     *
     */
    self.scaleImage = ({
        UIImageView *imageview = [UIImageView new];
        imageview.image = [UIImage imageNamed:@"scale"];
        imageview;
    });
    [self addSubview:self.scaleImage];
    [self.scaleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 8));
        make.left.mas_equalTo(self.floorView.mas_right).with.offset(20);
        make.bottom.mas_equalTo(self.floorView);
    }];
    
    self.scale = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:self.scale];
    [self.scale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.scaleImage.mas_width);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.scaleImage);
        make.bottom.mas_equalTo(self.scaleImage.mas_top);
    }];
    
    /**
     *  缩放比例视图
     *
     *
     */
    self.scaleView = ({
        UIView *view = [UIView new];
        view.layer.cornerRadius = 3.0f;
        view.clipsToBounds = YES;
        view;
    });
    [self addSubview:self.scaleView];
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.floorView);
        make.bottom.mas_equalTo(self.scaleImage);
        make.size.mas_equalTo(CGSizeMake(40, 80));
        make.right.mas_equalTo(@-20);
    }];
    
    self.enlarge = ({
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"zoom_big_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"zoom_big_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(zoomEnlargeMap:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.scaleView addSubview:self.enlarge];
    [self.enlarge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scaleView);
        make.left.and.right.mas_equalTo(self.scaleView);
        make.height.mas_equalTo(40);
    }];
    
    self.narrow = ({
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"zoom_small_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"zoom_small_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(zoomNarrowMap:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.scaleView addSubview:self.narrow];
    [self.narrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.scaleView);
        make.left.and.right.mas_equalTo(self.scaleView);
        make.height.mas_equalTo(40);
    }];
    
    // Click once back to normal
    UIImageView *backImage = ({
        UIImageView *imageview = [UIImageView new];
        imageview.image = [UIImage imageNamed:@"compass_back"];
       
        imageview.userInteractionEnabled = YES;
        imageview;
    });
    [self addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    UIImageView *compass = ({
        UIImageView *imageview = [UIImageView new];
        imageview.image = [UIImage imageNamed:@"compass"];
      
        imageview;
    });
    [backImage addSubview:compass];
    [compass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(backImage);
        make.height.mas_equalTo(backImage);
        make.width.mas_equalTo(50.0 * (46.0 / 134.0));
    }];
    UIButton *resetRotation = ({
        
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(backToNormal:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    [backImage addSubview:resetRotation];
    [resetRotation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImage);
        make.left.mas_equalTo(backImage);
        make.width.mas_equalTo(backImage);
        make.height.mas_equalTo(backImage);
    }];
}

#pragma mark -- 复原按钮方法
- (void)backToNormal:(UIButton *)reset {
    
    // 复原容器subview的仿射变换
    for (UIView *subview in self.contentScrollView.subviews) {
        subview.transform = CGAffineTransformMakeRotation(0);
    }
    
   self.mapView.center = self.center;
   [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    //恢复初始容器大小
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.contentScrollView.contentSize = CGSizeMake(size.width * 1.5, size.height * 1.2);
    [self.contentScrollView setScrollsToTop:YES];
    self.lastScale = 1;
    self.lastRotation = 0;
    self.scaleStore.scale = self.lastScale;
    [self changeBig:kinitscale];
    [self changeShopAndLoctionScaleAndRotation];
    [self modifyScaleWithOriginScale:self.lastScale];
}

- (void)addShopView {
    [self.shopView removeFromSuperview];
    self.shopView = ({
        SVAShopView *shop = [SVAShopView new];
        shop.frame = self.mapView.frame;
        shop.transform = self.mapView.transform;
        shop.backgroundColor = [UIColor clearColor];
        shop.opaque = NO;
        shop.clearsContextBeforeDrawing = YES;
        shop;
    });
    
    [self.mapView addSubview:self.shopView];
    [self.mapView bringSubviewToFront:self.shopView];
}

#pragma mark --定位按钮方法
- (void)enableOrDisableLocate:(UIButton *)button {
    // TODO: Enable or disable get location information.
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(locationPoint:) name:@"locationPoint" object:nil];
    
    if (!self.locView) {
        self.locView = [SVALocAndMessageView new];
        self.locView.frame = self.mapView.frame;
        [self.mapView addSubview:self.locView];
    }
    
    self.locationBtn = button;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"privacyKey"]) {
         button.selected = !button.selected;
        
        if (button.selected) {
            [self.locView removePoint];
            [self.locView getLocation];
            [self changeBig:1];
            [self backToNormal:nil];
        } else {
            [self.locView stopLocation];
        }
        
    } else {
        
        //添加自动授权
        [self authorization];
    }
}

#pragma mark - 地图仿射变换
//旋转地图
- (void)rotateScroll:(UIRotationGestureRecognizer *)rotate {
    
    if (rotate.state == UIGestureRecognizerStateEnded) {
        [self changeShopAndLoctionScaleAndRotation];
    }
    
    self.lastRotation += rotate.rotation;
    //    [self adjustAnchorPointForGestureRecognizer:rotate];
    self.mapView.transform = CGAffineTransformRotate(self.mapView.transform, rotate.rotation);
    
    self.scaleStore.scale = self.lastScale;
    self.scaleStore.rotation = self.lastRotation;
    rotate.rotation = 0;
    [self changeShopAndLoctionScaleAndRotation];
}

//缩放地图
- (void)pinchHandle:(UIPinchGestureRecognizer *)pinch {
    
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [self changeShopAndLoctionScaleAndRotation];
    }
    
    self.oldCenter = CGPointMake(SCREEN_SIZE.width / 2, (SCREEN_SIZE.height - 64) / 2);
    
    self.lastScale = self.lastScale * pinch.scale;
    
    if (self.lastScale > 1 ) {
        
        if (self.lastScale >= 5) {
            
            self.lastScale = 5;
            
        } else {
            
            self.mapView.transform = CGAffineTransformScale(self.mapView.transform, pinch.scale, pinch.scale);
            
            //重新绘制POI
            //校正视图位置，使之一直保持在屏幕中间
            self.mapView.center = CGPointMake(self.mapView.center.x*pinch.scale, self.mapView.center.y*pinch.scale);
            self.contentScrollView.contentOffset = CGPointMake(self.mapView.center.x-self.oldCenter.x, self.mapView.center.y-self.oldCenter.y);
            //动态改变容器大小
            self.contentScrollView.contentSize = CGSizeMake(KCONTENTSIZE.width+self.contentScrollView.contentOffset.x*2,KCONTENTSIZE.height+self.contentScrollView.contentOffset.y);
        }
        
    } else {
        self.lastScale = 1;
        
        //校正视图位置，使之一直保持在屏幕中间
        self.mapView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y);
//        self.contentScrollView.contentOffset = CGPointMake(0, 0);
        //动态改变容器大小
//        self.contentScrollView.contentSize = CGSizeMake(KCONTENTSIZE.width,KCONTENTSIZE.height);
    }
    self.scaleStore.scale = self.lastScale;
    [self modifyScaleWithOriginScale:self.lastScale];
    
    
    pinch.scale = 1;
    [self changeShopAndLoctionScaleAndRotation];
}

// 点击放大
- (void)zoomEnlargeMap:(UIButton *)enlarge {
    self.oldCenter = CGPointMake(SCREEN_SIZE.width /2, (SCREEN_SIZE.height-64)/2);
    
    self.lastScale = self.lastScale * kscael;
    
    if(self.lastScale >= 5) {
        self.lastScale = 5;
    } else {
        self.mapView.transform = CGAffineTransformScale(self.mapView.transform, kscael, kscael);
        //校正视图位置，使之一直保持在屏幕中间
        self.mapView.center = CGPointMake(self.mapView.center.x * kscael, self.mapView.center.y * kscael);
        self.contentScrollView.contentOffset = CGPointMake(self.mapView.center.x - self.oldCenter.x, self.mapView.center.y - self.oldCenter.y);
//        //动态改变容器大小
        self.contentScrollView.contentSize = CGSizeMake(KCONTENTSIZE.width + self.contentScrollView.contentOffset.x, KCONTENTSIZE.height + self.contentScrollView.contentOffset.y);
    }
    self.scaleStore.scale = self.lastScale;
    [self changeShopAndLoctionScaleAndRotation];
    [self modifyScaleWithOriginScale:self.lastScale];
}

// 点击缩小
- (void)zoomNarrowMap:(UIButton *)narrow {
    
    self.oldCenter = CGPointMake(SCREEN_SIZE.width/2, (SCREEN_SIZE.height-64)/2);
    
    self.lastScale = self.lastScale * kscael2;
            
    if (self.lastScale <= 1) {
        self.lastScale = 1;
    } else {            
        self.mapView.transform = CGAffineTransformScale(self.mapView.transform, kscael2, kscael2);
        //校正视图位置，使之一直保持在屏幕中间
        self.mapView.center = CGPointMake(self.mapView.center.x*kscael2, self.mapView.center.y*kscael2);
        self.contentScrollView.contentOffset = CGPointMake(self.mapView.center.x-self.oldCenter.x, self.mapView.center.y-self.oldCenter.y);
        //动态改变容器大小
        self.contentScrollView.contentSize = CGSizeMake(KCONTENTSIZE.width+self.contentScrollView.contentOffset.x,KCONTENTSIZE.height+self.contentScrollView.contentOffset.y);
    }
    self.scaleStore.scale = self.lastScale;
    [self changeShopAndLoctionScaleAndRotation];
    [self modifyScaleWithOriginScale:self.lastScale];
}

- (void)changeShopAndLoctionScaleAndRotation {
    
    [self.shopView changeScale:self.lastScale Rotation:self.lastRotation];
    [self.locView changeScale:self.lastScale Rotation:self.lastRotation];
    [ScaleStore defaultScale].rotation = self.lastRotation;
}

// 地图缩放
- (void)modifyScaleWithOriginScale:(CGFloat)scale {

    if (!self.floors || self.floors.count == 0) return;
    SVAMapDataModel *mapModel = (SVAMapDataModel *)(self.floors[0]);
    [SVACoordinateConversion setScale:self.scale
                             andImage:self.scaleImage
                         WithMapModel:mapModel
                           touchScale:scale];
}

- (CGPoint)getCurrentPosition {
    // Get center of visible rect.
    CGFloat visibleX = self.contentScrollView.contentOffset.x;
    CGFloat visibleY = self.contentScrollView.contentOffset.y;
    CGPoint visibleCenter = CGPointMake(visibleX + CGRectGetWidth(self.contentScrollView.frame) / 2, visibleY + CGRectGetHeight(self.contentScrollView.frame) / 2);
    return visibleCenter;
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    
    zoomRect.size.height = self.contentScrollView.frame.size.height / scale;
    zoomRect.size.width  = self.contentScrollView.frame.size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


#pragma mark - --Delegate of UIScrollView
#if 0
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mapView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    scrollView.contentSize = CGSizeMake(5000, 5000);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (self.contentScrollView.zoomScale < 1.0) self.contentScrollView.zoomScale = 1.0;
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    
//    self.poiView.frame = self.mapView.frame;
    self.poiView.scale = self.mapView.transform.a;
    [self.poiView addAllLayer];
    
    [self modifyScaleWithOriginScale:self.mapView.transform.a];
}
#endif

#pragma mark - --Delegate and datasource methods of UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.floors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVAFloorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SVAFloorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.floorLabel.text = ((SVAMapDataModel *)self.floors[indexPath.row]).floor;
//    cell.floorLabel.text = [NSString stringWithFormat:@"%ldF",((long)indexPath.row+1)];
    
    return cell;
}

#pragma mark -- 切换楼层
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.locationBtn.selected = NO;
    // 选择楼层，切换地图时停止定位操作
    [[SVALocationViewModel sharedLocateViewModel] stopLocating];
    [self.locView removePoint];
    [self.locView removeLocationPoint];
    [self.locView stopLocation];
    
    // 是否切换楼层 isChangeFloor
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeFloor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 重新加载相应楼层的地图
    self.mapView.transform = CGAffineTransformIdentity;
    
    
    [self.mapView loadMapWithMapModel:(SVAMapDataModel *)(self.floors[indexPath.row])];
    self.mapModel = (SVAMapDataModel *)(self.floors[indexPath.row]);
    
    // 重置地图比例为屏幕大小
    [self modifyScaleWithOriginScale:1.0];
    // 添加POI视图
    [self addShopView];
    [self.shopView getShopsWithMapModel:(SVAMapDataModel *)(self.floors[indexPath.row])];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"privacyKey"]) {
        
        //添加定位授权
        [self authorization];
        
    }
    [self backToNormal:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 强制滚动到中心的实现
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.floorSelection isEqual:scrollView]) {
        [self scrollToRowByOffsetY:scrollView.contentOffset.y];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.floorSelection isEqual:scrollView]) {
        [self scrollToRowByOffsetY:scrollView.contentOffset.y];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}

- (void)scrollToRowByOffsetY:(CGFloat)offsetY {
    // TODO: 滚动至中心位置
//    if (self.offsetY > offsetY) {
//        [self.floorSelection scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    } else {
//        [self.floorSelection scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


@end
