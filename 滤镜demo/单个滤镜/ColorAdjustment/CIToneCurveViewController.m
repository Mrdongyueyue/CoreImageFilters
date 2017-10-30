//
//  CIToneCurveViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/30.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIToneCurveViewController.h"
#import <Masonry.h>

@interface CIToneCurveViewController ()

@end

@implementation CIToneCurveViewController {
    CIImage *_image;
    UIView *_curveView;
    CAShapeLayer *_curveLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       //1
                       @{
                           @"name":@"inputPoint1_x",
                           @"max":@"0.25",
                           @"min":@"0",
                           @"v":@"0.25",
                           },
                       @{
                           @"name":@"inputPoint1_y",
                           @"max":@"0.25",
                           @"min":@"0",
                           @"v":@"0.25",
                           },
                       //2
                       @{
                           @"name":@"inputPoint2_x",
                           @"max":@"0.5",
                           @"min":@"0.25",
                           @"v":@"0.5",
                           },
                       @{
                           @"name":@"inputPoint2_y",
                           @"max":@"0.5",
                           @"min":@"0.25",
                           @"v":@"0.5",
                           },
                       //3
                       @{
                           @"name":@"inputPoint3_x",
                           @"max":@"0.75",
                           @"min":@"0.5",
                           @"v":@"0.75",
                           },
                       @{
                           @"name":@"inputPoint3_y",
                           @"max":@"0.75",
                           @"min":@"0.5",
                           @"v":@"0.75",
                           },
                       //4
                       @{
                           @"name":@"inputPoint4_x",
                           @"max":@"1",
                           @"min":@"0.75",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputPoint4_y",
                           @"max":@"1",
                           @"min":@"0.75",
                           @"v":@"1",
                           },
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
    
    [self createSubviews];
    [self displayCurve];
}

- (void)refilter {
    
    CIVector *point0 = [CIVector vectorWithX:0 Y:0];
    CIVector *point1 = [CIVector vectorWithX:self.filterAttributeModels[0].value
                                           Y:self.filterAttributeModels[1].value];
    CIVector *point2 = [CIVector vectorWithX:self.filterAttributeModels[2].value
                                           Y:self.filterAttributeModels[3].value];
    CIVector *point3 = [CIVector vectorWithX:self.filterAttributeModels[4].value
                                           Y:self.filterAttributeModels[5].value];
    CIVector *point4 = [CIVector vectorWithX:self.filterAttributeModels[6].value
                                           Y:self.filterAttributeModels[7].value];
    
    [self.filter setValue:point0 forKey:@"inputPoint0"];
    [self.filter setValue:point1 forKey:@"inputPoint1"];
    [self.filter setValue:point2 forKey:@"inputPoint2"];
    [self.filter setValue:point3 forKey:@"inputPoint3"];
    [self.filter setValue:point4 forKey:@"inputPoint4"];
    
    [self setOutputImage:_image.extent];
    [self displayCurve];
}

- (void)displayCurve {
    CGPoint point0 = CGPointMake(0, 100);
    CGPoint point1 = CGPointMake(self.filterAttributeModels[0].value * 100,
                                 100 - self.filterAttributeModels[1].value * 100);
    CGPoint point2 = CGPointMake(self.filterAttributeModels[2].value * 100,
                                 100 - self.filterAttributeModels[3].value * 100);
    CGPoint point3 = CGPointMake(self.filterAttributeModels[4].value * 100,
                                 100 - self.filterAttributeModels[5].value * 100);
    CGPoint point4 = CGPointMake(self.filterAttributeModels[6].value * 100,
                                 100 - self.filterAttributeModels[7].value * 100);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point0];
    [path addLineToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    
    _curveLayer.path = path.CGPath;
    
}

- (void)createSubviews {
    _curveView = [[UIView alloc] init];
    _curveView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_curveView];
    [_curveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.text = @"tone curve";
    titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    [_curveView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(_curveView);
    }];
    
    _curveLayer = [CAShapeLayer layer];
    _curveLayer.lineWidth = 2;
    _curveLayer.fillColor = [UIColor clearColor].CGColor;
    _curveLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9].CGColor;
    _curveLayer.frame = CGRectMake(0, 0, 100, 100);
    _curveLayer.lineCap = kCALineCapRound;
    [_curveView.layer addSublayer:_curveLayer];
    
}

@end
