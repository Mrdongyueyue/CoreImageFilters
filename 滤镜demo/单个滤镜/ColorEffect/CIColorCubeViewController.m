//
//  CIColorCubeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/13.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorCubeViewController.h"

@interface CIColorCubeViewController ()

@end

@implementation CIColorCubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refilter];
}

- (void)refilter {
    
    UIImage *image = [self clipWithImageRect:CGRectMake(0, 0, 640, 640) clipImage:self.imageView.image];
    
    
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    NSInteger n = 64;
    
    size_t rowNum = height / n;
    size_t columnNum = width / n;
    
    //檢查圖片大小，必須是n個n*n的正方形，所以長跟寬都必須是n的倍數
    if ((width % n != 0) || (height % n != 0) || (rowNum * columnNum != n))
    {
        NSLog(@"Invalid colorLUT");
//        return;
    }
    
    //要讀取每個pixel的RGBA值，必須先把UIImage轉成bitmap
    unsigned char *bitmap = [self createRGBABitmapFromImage:image.CGImage];
    
    if (bitmap == NULL)
    {
        return;
    }
    
    //將每個pixel的RGBA值填入data中
    //圖片由n個正方形構成，每個正方形代表不同Z值的XY平面
    //正方形內每個pixel的X值有左至右遞增，Y值由上至下遞增
    //而每個正方形所代表的Z值由左至右、由上而下遞增
    unsigned long size = n * n * n * sizeof(float) * 4;
    float *data = malloc(size);
    int bitmapOffest = 0;
    int z = 0;
    for (int row = 0; row <  rowNum; row++)
    {
        for (int y = 0; y < n; y++)
        {
            int tmp = z;
            for (int col = 0; col < columnNum; col++)
            {
                for (int x = 0; x < n; x++) {
                    float r = (unsigned int)bitmap[bitmapOffest];
                    float g = (unsigned int)bitmap[bitmapOffest + 1];
                    float b = (unsigned int)bitmap[bitmapOffest + 2];
                    float a = (unsigned int)bitmap[bitmapOffest + 3];
                    
                    long dataOffset = (z*n*n + y*n + x) * 4;
                    
                    data[dataOffset] = r / 255.0;
                    data[dataOffset + 1] = g / 255.0;
                    data[dataOffset + 2] = b / 255.0;
                    data[dataOffset + 3] = a / 255.0;
                    
                    bitmapOffest += 4;
                }
                z++;
            }
            z = tmp;
        }
        z += columnNum;
    }
    
    free(bitmap);
    
    //產生一個CIColorCube，並且將data包裝成NSData設進CIColorCube中
    CIFilter *filter = [CIFilter filterWithName:self.filterName];
    [filter setValue:[NSData dataWithBytesNoCopy:data length:size freeWhenDone:YES] forKey:@"inputCubeData"];
    [filter setValue:[NSNumber numberWithInteger:n] forKey:@"inputCubeDimension"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    //取得處理後的圖片，不過此時還沒真的處理，先取得outputImage稍後使用
    CIImage *outputImage = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    
    //此時才真的產生處理之後的圖片
    UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
    self.imageView.image = newImage;
}

- (unsigned char *)createRGBABitmapFromImage:(CGImageRef)image
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned char *bitmap;
    int bitmapSize;
    int bytesPerRow;
    
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
    
    return  newImage;
    
}


@end
