//
//  SVAMap.m
//  SVA
//
//  Created by Zeacone on 16/1/14.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SVAMap.h"

#import "SVAPointParser.h"
#import "SVARouteDataViewModel.h"
#import "SVAShopView.h"
#import "SVALocAndMessageView.h"


@implementation SVAMap

- (void)resetMap {
    self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
    [self.imageMap removeFromSuperview];
    self.svgMap.hidden = YES;
    [self.svgMap removeFromSuperview];
    self.imageMap = nil;
    self.svgMap = nil;
}

- (void)loadMapWithMapModel:(SVAMapDataModel *)mapModel {
    [self resetMap];
    self.mapModel = mapModel;
    
    if (mapModel.svg) {
        [self loadSVGMap];
    } else {
        [self loadImageMap];
    }
    [self downloadPathFilterFile];
    [self downloadPathFile];
}

- (void)loadSVGMap {
    if (!self.svgMap) {
        self.svgMap = [[SVASVGMapView alloc] init];
    }
    
    self.svgMap.center = self.center;
    self.svgMap.bounds = self.bounds;
    
    [self addSubview:self.svgMap];
    [self sendSubviewToBack:self.svgMap];
    
    @weakify(self);
    [self.svgMap loadSVGMapWithName:self.mapModel.svg handler:^{
        @strongify(self);
        [[SVAMapView sharedMap] backToNormal:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapHasDownloaded:)]) {
            [self.delegate mapHasDownloaded:self.mapModel];
        }
    }];
    
    // Set callback for click.
    [self.svgMap setClickHandler:^(NSString *identifier, CAShapeLayer *layer, CGPoint touchPoint) {
        @strongify(self);
        if (self.oldClickedlayer) {
            self.oldClickedlayer.zPosition = 0;
            self.oldClickedlayer.shadowOpacity = 0;
        }
        self.oldClickedlayer = layer;
        layer.zPosition = 5;
        layer.shadowOpacity = 0.5;
        layer.shadowColor = [UIColor redColor].CGColor;
        layer.fillColor = [UIColor redColor].CGColor;
        layer.shadowRadius = 1;
        layer.shadowOffset = CGSizeMake(3, 3);
    }];
}

- (void)loadImageMap {
    
    self.imageMap = [[SVAImageMapView alloc] init];
    self.imageMap.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self addSubview:self.imageMap];
    [self sendSubviewToBack:self.imageMap];
    @weakify(self);
    [self.imageMap loadImageMapWithName:self.mapModel.path handler:^{
        @strongify(self);
        [[SVAMapView sharedMap] backToNormal:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapHasDownloaded:)]) {
            [self.delegate mapHasDownloaded:self.mapModel];
        }
    }];
}

- (void)downloadPathFilterFile {
    if (!self.mapModel.route) return;
    
    NSString *key = [self.mapModel.route stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content = ((NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:key]);
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil];
    NSURL *xmlURL = [documentsDirectoryURL URLByAppendingPathComponent:self.mapModel.route];
    
    // 如果key所对应的路径滤波时间戳不存在或者发生变化，则下载新的路径滤波文件并解析
    if (!content || self.mapModel.updateTime.doubleValue != content.doubleValue) {
        [[NSFileManager defaultManager] removeItemAtURL:xmlURL error:nil];
        @weakify(self);
        [[SVANetworkResource sharedResource] downloadPathFilterWithFilename:self.mapModel.route CompletionHandler:^(NSURL *filepath) {
            @strongify(self);
            self.points = [[SVAPointParser new] getPointsFromXML:filepath withScale:self.mapModel.scale.doubleValue mapWidth:self.mapModel.imgWidth mapHeight:self.mapModel.imgHeight];
        }];
    }
    // 另外如果路径滤波文件存在，则直接解析
    else if ([[NSFileManager defaultManager] fileExistsAtPath:xmlURL.path]) {
        self.points = [[SVAPointParser new] getPointsFromXML:xmlURL withScale:self.mapModel.scale.doubleValue mapWidth:self.mapModel.imgWidth mapHeight:self.mapModel.imgHeight];
    }
    [PFFilter sharedPathFilter].fingerPrintXY = self.points;
    [[NSUserDefaults standardUserDefaults] setObject:self.mapModel.updateTime forKey:key];
}

- (void)downloadPathFile {
    if (!self.mapModel.route) return;
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil];
    NSString *tmpPath = [NSString stringWithFormat:@"%@%@", self.mapModel.place, self.mapModel.floor];
    NSURL *xmlURL = [documentsDirectoryURL URLByAppendingPathComponent:tmpPath];
    
    // 下载路径规划文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:xmlURL.path]) {
        [[SVANetworkResource sharedResource] downloadPathFileWithMapModel:self.mapModel];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    SVAShopView *shopview;
    SVALocAndMessageView *pushView;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:SVAShopView.class]) {
            shopview = (SVAShopView *)subview;
        } else if ([subview isKindOfClass:SVALocAndMessageView.class]) {
            pushView = (SVALocAndMessageView *)subview;
        }
    }
    
//    for (CALayer *layer in [ScaleStore defaultScale].shoplayers) {
//        if (CGRectContainsPoint(layer.frame, point)) {
//            return shopview;
//        }
//    }
//    
//    for (CALayer *layer in [ScaleStore defaultScale].pushlayers) {
//        if (CGRectContainsPoint(layer.frame, point)) {
//            return pushView;
//        }
//    }
    
    for (NSValue *value in [ScaleStore defaultScale].shopPoints) {
        if (CGRectContainsPoint(CGRectMake(value.CGPointValue.x - 5, value.CGPointValue.y - 5, 10, 10), point)) {
            return shopview;
        }
    }
    
    for (NSValue *value in [ScaleStore defaultScale].pushPoints) {
        if (CGRectContainsPoint(CGRectMake(value.CGPointValue.x - 5, value.CGPointValue.y - 5, 10, 10), point)) {
            return pushView;
        }
    }
    
    [self removePopupView];
    
    return self;
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

@end
