//
//  CIAttributedTextImageGeneratorViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/3.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIAttributedTextImageGeneratorViewController.h"

@interface CIAttributedTextImageGeneratorViewController ()

@end

@implementation CIAttributedTextImageGeneratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *text = @"inputText/inputText";
    NSAttributedString *inputText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor orangeColor]}];
    
    [self.filter setValue:inputText forKey:@"inputText"];
    
    [self refilter];
}

- (void)refilter {
    
    NSAttributedString *inputText = [self.filter valueForKey:@"inputText"];
    CGSize size = [inputText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [self setOutputImage:CGRectMake(0, 0, size.width, size.height)];
    
}

@end
