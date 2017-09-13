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
#import "FPCameraBase.h"
#import <TuSDK/TuSDK.h>
#import "GeeV2Sample.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TuSDKFilterManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *filterNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configFilterNames];
    
    
}

- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager {
    
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
//        [[GeeV2Sample sample] showSampleWithController:self];
        IUViewController *vc = [[IUViewController alloc] init];
//        YYBaseViewController *vc = [[YYBaseViewController alloc] init];
//        vc.filterName = _filterNames[indexPath.item];
        [self showViewController:vc sender:nil];
    }
    
}

/*
 CIAreaAverage       - 返回一个单像素图像，其中包含一块颜色区内的平均颜色。
 CIAreaMaximum       - 返回一个单像素图像，其中包含一块颜色区内最大的颜色成分。
 CIAreaMaximumAlpha    - 返回一个单像素图像，其中包含颜色区中最大透明度的颜色矢量。
 CIAreaMinimum       - 返回一个单像素图像，其中包含颜色区中最小颜色成分。
 CIAreaMinimumAlpha    - 返回一个单像素图像，其中包含颜色区内的最小透明度的颜色矢量。
 CIBoxBlur          - 在一个矩形内使得图像模糊化。
 CICircularWrap       - 用一个透明的圆圈环绕图像。
 CICMYKHalftone       - 创建一个颜色，使得源图像呈半色调，在白色页面中使用使用青色，品红色，黄色和墨色。
 CIColumnAverage       - 返回一个高为1像素的图像，包含每个扫描列的平均颜色。
 CIComicEffect        - 像漫画书一样勾勒（图像）边缘，并应用半色调效果。
 CIConvolution7X7      - 用一个7x7旋转矩阵来调整像素值。
 CICrystallize        - 通过汇集源像素的颜色值，创建多边形色块。
 CIDepthOfField        - 模拟一个场景深入的效果。
 CIDiscBlur          - 在一个圆盘形状内模糊化图像。
 CIDisplacementDistortion  - 将第二图像的灰度值应用到第一图像。
 CIDroste             - 用类似M.C.埃舍尔绘图方式递归地绘制图像的一部分。
 CIEdges              - 用颜色显示图像的边缘。
 CIEdgeWork            - 产生一个黑白风格的类似木块切口的图像。
 CIGlassLozenge         - 创建一个菱形滤镜，并扭曲滤镜位置的图像。
 CIHeightFieldFromMask     - 产生一个连续的三维物体，一个阁楼形的灰场。
 CIHexagonalPixellate      - 用所替换的像素映射彩色六边形的图像。
 CIKaleidoscope          - 从源图像中通过将12路对称，产生一个五颜六色的图象。
 CILenticularHaloGenerator   - 模拟闪光灯效果。
 CILineOverlay           - 创建草图，用黑色勾勒出图像的边缘。
 CIMedianFilter           - 计算一组邻近像素的平均数，然后用平均数替代每个像素的值。
 CINoiseReduction          - 通过降低噪声的限定值来降低噪音。
 CIOpTile               - 先分割图像，施加一些指定的缩放和旋转，然后拼接图像，形成的艺术化的表现。
 CIPageCurlTransition       - 使用翻页效果从一个图像转换到另一个图像，翻卷后显示新的图像。
 CIPageCurlWithShadowTransition  - 使用翻页效果从一个图像转换到另一个图像，翻卷后显示新的图像。
 CIParallelogramTile         - 展示一个在平行四边形内的图像。
 CIPassThroughColor
 CIPassThroughGeom
 CIPDF417BarcodeGenerator
 CIPointillize              - 呈现一个pointillistic风格的源图像。
 CIRippleTransition          - 图像创建一个圆形波从中心点向外扩大，在波形里显示新图像。
 CIRowAverage              - 返回1个像素高的图像，其中包含每行扫描的平均颜色。
 CIShadedMaterial            - 从一个高度场产生一个阴影图像。
 CISpotColor               - 用色点替换颜色范围。
 CISpotLight               - 图像使用一个方向聚光灯效果呈现。
 CIStretchCrop              - 图像通过拉伸和或裁剪以适合目标尺寸。
 CISunbeamsGenerator          - 图像呈现阳光照射的效果。
 CITorusLensDistortion         - 创建环形滤镜，并扭曲透镜位置的图像。
 CITriangleTile
 */

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
