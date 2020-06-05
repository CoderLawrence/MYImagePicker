//
//  UIView+MYImagePickerCrop.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/5/15.
//  Copyright © 2020 MYImagePicker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MYImagePickerCrop)

/// 裁剪框背景的处理
+ (void)my_overlayClippingWithView:(UIView *)view
                          cropRect:(CGRect)cropRect
                     containerView:(UIView *)containerView
                    needCircleCrop:(BOOL)needCircleCrop;

@end

NS_ASSUME_NONNULL_END
