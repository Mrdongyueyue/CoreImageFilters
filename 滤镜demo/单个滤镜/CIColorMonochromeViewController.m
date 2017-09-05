//
//  CIColorMonochromeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorMonochromeViewController.h"
//#import <GPUImage.h>
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>

@interface CIColorMonochromeViewController ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, weak) UISlider *r_slider;
@property (nonatomic, weak) UISlider *g_slider;
@property (nonatomic, weak) UISlider *b_slider;
@property (nonatomic, weak) UISlider *a_slider;

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//输出图片
@property (nonatomic ,strong) AVCapturePhotoOutput *imageOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImage *image;

@end

@implementation CIColorMonochromeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAV];
    [self setupSlider];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(180, 600, 30, 30);
    [button addTarget:self action:@selector(photoBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)setupAV {
    //    AVCaptureDevicePositionBack  后置摄像头
    //    AVCaptureDevicePositionFront 前置摄像头
    self.device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.imageOutput = [[AVCapturePhotoOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    //     拿到的图像的大小可以自行设定
    //    AVCaptureSessionPreset320x240
    //    AVCaptureSessionPreset352x288
    //    AVCaptureSessionPreset640x480
    //    AVCaptureSessionPreset960x540
    //    AVCaptureSessionPreset1280x720
    //    AVCaptureSessionPreset1920x1080
    //    AVCaptureSessionPreset3840x2160
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    //预览层的生成
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //设备取景开始
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        //自动闪光灯，
        if ([_imageOutput.supportedFlashModes containsObject:@(AVCaptureFlashModeAuto)]) {
            [AVCapturePhotoSettings photoSettings].flashMode = AVCaptureFlashModeAuto;
            
        }
        //自动白平衡,但是好像一直都进不去
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    AVCaptureDeviceDiscoverySession *devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    for ( AVCaptureDevice *device in devices.devices ) {
        if ( device.position == position ){
            return device;
        }
    }
    return nil;
}

//MARK:-- AVCapturePhotoCaptureDelegate ~~~~
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData *data = [photo fileDataRepresentation];
    self.image = [UIImage imageWithData:data];
    self.imageView.image = self.image;//[UIImage imageWithData:data];
    [self.session stopRunning];
    self.previewLayer.hidden = YES;
    UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, NULL);
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingLivePhotoToMovieFileAtURL:(NSURL *)outputFileURL duration:(CMTime)duration photoDisplayTime:(CMTime)photoDisplayTime resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(NSError *)error {
    
}

- (void)photoBtnDidClick
{
    AVCapturePhotoSettings *setting = [[AVCapturePhotoSettings alloc] init];
    
//    NSDictionary *format = @{ (__bridge id)kCVPixelBufferPixelFormatTypeKey:setting.availablePreviewPhotoPixelFormatTypes.firstObject,
//                              (__bridge id)kCVPixelBufferWidthKey :@(160),
//                              (__bridge id)kCVPixelBufferHeightKey :@(160)
//                              };
//    setting.previewPhotoFormat = format;
    [self.imageOutput capturePhotoWithSettings:setting delegate:self];
    
//    AVCaptureConnection *conntion = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
//    if (!conntion) {
//        NSLog(@"拍照失败!");
//        return;
//    }
//    [self.imageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if (imageDataSampleBuffer == nil) {
//            return ;
//        }
//        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        [UIImage imageWithData:imageData];
//        [self.session stopRunning];
//
//    }];
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
    CIImage *inputImage = [CIImage imageWithCGImage:self.image.CGImage];
    CIColor *color = [CIColor colorWithRed:_r_slider.value green:_g_slider.value blue:_b_slider.value alpha:_a_slider.value];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //先打印NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryDistortionEffect]);进去找到需要设置的属性(查询效果分类中都有什么效果)  可以设置什么效果
        //然后通过[CIFilter filterWithName:@""];找到属性   具体效果的属性
        //然后通过KVC的方式设置属性
        NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryDistortionEffect]);
        /*
         1.查询 效果分类中 包含什么效果：filterNamesInCategory:
         2.查询 使用的效果中 可以设置什么属性（KVC） attributes
         
         使用步骤
         1.需要添加滤镜的源图
         2.初始化一个滤镜 设置滤镜（根据查询到的属性来设置）
         3.把滤镜 输出的图像 和滤镜  合并 CIContext -> 得到一个合成之后的图像
         4.展示
         */
        CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
        NSLog(@"%@",filter.attributes);
        //这个属性是必须赋值的，假如你处理的是图片的话
        [filter setValue:inputImage forKey:kCIInputImageKey];
        
        [filter setValue:color forKey:kCIInputColorKey];
        //CIContext
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *outPutImage = filter.outputImage;
        
        CGImageRef image = [context createCGImage:outPutImage fromRect:outPutImage.extent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithCGImage:image];
            CGImageRelease(image);
        });
    });

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


@end
