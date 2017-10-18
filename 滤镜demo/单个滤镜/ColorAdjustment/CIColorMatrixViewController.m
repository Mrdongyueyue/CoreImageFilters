//
//  CIColorMatrixViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorMatrixViewController.h"
#import <Masonry.h>

@interface CIColorMatrixViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIColorMatrixViewController {
    NSArray *_templateFilters;
    UIScrollView *_scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];

    [self setOptions];
    [self refilter];
    [self createSubviews];
}

- (void)refilter {
    
    CIVector *r = [CIVector vectorWithX:self.filterAttributeModels[0].value
                                      Y:self.filterAttributeModels[1].value
                                      Z:self.filterAttributeModels[2].value
                                      W:self.filterAttributeModels[3].value];
    CIVector *g = [CIVector vectorWithX:self.filterAttributeModels[4].value
                                      Y:self.filterAttributeModels[5].value
                                      Z:self.filterAttributeModels[6].value
                                      W:self.filterAttributeModels[7].value];
    CIVector *b = [CIVector vectorWithX:self.filterAttributeModels[8].value
                                      Y:self.filterAttributeModels[9].value
                                      Z:self.filterAttributeModels[10].value
                                      W:self.filterAttributeModels[11].value];
    CIVector *a = [CIVector vectorWithX:self.filterAttributeModels[12].value
                                      Y:self.filterAttributeModels[13].value
                                      Z:self.filterAttributeModels[14].value
                                      W:self.filterAttributeModels[15].value];
    CIVector *bias = [CIVector vectorWithX:self.filterAttributeModels[16].value
                                         Y:self.filterAttributeModels[17].value
                                         Z:self.filterAttributeModels[18].value
                                         W:self.filterAttributeModels[19].value];
    
    [self.filter setValue:r forKey:@"inputRVector"];
    [self.filter setValue:g forKey:@"inputGVector"];
    [self.filter setValue:b forKey:@"inputBVector"];
    [self.filter setValue:a forKey:@"inputAVector"];
    [self.filter setValue:bias forKey:@"inputBiasVector"];
    
    [self setOutputImage:_ci_image.extent];
}

- (void)createSubviews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(100);
    }];
    
    _templateFilters = [self templateFilters];
    UIButton *last = nil;
    for (NSInteger i = 0; i < _templateFilters.count; i ++) {
        NSDictionary *d = _templateFilters[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:d[@"style"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        button.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95].CGColor;
        button.layer.borderWidth = 2;
        button.layer.masksToBounds = YES;
        button.tag = i;
        [button addTarget:self action:@selector(templateFilterClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.leading.top.trailing.width.equalTo(_scrollView);
                make.height.mas_equalTo(25);
            } else {
                make.leading.height.width.equalTo(last);
                make.top.equalTo(last.mas_bottom).offset(10);
                if (i == _templateFilters.count - 1) {
                    make.bottom.equalTo(_scrollView);
                }
            }
        }];
        last = button;
    }
}

- (void)templateFilterClick:(UIButton *)button {
    NSDictionary *d = _templateFilters[button.tag];
    [self.filter setValue:d[@"r"] forKey:@"inputRVector"];
    [self.filter setValue:d[@"g"] forKey:@"inputGVector"];
    [self.filter setValue:d[@"b"] forKey:@"inputBVector"];
    [self.filter setValue:d[@"a"] forKey:@"inputAVector"];
    [self.filter setValue:d[@"x"] forKey:@"inputBiasVector"];
    
    [self setOutputImage:_ci_image.extent];
}

/*
 dot(a,b) 矩阵相乘函数
 s.r = dot(s, rVector)
 s.g = dot(s, gVector)
 s.b = dot(s, bVector)
 s.a = dot(s, aVector)
 s = s + bias
 */

