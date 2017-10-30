//
//  CIDisparityToDepthViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/27.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIDisparityToDepthViewController.h"
#import "FPCameraView.h"

@interface CIDisparityToDepthViewController ()<AVCaptureDepthDataOutputDelegate, AVCapturePhotoCaptureDelegate>

@end

@implementation CIDisparityToDepthViewController {
    CIImage *_image;
    AVCaptureDevice *_device;
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_input;
    AVCaptureDepthDataOutput *_output;
    AVCapturePhotoOutput *_photoOutput;
    AVCaptureVideoPreviewLayer *_previewLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //疑问1："输入视差数据图像以转换为景深数据。"，视差数据图像从何而来？
    //猜测1：视差是感受远近深浅的基础，是从多个点观察同一对象产生视差，人的双眼观察物体时，会自然而然的产生视差的。手机的视差是由双摄像头来产生，从而得知物体的远近或深浅。这个推测有待验证。
    //疑问2：加入猜测1成立，那么如何获取双摄像头的视差数据图像？
    //猜测2：AVCapturePhoto中有depthData属性，不知道是否可以转换成CIImage
    [self setAV];
}

- (void)setAV {
    AVCaptureDevicePosition position = AVCaptureDevicePositionBack;
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    for ( AVCaptureDevice *device in session.devices ) {
        if ( device.position == position ){
            _device = device;
            break;
        }
    }
    _input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:nil];
    
    
    _output = [[AVCaptureDepthDataOutput alloc] init];
    dispatch_queue_t depthData_queue = dispatch_queue_create("depthData_queue", DISPATCH_QUEUE_SERIAL);
    [_output setDelegate:session callbackQueue:depthData_queue];
    
    _photoOutput = [[AVCapturePhotoOutput alloc] init];
    dispatch_queue_t photo_queue = dispatch_queue_create("photo_queue", DISPATCH_QUEUE_SERIAL);
    [_output setDelegate:session callbackQueue:photo_queue];
    if (_photoOutput.isDepthDataDeliverySupported) {
        _photoOutput.depthDataDeliveryEnabled = YES;
    }
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    if ([_session canAddOutput:_photoOutput]) {
        [_session addOutput:_photoOutput];
    }
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_previewLayer];
    
    [_session startRunning];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _previewLayer.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)refilter {
    
    [self setOutputImage:_image.extent];
}

- (void)depthDataOutput:(AVCaptureDepthDataOutput *)output didOutputDepthData:(AVDepthData *)depthData timestamp:(CMTime)timestamp connection:(AVCaptureConnection *)connection {
    NSLog(@"%@", depthData);
}



- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    AVCapturePhotoSettings *setting = [[AVCapturePhotoSettings alloc] init];
//
//    NSDictionary *format = @{ (__bridge id)kCVPixelBufferPixelFormatTypeKey:setting.availablePreviewPhotoPixelFormatTypes.firstObject,
//                              (__bridge id)kCVPixelBufferWidthKey :@(self.view.bounds.size.width),
//                              (__bridge id)kCVPixelBufferHeightKey :@(self.view.bounds.size.height)
//                              };
//    setting.previewPhotoFormat = format;
//    if (@available(iOS 11.0, *)) {
////        setting.embedsDepthDataInPhoto = YES;
//        setting.depthDataDeliveryEnabled = YES;
//    }
//    setting.flashMode = AVCaptureFlashModeOn;
//
//    [_photoOutput capturePhotoWithSettings:setting delegate:self];
    AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeDepthData];
    
}

@end
