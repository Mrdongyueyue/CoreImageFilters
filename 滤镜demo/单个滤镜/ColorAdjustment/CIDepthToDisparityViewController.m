//
//  CIDepthToDisparityViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

@import GLKit;
@import AVFoundation;
@import Photos;
#import "YYPreviewView.h"
#import "CIDepthToDisparityViewController.h"
#import <Masonry.h>

@interface CIDepthToDisparityViewController ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) CIImage *ci_image;

//@property (nonatomic, weak) AVCamPreviewView *previewView;
//@property (nonatomic, weak) UISegmentedControl *captureModeControl;

//@property (nonatomic) AVCamSetupResult setupResult;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) YYPreviewView *previewView;
//// Device configuration.
//@property (nonatomic, weak) UIButton *cameraButton;
//@property (nonatomic, weak) UILabel *cameraUnavailableLabel;
@property (nonatomic) AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession;

// Capturing photos.
//@property (nonatomic, weak) UIButton *photoButton;
//@property (nonatomic, weak) UIButton *livePhotoModeButton;
//@property (nonatomic) AVCamLivePhotoMode livePhotoMode;
//@property (nonatomic, weak) UILabel *capturingLivePhotoLabel;
//@property (nonatomic, weak) UIButton *depthDataDeliveryButton;
//@property (nonatomic) AVCamDepthDataDeliveryMode depthDataDeliveryMode;

@property (nonatomic) AVCapturePhotoOutput *photoOutput;
//@property (nonatomic) NSMutableDictionary<NSNumber *, AVCamPhotoCaptureDelegate *> *inProgressPhotoCaptureDelegates;
@property (nonatomic) NSInteger inProgressLivePhotoCapturesCount;


@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;

@property (nonatomic) NSData *photoData;
@property (nonatomic) NSURL *livePhotoCompanionMovieURL;
@property (nonatomic) AVCapturePhotoSettings *requestedPhotoSettings;
@end

@implementation CIDepthToDisparityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    self.session = [[AVCaptureSession alloc] init];
    
    // Create a device discovery session.
    NSArray<AVCaptureDeviceType> *deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDualCamera];
    self.videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    
    // Set up the preview view.
    self.previewView = [[YYPreviewView alloc] init];
    [self.view addSubview:self.previewView];
    self.previewView.session = self.session;
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Communicate with the session and other session objects on this queue.
    self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
    
    dispatch_async( self.sessionQueue, ^{
        [self configureSession];
    } );
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async( self.sessionQueue, ^{
        [self.session startRunning];
        self.sessionRunning = self.session.isRunning;
    } );
}

- (void)viewDidDisappear:(BOOL)animated
{
    dispatch_async( self.sessionQueue, ^{
        [self.session stopRunning];
    } );
    
    [super viewDidDisappear:animated];
}

- (void)configureSession {
    
    NSError *error = nil;
    
    [self.session beginConfiguration];
    
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    if ( ! videoDevice ) {
        // If the back dual camera is not available, default to the back wide angle camera.
        videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        
        // In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
        if ( ! videoDevice ) {
            videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        }
    }
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if ( ! videoDeviceInput ) {
        NSLog( @"Could not create video device input: %@", error );
        [self.session commitConfiguration];
        return;
    }
    if ( [self.session canAddInput:videoDeviceInput] ) {
        [self.session addInput:videoDeviceInput];
        self.videoDeviceInput = videoDeviceInput;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
            AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
            if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
                initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
            }
            
            self.previewView.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation;
        } );
    }
    else {
        NSLog( @"Could not add video device input to the session" );
        [self.session commitConfiguration];
        return;
    }
    
    // Add audio input.
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if ( ! audioDeviceInput ) {
        NSLog( @"Could not create audio device input: %@", error );
    }
    if ( [self.session canAddInput:audioDeviceInput] ) {
        [self.session addInput:audioDeviceInput];
    }
    else {
        NSLog( @"Could not add audio device input to the session" );
    }
    
    // Add photo output.
    AVCapturePhotoOutput *photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ( [self.session canAddOutput:photoOutput] ) {
        [self.session addOutput:photoOutput];
        self.photoOutput = photoOutput;
        
        self.photoOutput.highResolutionCaptureEnabled = YES;
        self.photoOutput.livePhotoCaptureEnabled = self.photoOutput.livePhotoCaptureSupported;
        self.photoOutput.depthDataDeliveryEnabled = self.photoOutput.depthDataDeliverySupported;
        
        
        self.inProgressLivePhotoCapturesCount = 0;
    }
    else {
        NSLog( @"Could not add photo output to the session" );
        [self.session commitConfiguration];
        return;
    }
    
    self.backgroundRecordingID = UIBackgroundTaskInvalid;
    
    [self.session commitConfiguration];
}

