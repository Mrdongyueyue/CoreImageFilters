//
//  CIColorCrossPolynomialViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/31.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorCrossPolynomialViewController.h"

@interface CIColorCrossPolynomialViewController ()

@end

@implementation CIColorCrossPolynomialViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    //0 r
    //1 g
    //2 b
    //3 r*r
    //4 g*g
    //5 b*b
    //6 r*g
    //7 g*b
    //8 b*r
    //9 +=
    
    const CGFloat redCoefficients[] = {
        1, 0, 0,
        0, 0, 0,
        0, 0, 0,
        0
    };
    const CGFloat greenCoefficients[] = {
        0, 1, 0,
        0, 0, 0,
        0, 0, 0,
        0
    };
    const CGFloat blueCoefficients[] = {
        0, 0, 1,
        0, 0, 0,
        0, 0, 0,
        0
    };
    [self.filter setValue:[CIVector vectorWithValues:redCoefficients count:10] forKey:@"inputRedCoefficients"];
    [self.filter setValue:[CIVector vectorWithValues:greenCoefficients count:10] forKey:@"inputGreenCoefficients"];
    [self.filter setValue:[CIVector vectorWithValues:blueCoefficients count:10] forKey:@"inputBlueCoefficients"];
    
    [self setOutputImage:_image.extent];
}
/*
 out.r = in.r * rC[0] + in.g * rC[1] + in.b * rC[2]
 + in.r * in.r * rC[3] + in.g * in.g * rC[4] + in.b * in.b * rC[5]
 + in.r * in.g * rC[6] + in.g * in.b * rC[7] + in.b * in.r * rC[8]
 + rC[9]
 */


@end
