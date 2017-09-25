//
//  CIBarsSwipeTransitionViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIBarsSwipeTransitionViewController.h"
@import GLKit;

@interface CIBarsSwipeTransitionViewController ()<GLKViewDelegate>

@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) CIImage *image1;
@property (nonatomic, strong) CIImage *image2;
@property (nonatomic, strong) CIImage *maskImage;
@property (nonatomic, strong) CIVector *extent;
@property (nonatomic, strong) CIFilter *transition;
@property (nonatomic, strong) CIContext *myContext;
@property (nonatomic, assign) NSTimer *timer;

@end

@implementation CIBarsSwipeTransitionViewController {
    NSTimeInterval  base;
    CGRect destRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *uiImage1 = [UIImage imageNamed:@"IU1"];
    UIImage *uiImage2 = [UIImage imageNamed:@"IU4-1"];
    
    self.image1 = [CIImage imageWithCGImage:uiImage1.CGImage];
    self.image2 = [CIImage imageWithCGImage:uiImage2.CGImage];
    
    self.extent = [CIVector vectorWithX:0
                                      Y:0
                                      Z:uiImage1.size.width
                                      W:uiImage2.size.height];
    
    base = [NSDate timeIntervalSinceReferenceDate];
    
    self.glkView = [[GLKView alloc] initWithFrame:self.view.bounds];
    self.glkView.delegate = self;
    self.glkView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [self.view addSubview:self.glkView];
    
    self.myContext = [CIContext contextWithEAGLContext:self.glkView.context];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat w = self.glkView.frame.size.width * scale;
    CGFloat h = w * (uiImage1.size.height / uiImage1.size.width);
    destRect = CGRectMake(0, 64, w, h);
    
    self.transition = [CIFilter filterWithName: self.filterName];
    
    CIImage *b_inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU1"].CGImage];
    CIImage *t_inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU4-1"].CGImage];
    
    [self.transition setValue:t_inputImage forKey:kCIInputTargetImageKey];
    [self.transition setValue:@(0.5) forKey:kCIInputTimeKey];
    [self.transition setValue:b_inputImage forKey:kCIInputImageKey];
    [self.transition setValue:@(M_PI_2) forKey:kCIInputAngleKey];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 30.0
                                                  target:self
                                                selector:@selector(onTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (void)viewWillLayoutSubviews {
    
    self.glkView.frame = self.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Private

- (CIImage *)imageForTransitionAtTime:(float)time {
    // toggle images
    if (fmodf(time, 2.0) < 1.0f)
    {
        [self.transition setValue:self.image1 forKey:kCIInputImageKey];
        [self.transition setValue:self.image2 forKey:kCIInputTargetImageKey];
    }
    else
    {
        [self.transition setValue:self.image2 forKey:kCIInputImageKey];
        [self.transition setValue:self.image1 forKey:kCIInputTargetImageKey];
    }
    
    CGFloat transitionTime = 0.5 * (1 - cos(fmodf(time, 1.0f) * M_PI));
    [self.transition setValue:@(transitionTime) forKey:kCIInputTimeKey];
    
    return self.transition.outputImage;
}




// =============================================================================
#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        float t = 0.4 * ([NSDate timeIntervalSinceReferenceDate] - base);
        
        CIImage *image = [self imageForTransitionAtTime:t];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myContext drawImage:image
                               inRect:destRect
                             fromRect:image.extent];
        });
    });
}


// =============================================================================
#pragma mark - Timer Handler

- (void)onTimer:(NSTimer *)timer {
    
    [self.glkView setNeedsDisplay];
}

@end
