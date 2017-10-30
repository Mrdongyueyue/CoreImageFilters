//
//  CIColorCubeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/13.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorCubeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#import "FPCameraView.h"

@interface CIColorCubeViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@implementation CIColorCubeViewController {
    CIImage *_ci_image;
    AVCaptureDevice *_device;
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_input;
    AVCaptureVideoDataOutput *_output;
    AVCaptureVideoPreviewLayer *_previewLayer;
    GLKView *_videoPreviewView;
    EAGLContext *_eag_context;
    CIImage *_backgroundImage;
}

void rgbToHSV(float *rgb, float *hsv);

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"minHueAngle",
                           @"max":@"360",
                           @"min":@"0",
                           @"v":@"60",
                           },
                       @{
                           @"name":@"maxHueAngle",
                           @"max":@"360",
                           @"min":@"0",
                           @"v":@"150",
                           }
                       ];
    
    [self transitionModels:array];
    
    [self refilter];
    [self rotaBackgroundImage];
    [self setAV];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _previewLayer.frame = self.view.bounds;
    _videoPreviewView.transform = CGAffineTransformMakeRotation(M_PI_2);
    _videoPreviewView.frame = self.view.bounds;
}

- (void)rotaBackgroundImage {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    UIImage *image = [UIImage imageNamed:@"flower_background"];
    rotate = M_PI_2;
    rect = CGRectMake(0, 0, image.size.height, image.size.width);
    translateX = 0;
    translateY = -rect.size.width;
    scaleY = rect.size.width/rect.size.height;
    scaleX = rect.size.height/rect.size.width;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    _backgroundImage = [CIImage imageWithCGImage:newPic.CGImage];
    
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
    
    _output = [[AVCaptureVideoDataOutput alloc] init];
    dispatch_queue_t video_queue = dispatch_queue_create("video_output_queue", DISPATCH_QUEUE_SERIAL);
    [_output setSampleBufferDelegate:self queue:video_queue];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_previewLayer];
    
    [_session startRunning];
    
    _eag_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _videoPreviewView = [[GLKView alloc] initWithFrame:CGRectZero context:_eag_context];
    [self.view addSubview:_videoPreviewView];
    self.context = [CIContext contextWithEAGLContext:_eag_context];
    
}

//MARK:~~~~ AVCaptureVideoDataOutputSampleBufferDelegate ~~~~
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage *c_image = [CIImage imageWithCVImageBuffer:buffer];
    
    
    [_videoPreviewView bindDrawable];
    if (_eag_context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:_eag_context];
    }
    
    CIImage *compositing = [self cubeImageFrom:c_image];
    if (compositing) {
        
        [self.context drawImage:compositing inRect:CGRectMake(0, 0, _videoPreviewView.drawableWidth, _videoPreviewView.drawableHeight) fromRect:_backgroundImage.extent];
        
    }
    [_videoPreviewView display];
    
}

- (void)refilter {
    
    UIImage *image = [UIImage imageNamed:@"flower"];
    unsigned char *bitmap = [self createRGBABitmapFromImage:image.CGImage];
    
    if (bitmap == NULL)
    {
        return;
    }
    free(bitmap);
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    CIImage *outputImage = [self cubeImageFrom:[[CIImage alloc] initWithImage:image]];
    UIImage * newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
    
    self.imageView.image = newImage;
}

- (CIImage *)cubeImageFrom:(CIImage *)image {
    
    //將每個pixel的RGBA值填入data中
    //圖片由n個正方形構成，每個正方形代表不同Z值的XY平面
    //正方形內每個pixel的X值有左至右遞增，Y值由上至下遞增
    //而每個正方形所代表的Z值由左至右、由上而下遞增
    CGFloat minHueAngle = self.filterAttributeModels.firstObject.value;
    CGFloat maxHueAngle = self.filterAttributeModels.lastObject.value;
    const unsigned int size = 64;
    NSUInteger cubeDataSize = size * size * size * sizeof (float) * 4;
    float *cubeData = (float *)malloc(size * size * size * sizeof(float) * 4);
    float rgb[3], hsv[3], *c = cubeData;
    [UIColor colorWithRed:0.67f green:0.67f blue:0.66f alpha:1.00f];
    
    // Populate cube with a simple gradient going from 0 to 1
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // Red value
                // Convert RGB to HSV
                // You can find publicly available rgbToHSV functions on the Internet
                rgbToHSV(rgb, hsv);
                // Use the hue value to determine which to make transparent
                // The minimum and maximum hue angle depends on
                // the color you want to remove
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f: 1.0f;
                // Calculate premultiplied alpha values for the cube
                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                c += 4; // advance our pointer into memory for the next color value
            }
        }
    }
    // Put the table in a data object and create the filter
    NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                        length:cubeDataSize
                                  freeWhenDone:YES];
    
    //產生一個CIColorCube，並且將data包裝成NSData設進CIColorCube中
    CIFilter *filter = [CIFilter filterWithName:self.filterName];
    [filter setValue:data forKey:@"inputCubeData"];
    [filter setValue:@(size) forKey:@"inputCubeDimension"];
    
    [filter setValue:image forKey:kCIInputImageKey];
    
    //取得處理後的圖片，不過此時還沒真的處理，先取得outputImage稍後使用
    CIImage *outputImage = filter.outputImage;
    
    CIFilter *sourceOverCompositing = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositing setValue:outputImage forKey:kCIInputImageKey];
    [sourceOverCompositing setValue:_backgroundImage forKey:kCIInputBackgroundImageKey];
    return sourceOverCompositing.outputImage;
}

- (unsigned char *)createRGBABitmapFromImage:(CGImageRef)image
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned char *bitmap;
    size_t bitmapSize;
    size_t bytesPerRow;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    bytesPerRow   = (width * 4);
    bitmapSize     = (bytesPerRow * height);
    
    bitmap = malloc( bitmapSize );
    if (bitmap == NULL)
    {
        return NULL;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        free(bitmap);
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmap,
                                     width,
                                     height,
                                     8,
                                     bytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease( colorSpace );
    
    if (context == NULL)
    {
        free (bitmap);
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    return bitmap;
}

- (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;

{
    
    UIGraphicsBeginImageContext(clipRect.size);
    
    [clipImage drawInRect:CGRectMake(0,0,clipRect.size.width,clipRect.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

void rgbToHSV(float *rgb, float *hsv) {
    float min, max, delta;
    float r = rgb[0], g = rgb[1], b = rgb[2];
    float *h = hsv, *s = hsv + 1, *v = hsv + 2;
    
    min = fmin(fmin(r, g), b );
    max = fmax(fmax(r, g), b );
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h = 2 + ( b - r ) / delta;
    else
        *h = 4 + ( r - g ) / delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}


@end