- (void)setOptions {
    
    NSArray *array = @[
                       //R
                       @{
                           @"name":@"R_0",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"R_1",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"R_2",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"R_3",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       //G
                       @{
                           @"name":@"G_0",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"G_1",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"G_2",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"G_3",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       //B
                       @{
                           @"name":@"B_0",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"B_1",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"B_2",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"G_3",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       //A
                       @{
                           @"name":@"A_0",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"A_1",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"A_2",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"A_3",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"1",
                           },
                       //Bias
                       @{
                           @"name":@"Bias_0",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"Bias_1",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"Bias_2",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"Bias_3",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       ];
    
    [self transitionModels:array];
}

- (NSArray *)templateFilters {
    //from https://github.com/wangyingbo/YBPasterImage/blob/master/testPasterImage/Libs/FilterImageLibs/ColorMatrix.h
    // 1、LOMO
    NSDictionary *colormatrix_lomo = @{
                                       @"style":@"LOMO",
                                       @"r":[CIVector vectorWithX:1.7 Y:0.1 Z:0.1 W:0],
                                       @"g":[CIVector vectorWithX:0 Y:1.7 Z:0.1 W:0],
                                       @"b":[CIVector vectorWithX:0 Y:0.1 Z:1.6 W:0],
                                       @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                       @"x":[CIVector vectorWithX:-73.1/255 Y:-73.1/255 Z:-73.1/255 W:0]
                                       };
    // 2、黑白
    NSDictionary *colormatrix_heibai = @{
                                         @"style":@"黑白",
                                         @"r":[CIVector vectorWithX:0.8 Y:1.6 Z:0.2 W:0],
                                         @"g":[CIVector vectorWithX:0.8 Y:1.6 Z:0.2 W:0],
                                         @"b":[CIVector vectorWithX:0.8 Y:1.6 Z:0.2 W:0],
                                         @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                         @"x":[CIVector vectorWithX:-163.9/255 Y:-163.9/255 Z:-163.9/255 W:0]
                                         };
    // 3、复古
    NSDictionary *colormatrix_huajiu = @{
                                         @"style":@"复古",
                                         @"r":[CIVector vectorWithX:0.2 Y:0.5 Z:0.1 W:0],
                                         @"g":[CIVector vectorWithX:0.2 Y:0.5 Z:0.1 W:0],
                                         @"b":[CIVector vectorWithX:0.2 Y:0.5 Z:0.1 W:0],
                                         @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                         @"x":[CIVector vectorWithX:40.8/255 Y:40.8/255 Z:40.8/255 W:0]
                                         };
    
    // 4、哥特
    NSDictionary *colormatrix_gete = @{
                                       @"style":@"哥特",
                                       @"r":[CIVector vectorWithX:1.9 Y:-0.3 Z:-0.2 W:0],
                                       @"g":[CIVector vectorWithX:-0.2 Y:1.7 Z:-0.1 W:0],
                                       @"b":[CIVector vectorWithX:-0.1 Y:-0.6 Z:2.0 W:0],
                                       @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                       @"x":[CIVector vectorWithX:-87.0/255 Y:-87.0/255 Z:-87.0/255 W:0]
                                       };
    
    // 5、锐化
    NSDictionary *colormatrix_ruise = @{
                                        @"style":@"锐化",
                                        @"r":[CIVector vectorWithX:4.8 Y:-1.0 Z:-0.1 W:0],
                                        @"g":[CIVector vectorWithX:-0.5 Y:4.4 Z:-0.1 W:0],
                                        @"b":[CIVector vectorWithX:-0.5 Y:-1.0 Z:5.2 W:0],
                                        @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                        @"x":[CIVector vectorWithX:-388.4/255 Y:-388.4/255 Z:-388.4/255 W:0]
                                        };
    
    // 6、淡雅
    NSDictionary *colormatrix_danya = @{
                                        @"style":@"淡雅",
                                        @"r":[CIVector vectorWithX:0.6 Y:0.3 Z:0.1 W:0],
                                        @"g":[CIVector vectorWithX:0.2 Y:0.7 Z:0.1 W:0],
                                        @"b":[CIVector vectorWithX:0.2 Y:0.3 Z:0.4 W:0],
                                        @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                        @"x":[CIVector vectorWithX:73.3/255 Y:73.3/255 Z:73.3/255 W:0]
                                        };
    
    // 7、酒红
    NSDictionary *colormatrix_jiuhong = @{
                                          @"style":@"酒红",
                                          @"r":[CIVector vectorWithX:1.2 Y:0 Z:0 W:0],
                                          @"g":[CIVector vectorWithX:0 Y:0.9 Z:0 W:0],
                                          @"b":[CIVector vectorWithX:0 Y:0 Z:0.8 W:0],
                                          @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                          @"x":[CIVector vectorWithX:0 Y:0 Z:0 W:0]
                                          };
    
    // 8、清宁
    NSDictionary *colormatrix_qingning = @{
                                           @"style":@"清宁",
                                           @"r":[CIVector vectorWithX:0.9 Y:0 Z:0 W:0],
                                           @"g":[CIVector vectorWithX:0 Y:1.1 Z:0 W:0],
                                           @"b":[CIVector vectorWithX:0 Y:0 Z:0.9 W:0],
                                           @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                           @"x":[CIVector vectorWithX:0 Y:0 Z:0 W:0]
                                           };
    
    // 9、浪漫
    NSDictionary *colormatrix_langman = @{
                                          @"style":@"浪漫",
                                          @"r":[CIVector vectorWithX:0.9 Y:0 Z:0 W:0],
                                          @"g":[CIVector vectorWithX:0 Y:0.9 Z:0 W:0],
                                          @"b":[CIVector vectorWithX:0 Y:0 Z:0.9 W:0],
                                          @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                          @"x":[CIVector vectorWithX:63.0/255 Y:63.0/255 Z:63.0/255 W:0]
                                          };
    
    // 10、
    NSDictionary *colormatrix_guangyun = @{
                                           @"style":@"光晕",
                                           @"r":[CIVector vectorWithX:0.9 Y:0 Z:0 W:0],
                                           @"g":[CIVector vectorWithX:0 Y:0.9 Z:0 W:0],
                                           @"b":[CIVector vectorWithX:0 Y:0 Z:0.9 W:0],
                                           @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                           @"x":[CIVector vectorWithX:64.9/255 Y:64.9/255 Z:64.9/255 W:0]
                                           };
    
    // 11、
    NSDictionary *colormatrix_landiao = @{
                                          @"style":@"蓝调",
                                          @"r":[CIVector vectorWithX:2.1 Y:-1.4 Z:0.6 W:0],
                                          @"g":[CIVector vectorWithX:-0.3 Y:2.0 Z:-0.3 W:0],
                                          @"b":[CIVector vectorWithX:-1.1 Y:-0.2 Z:2.6 W:0],
                                          @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                          @"x":[CIVector vectorWithX:-31.0/255 Y:-31.0/255 Z:-31.0/255 W:0]
                                          };
    
    // 12、
    NSDictionary *colormatrix_menghuan = @{
                                           @"style":@"梦幻",
                                           @"r":[CIVector vectorWithX:0.8 Y:0.3 Z:0.1 W:0],
                                           @"g":[CIVector vectorWithX:0.1 Y:0.9 Z:0 W:0],
                                           @"b":[CIVector vectorWithX:0.1 Y:0.3 Z:0.7 W:0],
                                           @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                           @"x":[CIVector vectorWithX:46.5/255 Y:46.5/255 Z:46.5/255 W:0]
                                           };
    
    // 13、夜色
    NSDictionary *colormatrix_yese = @{
                                       @"style":@"夜色",
                                       @"r":[CIVector vectorWithX:1.0 Y:0 Z:0 W:0],
                                       @"g":[CIVector vectorWithX:0 Y:1.1 Z:0 W:0],
                                       @"b":[CIVector vectorWithX:0 Y:0 Z:1.0 W:0],
                                       @"a":[CIVector vectorWithX:0 Y:0 Z:0 W:1.0],
                                       @"x":[CIVector vectorWithX:-66.6/255 Y:-66.6/255 Z:-66.6/255 W:0]
                                       };
    
    return @[
             colormatrix_lomo,
             colormatrix_heibai,
             colormatrix_huajiu,
             colormatrix_gete,
             colormatrix_ruise,
             colormatrix_danya,
             colormatrix_jiuhong,
             colormatrix_qingning,
             colormatrix_langman,
             colormatrix_guangyun,
             colormatrix_landiao,
             colormatrix_menghuan,
             colormatrix_yese
             ];
    
}

@end
