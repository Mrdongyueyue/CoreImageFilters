//
//  CIColorMonochromeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorMonochromeViewController.h"
#import <GPUImage.h>
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import "GPUImageBeautifyFilter.h"
#import "FPImageFilter.h"
#import "FPCameraView.h"

@interface CIColorMonochromeViewController ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, weak) UISlider *r_slider;
@property (nonatomic, weak) UISlider *g_slider;
@property (nonatomic, weak) UISlider *b_slider;
@property (nonatomic, weak) UISlider *a_slider;

@property (nonatomic, strong) FPCameraView *camerView;

@property (nonatomic, strong) AVCapturePhoto *photo;

@property (nonatomic, strong) UIImage *image;

@end

@implementation CIColorMonochromeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[//0.76 0.6
                       @{
                           @"name":@"color_r",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"color_g",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.76",
                           },
                       @{
                           @"name":@"color_b",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.6",
                           },
                       @{
                           @"name":@"color_a",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       ];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++) {
        YYFilterAttributeModel *model = [YYFilterAttributeModel new];
        NSDictionary *dict = array[i];
        model.attributeName = dict[@"name"];
        model.maxValue = [dict[@"max"] floatValue];
        model.minValue = [dict[@"min"] floatValue];
        model.value = [dict[@"v"] floatValue];
        [temp addObject:model];
    }
    
    self.filterAttributeModels = temp;
    self.image = self.imageView.image;
    [self refilter];
//    [self setupAV];
//    [self setupSlider];
    
//    [self setupTuSDK];
    
//    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    takePhotoButton.frame = CGRectMake(160, 600, 30, 30);
//    [takePhotoButton addTarget:self action:@selector(photoBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:takePhotoButton];
//
//    UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    flipButton.frame = CGRectMake(280, 70, 30, 30);
//    [flipButton addTarget:self action:@selector(flipBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:flipButton];
//
//    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    flashButton.frame = CGRectMake(320, 70, 50, 30);
//    flashButton.backgroundColor = [UIColor orangeColor];
//    flashButton.titleLabel.textColor = [UIColor whiteColor];
//    [flashButton addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:flashButton];
//    [flashButton setTitle:@"auto" forState:UIControlStateNormal];
}

- (void)setupAV {
    _camerView = [[FPCameraView alloc] init];
    [self.view addSubview:_camerView];
    [_camerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)photoBtnDidClick {
    __weak typeof(self)wself = self;
    if (@available(iOS 11.0, *)) {
        [_camerView takePhotoComplete:^(AVCapturePhoto *photo, NSError *error) {
            __strong typeof(wself)self = wself;
            self.photo = photo;
            UIImage *image = [[photo fileDataRepresentation] orientationImage];
            self.image = image;
            self.imageView.image = image;
            [self beautifyFilter];
        }];
    } else {
        
    }
}

- (void)flipBtnClick {
    [_camerView flipCamera];
}

- (void)flashBtnClick:(UIButton *)btn {
    switch (_camerView.flashMode) {
        case AVCaptureFlashModeOn:
            _camerView.flashMode = AVCaptureFlashModeOff;
            [btn setTitle:@"off" forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeOff:
            _camerView.flashMode = AVCaptureFlashModeAuto;
            [btn setTitle:@"auto" forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeAuto:
            _camerView.flashMode = AVCaptureFlashModeOn;
            [btn setTitle:@"on" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setupSlider {
    self.imageView.image = nil;
    
    CGFloat y = [UIScreen mainScreen].bounds.size.height - 30 * 4;
    _r_slider = [self makeSlider];
    _r_slider.value = 1.000;
    _r_slider.frame = CGRectMake(80, y, 200, 25);
    y += 30;
    
    _g_slider = [self makeSlider];
    _g_slider.frame = CGRectMake(80, y, 200, 25);
    _g_slider.value = 0.759;
    y += 30;
    
    _b_slider = [self makeSlider];
    _b_slider.frame = CGRectMake(80, y, 200, 25);
    _b_slider.value = 0.592;
    y += 30;
    
    _a_slider = [self makeSlider];
    _a_slider.frame = CGRectMake(80, y, 200, 25);
    _a_slider.value = 1.000;
    
}

- (void)refilter {
    [super refilter];
    UIColor *color = [UIColor colorWithRed:self.filterAttributeModels[0].value
                                     green:self.filterAttributeModels[1].value
                                      blue:self.filterAttributeModels[2].value
                                     alpha:self.filterAttributeModels[3].value];
    
    __weak typeof(self)wself = self;
    [FPImageFilter colorMonochromeFilter:self.image color:color complete:^(UIImage *image, NSError *error) {
        __strong typeof(wself)self = wself;
        self.imageView.image = image;
        [self beautifyFilter];
    }];

}

- (UISlider *)makeSlider {
    UISlider *slider = [[UISlider alloc] init];
    slider.maximumValue = 1;
    slider.minimumValue = 0;
    [slider addTarget:self action:@selector(didSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    return slider;
}

- (void)didSlider:(UISlider *)slider {
//    [self filter];
}

- (void)beautifyFilter {
    __weak typeof(self)wself = self;
    [FPImageFilter beautyFilter:self.imageView.image complete:^(UIImage * _Nullable image, NSError * _Nullable error) {
        __strong typeof(wself)self = wself;
        self.imageView.image = image;
    }];
}

@end
