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
#import "IUCollectionViewHeader.h"
#import "IUViewController.h"
#import "YYBaseViewController.h"
#import "FPCameraBase.h"
#import <TuSDK/TuSDK.h>
#import "GeeV2Sample.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TuSDKFilterManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *categorys;
@property (nonatomic, strong) NSMutableArray<NSArray *> *filterNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configFilterNames];
    
    
}

- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager {
    
}

//MARK:--- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ~~~~
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _filterNames.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _filterNames[section].count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return nil;
    }
    IUCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"iu_header" forIndexPath:indexPath];
    header.categoryName = _categorys[indexPath.section];
    return header;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IUCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iu_cell" forIndexPath:indexPath];
    cell.filterName = _filterNames[indexPath.section][indexPath.item];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = [NSString stringWithFormat:@"%@ViewController", _filterNames[indexPath.section][indexPath.item]];
    Class vc_class = NSClassFromString(className);
    if (vc_class) {
        return YES;
    } else {
        return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *className = [NSString stringWithFormat:@"%@ViewController", _filterNames[indexPath.section][indexPath.item]];
    Class vc_class = NSClassFromString(className);
    YYBaseViewController *vc = (YYBaseViewController *)[[vc_class alloc] init];
    vc.filterName = _filterNames[indexPath.section][indexPath.item];
    [self showViewController:vc sender:nil];
}

- (void)configFilterNames {
    _categorys = @[
                           @"CICategoryBlur",
                           @"CICategoryColorAdjustment",
                           @"CICategoryColorEffect",
                           @"CICategoryCompositeOperation",
                           @"CICategoryDistortionEffect",
                           @"CICategoryGenerator",
                           @"CICategoryGeometryAdjustment",
                           @"CICategoryGradient",
                           @"CICategoryHalftoneEffect",
                           @"CICategoryReduction",
                           @"CICategorySharpen",
                           @"CICategoryStylize",
                           @"CICategoryTileEffect",
                           @"CICategoryTransition",
                           ];
    _filterNames = [NSMutableArray array];
    for (NSString *c in _categorys) {
        [_filterNames addObject:[CIFilter filterNamesInCategory:c]];
    }
}





@end
