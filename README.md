---
iOS-CoreImage滤镜开发
---
#### 在iOS中要进行滤镜开发大概有3种方式
    1.CoreImage
    2.OpenGL
    3.GPUImage、OpenVC或其他的第三方框架
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
##### `CIColorMatrix`滤镜可以用5个1*4的矩阵表示，分别代表RGBA的矢量和偏移量，其算法为
```
s.r = dot(s, redVector)
s.g = dot(s, greenVector)
s.b = dot(s, blueVector)
s.a = dot(s, alphaVector)
s = s + bias
```
##### 假设 `s`为一个像素的色值，
```
s = [r, g, b, a]
redVector = [x, y, z, w]
bias = [b0, b1, b2, b3]
```
##### 则`r`的表达式为`r = (r * x) + (g * y) + (b * z) + (a * w) + b0`,通过这种方法修改每个像素的色值
##### 要设计一款滤镜并不容易，我在GitHub上找到了一个有多个滤镜的demo：[wangyingbo](https://github.com/wangyingbo)所开源的[YBPasterImage](https://github.com/wangyingbo/YBPasterImage)中，有十三款色彩滤镜[ColorMatrix.h](https://github.com/wangyingbo/YBPasterImage/blob/master/testPasterImage/Libs/FilterImageLibs/ColorMatrix.h)，以第一个为例
```
// 1、LOMO
const float colormatrix_lomo[] = {
    1.7f,  0.1f,   0.1f,   0,    -73.1f,
    0,     1.7f,   0.1f,   0,    -73.1f,
    0,     0.1f,   1.6f,   0,    -73.1f,
    0,     0,      0,      1.0f, 0
  };
```
|  x  |  y  |  z  |  w  |  bias  |
|-----|:---:|:---:|:---:|:------:|
| 1.7 | 0.1 | 0.1 |  0  |  -73.1 |
|  0  | 1.7 | 0.1 |  0  |  -73.1 |
|  0  | 0.1 | 1.6 |  0  |  -73.1 |
|  0  |  0  |  0  | 1.0 |   0    |

##### 作者[wangyingbo](https://github.com/wangyingbo)是使用`OpenGL`所实现的效果（[代码](https://github.com/wangyingbo/YBPasterImage/blob/master/testPasterImage/Libs/FilterImageLibs/ImageUtil.m)），而非`CoreImage`，使用`CoreImage`来实现只需做如下的修改：
```
// 1、LOMO
colormatrix_lomo = @{
  @"style":@"LOMO",
  @"r":[CIVector vectorWithX:1.7 Y:0.1 Z:0.1 W:0],
  @"g":[CIVector vectorWithX:0 Y:1.7 Z:0.1 W:0],
  @"b":[CIVector vectorWithX:0 Y:0.1 Z:1.6 W:0],
  @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
  @"bias":[CIVector vectorWithX:-73.1/255 Y:-73.1/255 Z:-73.1/255 W:0]
}

[self.filter setValue:colormatrix_lomo[@"r"] forKey:@"inputRVector"];
[self.filter setValue:colormatrix_lomo[@"g"] forKey:@"inputGVector"];
[self.filter setValue:colormatrix_lomo[@"b"] forKey:@"inputBVector"];
[self.filter setValue:colormatrix_lomo[@"a"] forKey:@"inputAVector"];
[self.filter setValue:colormatrix_lomo[@"bias"] forKey:@"inputBiasVector"];
```

#### 3.　`CIVector`，向量对象，有如下的构造方法：
```
+ (instancetype)vectorWithValues:(const CGFloat *)values count:(size_t)count;

+ (instancetype)vectorWithX:(CGFloat)x;
+ (instancetype)vectorWithX:(CGFloat)x Y:(CGFloat)y;
+ (instancetype)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
+ (instancetype)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z W:(CGFloat)w;

/* the CGPoint x and y values are stored in the first X and Y values of the CIVector. */
+ (instancetype)vectorWithCGPoint:(CGPoint)p NS_AVAILABLE(10_9, 5_0);

/* the CGRect x, y, width, height values are stored in the first X, Y, Z, W values of the CIVector. */
+ (instancetype)vectorWithCGRect:(CGRect)r NS_AVAILABLE(10_9, 5_0);

/* the CGAffineTransform's six values are stored in the first six values of the CIVector. */
+ (instancetype)vectorWithCGAffineTransform:(CGAffineTransform)t NS_AVAILABLE(10_9, 5_0);

+ (instancetype)vectorWithString:(NSString *)representation;
```
##### 在图片处理的众多方法中，会常常使用到矩阵的概念，而矩阵在C语言中可用数组表达，在`CoreImage`中苹果提供了`CIVector`这样一个类来表示矩阵

#### 4.CIDetector和CIFeature
