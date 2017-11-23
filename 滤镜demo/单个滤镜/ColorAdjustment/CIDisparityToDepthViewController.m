//
//  CIDisparityToDepthViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/27.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIDisparityToDepthViewController.h"
#import "FPCameraView.h"

@interface CIDisparityToDepthViewController ()<AVCapturePhotoCaptureDelegate>

@end

@implementation CIDisparityToDepthViewController {
    CIImage *_image;
    AVCaptureDevice *_device;
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_input;
//    AVCaptureDepthDataOutput *_output;
    AVCapturePhotoOutput *_photoOutput;
    AVCaptureVideoPreviewLayer *_previewLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //疑问1："输入视差数据图像以转换为景深数据。"，视差数据图像从何而来？
    //猜测1：视差是感受远近深浅的基础，是从多个点观察同一对象产生视差，人的双眼观察物体时，会自然而然的产生视差的。手机的视差是由双摄像头来产生，从而得知物体的远近或深浅。这个推测有待验证。
    //疑问2：加入猜测1成立，那么如何获取双摄像头的视差数据图像？
    //猜测2：AVCapturePhoto中有depthData属性，不知道是否可以转换成CIImage
    self.filter = [CIFilter filterWithName:@"CIDepthToDisparity"];
    [self setAV];
}

- (void)setAV {
    AVCaptureDevicePosition position = AVCaptureDevicePositionBack;
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDualCamera] mediaType:AVMediaTypeVideo position:position];
    for ( AVCaptureDevice *device in session.devices ) {
        if ( device.position == position ){
            _device = device;
            break;
        }
    }
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    _session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    _input = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    
//    _output = [[AVCaptureDepthDataOutput alloc] init];
//    dispatch_queue_t depthData_queue = dispatch_queue_create("depthData_queue", DISPATCH_QUEUE_SERIAL);
//    [_output setDelegate:session callbackQueue:depthData_queue];
    
    _photoOutput = [[AVCapturePhotoOutput alloc] init];
    
    
//    dispatch_queue_t photo_queue = dispatch_queue_create("photo_queue", DISPATCH_QUEUE_SERIAL);
    
    
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
//    if ([_session canAddOutput:_output]) {
//        [_session addOutput:_output];
//    }
    
    if ([_session canAddOutput:_photoOutput]) {
        [_session addOutput:_photoOutput];
        _photoOutput.highResolutionCaptureEnabled = YES;
        _photoOutput.livePhotoCaptureEnabled = _photoOutput.livePhotoCaptureSupported;
        _photoOutput.depthDataDeliveryEnabled = _photoOutput.depthDataDeliverySupported;
    }
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_previewLayer];
    
    [_session commitConfiguration];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    AVCaptureVideoOrientation videoPreviewLayerVideoOrientation = _previewLayer.connection.videoOrientation;
    
    // Update the photo output's connection to match the video orientation of the video preview layer.
    AVCaptureConnection *photoOutputConnection = [_photoOutput connectionWithMediaType:AVMediaTypeVideo];
    photoOutputConnection.videoOrientation = videoPreviewLayerVideoOrientation;
    
    AVCapturePhotoSettings *photoSettings;
    // Capture HEIF photo when supported, with flash set to auto and high resolution photo enabled.
    if ( [_photoOutput.availablePhotoCodecTypes containsObject:AVVideoCodecTypeHEVC] ) {
        photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{ AVVideoCodecKey : AVVideoCodecTypeHEVC }];
    }
    else {
        photoSettings = [AVCapturePhotoSettings photoSettings];
    }
    
    photoSettings.flashMode = AVCaptureFlashModeAuto;
    
    photoSettings.highResolutionPhotoEnabled = YES;
    if ( photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 ) {
        photoSettings.previewPhotoFormat = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : photoSettings.availablePreviewPhotoPixelFormatTypes.firstObject };
    }
    
    
    if (_photoOutput.isDepthDataDeliverySupported ) {
        photoSettings.depthDataDeliveryEnabled = YES;
    } else {
        photoSettings.depthDataDeliveryEnabled = NO;
    }
    
    
    [_photoOutput capturePhotoWithSettings:photoSettings delegate:self];
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput willBeginCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput willCapturePhotoForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    _image = [CIImage imageWithData:photo.fileDataRepresentation];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    [self refilter];
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishRecordingLivePhotoMovieForEventualFileAtURL:(NSURL *)outputFileURL resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingLivePhotoToMovieFileAtURL:(NSURL *)outputFileURL duration:(CMTime)duration photoDisplayTime:(CMTime)photoDisplayTime resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(NSError *)error {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(NSError *)error {
    
}

@end
