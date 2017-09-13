//
//  YYCameraView.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/12.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYCameraView.h"
#import <CoreImage/CoreImage.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <GLKit/GLKit.h>

@interface YYCameraView ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@implementation YYCameraView {
    ///捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
    AVCaptureDevice *_device;
    
    ///AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
    AVCaptureDeviceInput *_input;
    
    ///输出设备
    AVCaptureVideoDataOutput *_output;
    
    ///session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
    AVCaptureSession *_session;
    
    ///图像预览层，实时显示捕获的图像
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    NSMutableArray<CALayer *> *_faceBoxs;
    
    CIContext *_context;
    GLKView *_videoPreviewView;
    EAGLContext *_eag_context;
    CIFilter *_filter;
    CIColor *_ci_color;
    CIDetector *_detector;
    CALayer *_thumbnailLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeConfig];
    }
    return self;
}

- (void)initializeConfig {
    _faceBoxs = [NSMutableArray array];
    
    _device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    _devicePosition = AVCaptureDevicePositionFront;
    _input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:nil];
    
    _output = [[AVCaptureVideoDataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("output_queue", DISPATCH_QUEUE_SERIAL);
    [_output setSampleBufferDelegate:self queue:queue];
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    //输入输出设备结合
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    //预览层的生成
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:_previewLayer];
    //设备取景开始
    [_session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    _eag_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _videoPreviewView = [[GLKView alloc] initWithFrame:CGRectZero context:_eag_context];
    [self addSubview:_videoPreviewView];
    _context = [CIContext contextWithEAGLContext:_eag_context options:@{kCIContextWorkingColorSpace : [NSNull null]}];
    _filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    _ci_color = [CIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [_filter setValue:_ci_color forKey:kCIInputColorKey];
    
    NSDictionary *options = @{
                              CIDetectorAccuracy : CIDetectorAccuracyHigh,
                              //                              CIDetectorMaxFeatureCount : @20,
                              //                              CIDetectorSmile : @(YES),
                              //                              CIDetectorEyeBlink : @(YES)
                              };
    _detector = [CIDetector detectorOfType:CIFeatureTypeFace context:nil options:options];
    
    _thumbnailLayer = [CALayer layer];
    _thumbnailLayer.contentsFormat = kCAGravityResizeAspectFill;
//    [self.layer addSublayer:_thumbnailLayer];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
#if iOS_10
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    for ( AVCaptureDevice *device in session.devices ) {
        if ( device.position == position ){
            return device;
        }
    }
#else
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ){
            return device;
        }
    }
#endif
    return nil;
}

//MARK:--- AVCaptureVideoDataOutputSampleBufferDelegate ~~~~
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *image = [CIImage imageWithCVImageBuffer:imageBuffer];
    
    [_filter setValue:image forKey:kCIInputImageKey];
    CIImage *outPutImage = _filter.outputImage;
    image = outPutImage;
    [_videoPreviewView bindDrawable];
    if (_eag_context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:_eag_context];
    }
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    if (image) {
        [_context drawImage:image inRect:CGRectMake(0, 0, _videoPreviewView.drawableWidth, _videoPreviewView.drawableHeight) fromRect:outPutImage.extent];
    }
    [_videoPreviewView display];
    
    NSArray *faces = [_detector featuresInImage:image];
    for (NSInteger i = 0; i < faces.count; i ++) {
        CIFaceFeature *f = faces[i];
        if (_faceBoxs.count <= i) {
            CALayer *layer = [CALayer layer];
            layer.borderColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.3 alpha:0.9].CGColor;
            layer.borderWidth = 1;
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.hidden = YES;
            [_videoPreviewView.layer addSublayer:layer];
            [_faceBoxs addObject:[CALayer layer]];
        }
        CALayer *layer = _faceBoxs[i];
        layer.bounds = f.bounds;
        layer.hidden = NO;
        /*
         CGRect bounds;
         BOOL hasLeftEyePosition;
         CGPoint leftEyePosition;
         BOOL hasRightEyePosition;
         CGPoint rightEyePosition;
         BOOL hasMouthPosition;
         CGPoint mouthPosition;

         BOOL hasTrackingID;
         int trackingID;
         BOOL hasTrackingFrameCount;
         int trackingFrameCount;

         BOOL hasFaceAngle;
         float faceAngle;

         BOOL hasSmile;
         BOOL leftEyeClosed;
         BOOL rightEyeClosed;
         */
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _previewLayer.frame = self.bounds;
    _videoPreviewView.transform = CGAffineTransformMakeRotation(M_PI_2);
    _videoPreviewView.frame = self.bounds;
    _thumbnailLayer.bounds = CGRectMake(0, 0, 60, 90);
    _thumbnailLayer.position = self.center;
}

- (void)stopRunning {
    [_session stopRunning];
}

- (void)startRunning {
    [_session startRunning];
}


@end
