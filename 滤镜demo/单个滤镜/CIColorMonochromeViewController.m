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
#import <TuSDKGeeV1/TuSDKGeeV1.h>
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

@property (nonatomic, strong) TuSDKCPPhotoEditMultipleComponent *photoEditMultipleComponent;

@end

@implementation CIColorMonochromeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAV];
    [self setupSlider];
    
//    [self setupTuSDK];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(180, 600, 30, 30);
    [button addTarget:self action:@selector(photoBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
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
    [_camerView takePhotoComplete:^(AVCapturePhoto *photo, NSError *error) {
        __strong typeof(wself)self = wself;
        self.photo = photo;
        UIImage *image = [[photo fileDataRepresentation] orientationImage];
        self.image = image;
        self.imageView.image = image;
        [self beautifyFilter];
    }];
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

- (void)filter {
    [FPImageFilter colorMonochromeFilter:self.image color:[UIColor colorWithRed:_r_slider.value green:_g_slider.value blue:_b_slider.value alpha:_a_slider.value] complete:^(UIImage *image, NSError *error) {
        self.imageView.image = image;
        [self beautifyFilter];
    }];
//    [FPImageFilter autoFilter:self.photo complete:^(UIImage * _Nullable image, NSError * _Nullable error) {
//        self.imageView.image = image;
//    }];
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
    [self filter];
}

- (void)beautifyFilter {
    
    [FPImageFilter beautyFilter:self.imageView.image complete:^(UIImage * _Nullable image, NSError * _Nullable error) {
        self.imageView.image = image;
    }];
}

- (void)setupTuSDK {
    _photoEditMultipleComponent =
    [TuSDKGeeV1 photoEditMultipleWithController:self
                                  callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         // 获取图片失败
         if (error) {
             lsqLError(@"editMultiple error: %@", error.userInfo);
             return;
         }
         [result logInfo];
         
         //
         // 可在此添加自定义方法，在编辑完成时进行页面跳转操，例如 ：
         // [controller presentViewController:[[UIViewController alloc] init] animated:YES completion:nil];
         
         // 图片处理结果 TuSDKResult *result 具有三种属性，分别是 ：
         // result.image 是 UIImage 类型
         // result.imagePath 是 NSString 类型
         // result.imageAsset 是 TuSDKTSAssetInterface 类型
         
         // 下面以 result.image 举例如何将图片编辑结果持有并进行其他操作
         // 可在此添加自定义方法，将 result 结果传出，例如 ：  [self openEditorWithImage:result.image];
         // 并在外部使用方法接收 result 结果，例如 ： -(void)openEditorWithImage:(UIImage *)image;
         // 用户也可以在 result 结果的外部接受的方法中实现页面的跳转操作，用户可根据自身需求使用。
         
         // 用户在获取到 result.image 结果并跳转到其他页面进行操作的时候可能会出现无法持有对象的情况
         // 此时用户可以将 result.image 对象转换成 NSData 类型的对象，然后再进行操作，例如 ：
         // NSData *imageData = UIImageJPEGRepresentation(result.image, 1.0);
         // ViewController *viewController = [[ViewController alloc]init];
         // [self.controller pushViewController:viewController animated:YES];
         // viewController.currentImage = [UIImage imageWithData:imageData];
         
         // 获取 result 对象的不同属性，需要对 option 选项中的保存到相册和保存到临时文件相关项进行设置。
         //
         
     }];
    
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionCuter];
    
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionFilter];
    
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionSkin];
}

@end
