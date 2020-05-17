//
//  UIView+MYImagePickerCrop.m
//  TYImagePicker
//
//  Created by Lawrence on 2020/5/15.
//  Copyright © 2020 MYImagePicker. All rights reserved.
//

#import "UIView+MYImagePickerCrop.h"

@implementation UIView (MYImagePickerCrop)

/// 裁剪框背景的处理
+ (void)my_overlayClippingWithView:(UIView *)view
                          cropRect:(CGRect)cropRect
                     containerView:(UIView *)containerView
                    needCircleCrop:(BOOL)needCircleCrop {
    UIBezierPath *path= [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    CAShapeLayer *layer = [CAShapeLayer layer];
    if (needCircleCrop) { // 圆形裁剪框
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:containerView.center radius:cropRect.size.width / 2 startAngle:0 endAngle: 2 * M_PI clockwise:NO]];
    } else { // 矩形裁剪框
        [path appendPath:[UIBezierPath bezierPathWithRect:cropRect]];
    }
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor blackColor] CGColor];
    layer.opacity = 0.5;
    [view.layer addSublayer:layer];
}

@end
