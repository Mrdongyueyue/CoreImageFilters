//
//  CIGaussianGradientViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIGaussianGradientViewController.h"
@import AVFoundation;
@import GLKit;

@interface CIGaussianGradientViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@implementation CIGaussianGradientViewController {
    CIImage *_ci_image;
    CIFilter *_maskFilter;
    CIFilter *_pixellateFilter;
    AVCaptureDevice *_device;
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_input;
    AVCaptureVideoDataOutput *_output;
    AVCaptureMetadataOutput *_metaOutput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    GLKView *_videoPreviewView;
    EAGLContext *_eag_context;
    CALayer *_faceLayer;
    
    UILabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
//    self.filter = [CIFilter filterWithName:@"CIRadialGradient"];
    [self.filter setValue:[CIColor whiteColor] forKey:@"inputColor0"];
    [self.filter setValue:[CIColor clearColor] forKey:@"inputColor1"];
    
    
    _maskFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    _pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
    [_pixellateFilter setValue:@(30) forKey:kCIInputScaleKey];
    
    [self setAV];
    [self refilter];
    
    _faceLayer = [CALayer layer];
    _faceLayer.borderWidth = 2;
    _faceLayer.borderColor = [UIColor orangeColor].CGColor;
    _faceLayer.backgroundColor = [UIColor clearColor].CGColor;
    _faceLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"tiger"].CGImage);
    _faceLayer.contentsGravity = kCAGravityResizeAspectFill;
    _faceLayer.masksToBounds = YES;
    [self.view.layer addSublayer:_faceLayer];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 414, 20)];
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    [self.view addSubview:_label];
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
    
    _metaOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t meta_queue = dispatch_queue_create("meta_output_queue", DISPATCH_QUEUE_SERIAL);
    [_metaOutput setMetadataObjectsDelegate:self queue:meta_queue];
    
    _output = [[AVCaptureVideoDataOutput alloc] init];
    dispatch_queue_t video_queue = dispatch_queue_create("video_output_queue", DISPATCH_QUEUE_SERIAL);
    [_output setSampleBufferDelegate:self queue:video_queue];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_metaOutput]) {
        [_session addOutput:_metaOutput];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    _metaOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_previewLayer];
    
    [_session startRunning];
    
    _eag_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _videoPreviewView = [[GLKView alloc] initWithFrame:CGRectZero context:_eag_context];
//    [self.view addSubview:_videoPreviewView];
    
    self.context = [CIContext contextWithEAGLContext:_eag_context];
    
}

- (void)refilter {
    
    [self setOutputImage:_ci_image.extent];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _previewLayer.frame = self.view.bounds;
    _videoPreviewView.transform = CGAffineTransformMakeRotation(M_PI_2);
    _videoPreviewView.frame = self.view.bounds;
}

//MARK:~~~~ AVCaptureMetadataOutputObjectsDelegate ~~~~
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!metadataObjects.count) {
        return;
    }
    
    AVMetadataFaceObject *obj = metadataObjects.lastObject;
    if (![obj isKindOfClass:[AVMetadataFaceObject class]]) {
        return;
    }
    CGSize v_size = _previewLayer.bounds.size;
    CGRect f_bounds = obj.bounds;
    CGPoint position = CGPointMake(v_size.width * (1 - f_bounds.origin.y - f_bounds.size.height / 2), v_size.height * (f_bounds.origin.x + f_bounds.size.width / 2));

    CGFloat radius = obj.bounds.size.width * _previewLayer.bounds.size.height;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _faceLayer.bounds = CGRectMake(0, 0, radius, radius);
        _faceLayer.position = position;
        NSLog(@"%@", NSStringFromCGPoint(_faceLayer.position));
    });
    
//    CGPoint point = position;
//    CGSize imageSize = (CGSize){1080, 1920};
//    CGSize viewSize = v_size;
//    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
//    point = CGPointApplyAffineTransform(point, transform);
//    CGFloat scaleX = 1;//MAX(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
//    CGFloat scaleY = 1;//MIN(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
//    point.x = point.x * scaleX;
//    point.y = (imageSize.height + point.y * scaleY);
//
//    CIVector *center = [CIVector vectorWithX:point.x Y:point.y];
//
//    [self.filter setValue:center forKey:kCIInputCenterKey];
//    [_pixellateFilter setValue:center forKey:kCIInputCenterKey];
    [self.filter setValue:@(radius * [UIScreen mainScreen].scale) forKey:@"inputRadius"];
    
    
}

//MARK:~~~~ AVCaptureVideoDataOutputSampleBufferDelegate ~~~~
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    return;
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage *image = [CIImage imageWithCVImageBuffer:buffer];
    
    [_pixellateFilter setValue:image forKey:kCIInputImageKey];
    CIImage *pixelImage = _pixellateFilter.outputImage;
    
//    [self.filter setValue:image forKey:kCIInputImageKey];
    CIImage *outputImage = [self.filter.outputImage imageByCroppingToRect:image.extent];
    
    [_maskFilter setValue:pixelImage forKey:kCIInputImageKey];
    [_maskFilter setValue:image forKey:kCIInputBackgroundImageKey];
    [_maskFilter setValue:outputImage forKey:kCIInputMaskImageKey];
    
    CIImage *f_image = _maskFilter.outputImage;
    
    [_videoPreviewView bindDrawable];
    if (_eag_context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:_eag_context];
    }
    
    if (f_image) {
        [self.context drawImage:f_image inRect:CGRectMake(0, 0, _videoPreviewView.drawableWidth, _videoPreviewView.drawableHeight) fromRect:f_image.extent];
        _ci_image = f_image;
    }
    [_videoPreviewView display];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:_videoPreviewView];
    NSLog(@"%@", NSStringFromCGPoint(point));
    CGSize imageSize = (CGSize){1920, 1080};
    CGSize viewSize = self.imageView.bounds.size;
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    point = CGPointApplyAffineTransform(point, transform);
    _label.text = [NSString stringWithFormat:@"x:%f  y:%f",point.x, point.y];
    CGFloat scaleX = MAX(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    CGFloat scaleY = MIN(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    point.x = point.x * scaleX;
    point.y = (imageSize.height + point.y * scaleX);
    
    
    CIVector *center = [CIVector vectorWithX:point.x Y:point.y];
    
    [self.filter setValue:center forKey:kCIInputCenterKey];
    [_pixellateFilter setValue:center forKey:kCIInputCenterKey];
}

@end
