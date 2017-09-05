//
//  ViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "IUCollectionViewCell.h"
#import "IUViewController.h"
#import "YYBaseViewController.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *filterNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configFilterNames];
}

//MARK:--- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ~~~~
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _filterNames.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IUCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iu_cell" forIndexPath:indexPath];
    cell.filterName = _filterNames[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *className = [NSString stringWithFormat:@"%@ViewController", _filterNames[indexPath.item]];
    Class vc_class = NSClassFromString(className);
    if (vc_class) {
        YYBaseViewController *vc = (YYBaseViewController *)[[vc_class alloc] init];
        vc.filterName = _filterNames[indexPath.item];
        [self showViewController:vc sender:nil];
    } else {
        IUViewController *vc = [[UIStoryboard storyboardWithName:@"IUViewController" bundle:nil] instantiateInitialViewController];
        [self showViewController:vc sender:nil];
    }
    
}

- (void)configFilterNames {
    _filterNames = @[
    @"CIAdditionCompositing",
    @"CIAffineClamp",
    @"CIAffineTile",
    @"CIAffineTransform",
    @"CIBarsSwipeTransition",
    @"CIBlendWithAlphaMask",
    @"CIBlendWithMask",
    @"CIBloom",
    @"CIBumpDistortion",
    @"CIBumpDistortionLinear",
    @"CICheckerboardGenerator",
    @"CICircleSplashDistortion",
    @"CICircularScreen",
    @"CIColorBlendMode",
    @"CIColorBurnBlendMode",
    @"CIColorClamp",
    @"CIColorControls",
    @"CIColorCrossPolynomial",
    @"CIColorCube",
    @"CIColorCubeWithColorSpace",
    @"CIColorDodgeBlendMode",
    @"CIColorInvert",
    @"CIColorMap",
    @"CIColorMatrix",
    @"CIColorMonochrome",
    @"CIColorPolynomial",
    @"CIColorPosterize",
    @"CIConstantColorGenerator",
    @"CIConvolution3X3",
    @"CIConvolution5X5",
    @"CIConvolution9Horizontal",
    @"CIConvolution9Vertical",
    @"CICopyMachineTransition",
    @"CICrop",
    @"CIDarkenBlendMode",
    @"CIDifferenceBlendMode",
    @"CIDisintegrateWithMaskTransition",
    @"CIDissolveTransition",
    @"CIDotScreen",
    @"CIEightfoldReflectedTile",
    @"CIExclusionBlendMode",
    @"CIExposureAdjust",
    @"CIFalseColor",
    @"CIFlashTransition",
    @"CIFourfoldReflectedTile",
    @"CIFourfoldRotatedTile",
    @"CIFourfoldTranslatedTile",
    @"CIGammaAdjust",
    @"CIGaussianBlur",
    @"CIGaussianGradient",
    @"CIGlideReflectedTile",
    @"CIGloom",
    @"CIHardLightBlendMode",
    @"CIHatchedScreen",
    @"CIHighlightShadowAdjust",
    @"CIHoleDistortion",
    @"CIHueAdjust",
    @"CIHueBlendMode",
    @"CILanczosScaleTransform",
    @"CILightenBlendMode",
    @"CILightTunnel",
    @"CILinearGradient",
    @"CILinearToSRGBToneCurve",
    @"CILineScreen",
    @"CILuminosityBlendMode",
    @"CIMaskToAlpha",
    @"CIMaximumComponent",
    @"CIMaximumCompositing",
    @"CIMinimumComponent",
    @"CIMinimumCompositing",
    @"CIModTransition",
    @"CIMultiplyBlendMode",
    @"CIMultiplyCompositing",
    @"CIOverlayBlendMode",
    @"CIPhotoEffectChrome",
    @"CIPhotoEffectFade",
    @"CIPhotoEffectInstant",
    @"CIPhotoEffectMono",
    @"CIPhotoEffectNoir",
    @"CIPhotoEffectProcess",
    @"CIPhotoEffectTonal",
    @"CIPhotoEffectTransfer",
    @"CIPinchDistortion",
    @"CIPixellate",
    @"CIQRCodeGenerator",
    @"CIRadialGradient",
    @"CIRandomGenerator",
    @"CISaturationBlendMode",
    @"CIScreenBlendMode",
    @"CISepiaTone",
    @"CISharpenLuminance",
    @"CISixfoldReflectedTile",
    @"CISixfoldRotatedTile",
    @"CISmoothLinearGradient",
    @"CISoftLightBlendMode",
    @"CISourceAtopCompositing",
    @"CISourceInCompositing",
    @"CISourceOutCompositing",
    @"CISourceOverCompositing",
    @"CISRGBToneCurveToLinear",
    @"CIStarShineGenerator",
    @"CIStraightenFilter",
    @"CIStripesGenerator",
    @"CISwipeTransition",
    @"CITemperatureAndTint",
    @"CIToneCurve",
    @"CITriangleKaleidoscope",
    @"CITwelvefoldReflectedTile",
    @"CITwirlDistortion",
    @"CIUnsharpMask",
    @"CIVibrance",
    @"CIVignette",
    @"CIVignetteEffect",
    @"CIVortexDistortion",
    @"CIWhitePointAdjust"
    ];
}



@end
