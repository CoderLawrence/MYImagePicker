//
//  MYImagePickerCropManager.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/5/15.
//  Copyright © 2020 MYImagePicker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片裁剪工具
@interface MYImagePickerCropManager : NSObject

/// 获得裁剪后的图片
+ (UIImage *)cropImageView:(UIImageView *)imageView
                    toRect:(CGRect)rect
                 zoomScale:(double)zoomScale
             containerView:(UIView *)containerView;

/// 获取圆形图片
+ (UIImage *)circularClipImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
