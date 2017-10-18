# CoreImageFilter-demo
---
iOS-CoreImage滤镜开发
---
#### CoreImage的滤镜使用，持续更新
#### 在iOS中要进行滤镜开发大概有3种方式
    1.CoreImage
    2.OpenGL
    3.GPUImage或其他的第三方框架
#### 我在目前的项目中准备使用第一种，即`CoreImage`来进行滤镜开发
#### 首先介绍一下进行滤镜开发所需要熟练掌握的知识和框架
    1.AVFoundtion
    2.CoreImage
    3.Photo或AssetsLibrary
#### 需要了解的
    1.CoreMedia
    2.CoreVideo
    3.图片的特性（对比度、曝光率等）
### AVFoundtion
#### 1.拍摄照片
    1.AVCaptureSession 相机的会话管理类，负责视频图片的管理功能
    2.AVCaptureDeviceInput 图像采集输入设备
    3.AVCaptureStillImageOutput 或 AVCapturePhotoOutput 照片流输出
    4.AVCaptureVideoPreviewLayer 图像预览图层，用于实时呈现摄像头采集景象

#### 2.实时滤镜

### CoreImage
#### 1.CIContext
##### `CIContext`
#### 2.CIFilter
##### 获取滤镜列表 `[CIFilter filterNamesInCategory:category]`获取系列滤镜名的数组
    CICategoryBlur 模糊
    CICategoryColorAdjustment 颜色调整
    CICategoryColorEffect
    CICategoryCompositeOperation
    CICategoryDistortionEffect
    CICategoryGenerator
    CICategoryGeometryAdjustment
    CICategoryGradient
    CICategoryHalftoneEffect
    CICategoryReduction
    CICategorySharpen
    CICategoryStylize
    CICategoryTileEffect 瓦片
    CICategoryTransition 转场，结合GLKView使用

##### 创建滤镜`[CIFilter filterWithName:filterName]`，打印`filter.attributes`可得知该滤镜的作用和所需的参数，以`CIColorMatrix`为例
```
{
    "CIAttributeFilterAvailable_Mac" = "10.4";
    "CIAttributeFilterAvailable_iOS" = 5;
    CIAttributeFilterCategories =     (
        CICategoryColorAdjustment,
        CICategoryVideo,
        CICategoryStillImage,
        CICategoryInterlaced,
        CICategoryNonSquarePixels,
        CICategoryBuiltIn
    );
    CIAttributeFilterDisplayName = "颜色矩阵";
    CIAttributeFilterName = CIColorMatrix;
    CIAttributeReferenceDocumentation = "http://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIColorMatrix";
    inputAVector =     {
        CIAttributeClass = CIVector;
        CIAttributeDefault = "[0 0 0 1]";
        CIAttributeDescription = "用于乘以来源颜色值的 alpha 值。";
        CIAttributeDisplayName = "Alpha 矢量";
        CIAttributeIdentity = "[0 0 0 1]";
    };
    inputBVector =     {
        CIAttributeClass = CIVector;
        CIAttributeDefault = "[0 0 1 0]";
        CIAttributeDescription = "用于乘以源颜色值的蓝色数量。";
        CIAttributeDisplayName = "蓝矢量";
        CIAttributeIdentity = "[0 0 1 0]";
    };
    inputBiasVector =     {
        CIAttributeClass = CIVector;
        CIAttributeDefault = "[0 0 0 0]";
        CIAttributeDescription = "添加到每个颜色分量的矢量。";
        CIAttributeDisplayName = "斜偏矢量";
        CIAttributeIdentity = "[0 0 0 0]";
    };
    inputGVector =     {
        CIAttributeClass = CIVector;
        CIAttributeDefault = "[0 1 0 0]";
        CIAttributeDescription = "用于乘以源颜色值的绿色数量。";
        CIAttributeDisplayName = "绿矢量";
        CIAttributeIdentity = "[0 1 0 0]";
    };
    inputImage =     {
        CIAttributeClass = CIImage;
        CIAttributeDescription = "要用作输入图像的图像。对于也使用了背景图像的滤镜来说，这是前景图像。";
        CIAttributeDisplayName = "图像";
        CIAttributeType = CIAttributeTypeImage;
    };
    inputRVector =     {
        CIAttributeClass = CIVector;
        CIAttributeDefault = "[1 0 0 0]";
        CIAttributeDescription = "用于乘以源颜色值的红色数量。";
        CIAttributeDisplayName = "红矢量";
        CIAttributeIdentity = "[1 0 0 0]";
    };
}
```
##### `CIColorMatrix`滤镜是一个4*5的矩阵，分别RGBA和矢量，其公式为
```
s.r = dot(s, redVector)
s.g = dot(s, greenVector)
s.b = dot(s, blueVector)
s.a = dot(s, alphaVector)
s = s + bias
```
##### 即点乘 表达式为`r = (r * x) + (r * y) + (r * z) + (r * w) + bias`


#### 3.CIVector
#### 4.CIDetector和CIFeature