- (void)refilter {
    [self setOutputImage:_ci_image.extent];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AVCaptureVideoOrientation videoPreviewLayerVideoOrientation = self.previewView.videoPreviewLayer.connection.videoOrientation;
    
    dispatch_async( self.sessionQueue, ^{
        
        // Update the photo output's connection to match the video orientation of the video preview layer.
        AVCaptureConnection *photoOutputConnection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
        photoOutputConnection.videoOrientation = videoPreviewLayerVideoOrientation;
        
        AVCapturePhotoSettings *photoSettings;
        // Capture HEIF photo when supported, with flash set to auto and high resolution photo enabled.
        if ( [self.photoOutput.availablePhotoCodecTypes containsObject:AVVideoCodecTypeHEVC] ) {
            photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{ AVVideoCodecKey : AVVideoCodecTypeHEVC }];
        }
        else {
            photoSettings = [AVCapturePhotoSettings photoSettings];
        }
        
        if ( self.videoDeviceInput.device.isFlashAvailable ) {
            photoSettings.flashMode = AVCaptureFlashModeAuto;
        }
        photoSettings.highResolutionPhotoEnabled = YES;
        if ( photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 ) {
            photoSettings.previewPhotoFormat = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : photoSettings.availablePreviewPhotoPixelFormatTypes.firstObject };
        }
        
        if (self.photoOutput.isDepthDataDeliverySupported ) {
            photoSettings.depthDataDeliveryEnabled = YES;
        } else {
            photoSettings.depthDataDeliveryEnabled = NO;
        }
        
//        self.inProgressPhotoCaptureDelegates[@(photoCaptureDelegate.requestedPhotoSettings.uniqueID)] = photoCaptureDelegate;
        self.requestedPhotoSettings = photoSettings;
        [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
    } );
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput willBeginCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings
{
    if ( ( resolvedSettings.livePhotoMovieDimensions.width > 0 ) && ( resolvedSettings.livePhotoMovieDimensions.height > 0 ) ) {
        
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput willCapturePhotoForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings
{
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error
{
    if ( error != nil ) {
        NSLog( @"Error capturing photo: %@", error );
        return;
    }
    self.photoData = [photo fileDataRepresentation];
    
//    [self.filter setValue:photo.metadata forKey:@"inputAuxDataMetadata"];
//    [self.filter setValue:photo.depthData.cameraCalibrationData forKey:@"inputCalibrationData"];
    [self.filter setValue:[CIImage imageWithCVPixelBuffer:photo.depthData.depthDataMap] forKey:@"inputImage"];
//    [self refilter];
    CIImage *outp = self.filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *disparityToDepth = [CIFilter filterWithName:@"DisparityToDepth"];
    [disparityToDepth setValue:outp forKey:kCIInputImageKey];
    CGImageRef cg_image = [context createCGImage:outp fromRect:outp.extent];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = [UIImage imageWithCGImage:cg_image];
        CGImageRelease(cg_image);
    });
    self.previewView.hidden = YES;
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishRecordingLivePhotoMovieForEventualFileAtURL:(NSURL *)outputFileURL resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings
{
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingLivePhotoToMovieFileAtURL:(NSURL *)outputFileURL duration:(CMTime)duration photoDisplayTime:(CMTime)photoDisplayTime resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(NSError *)error
{
    if ( error != nil ) {
        NSLog( @"Error processing live photo companion movie: %@", error );
        return;
    }
    
    self.livePhotoCompanionMovieURL = outputFileURL;
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(NSError *)error
{
    if ( error != nil ) {
        NSLog( @"Error capturing photo: %@", error );
        return;
    }
    
    if ( self.photoData == nil ) {
        NSLog( @"No photo data resource" );
        return;
    }
    
//    [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
//        if ( status == PHAuthorizationStatusAuthorized ) {
//            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
//                options.uniformTypeIdentifier = self.requestedPhotoSettings.processedFileType;
//                PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
//                [creationRequest addResourceWithType:PHAssetResourceTypePhoto data:self.photoData options:options];
//
//                if ( self.livePhotoCompanionMovieURL ) {
//                    PHAssetResourceCreationOptions *livePhotoCompanionMovieResourceOptions = [[PHAssetResourceCreationOptions alloc] init];
//                    livePhotoCompanionMovieResourceOptions.shouldMoveFile = YES;
//                    [creationRequest addResourceWithType:PHAssetResourceTypePairedVideo fileURL:self.livePhotoCompanionMovieURL options:livePhotoCompanionMovieResourceOptions];
//                }
//            } completionHandler:^( BOOL success, NSError * _Nullable error ) {
//                if ( ! success ) {
//                    NSLog( @"Error occurred while saving photo to photo library: %@", error );
//                }
//
//            }];
//        }
//        else {
//            NSLog( @"Not authorized to save photo" );
//        }
//    }];
}


@end
