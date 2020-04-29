//
//  MYImagePicker.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/28.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class MYImagePickerConfig;
@class MYImagePickerViewController;

@protocol MYImagePickerDelegate <NSObject>

@optional
/// 取消图片选择
- (void)didCancelSelectImage:(MYImagePickerViewController *)imagePicker;
/// 完成图片选择，如果配置只是返回原始数据走此回调
- (void)didSelectedImageWithAssetModels:(NSArray<PHAsset *> *)assets
                            imagePicker:(MYImagePickerViewController *)imagePicker;
/// 完成图片选择，如果是配置了只返回原始数据则不走此回调
- (void)didSelectedImageWithAssetModels:(NSArray<PHAsset *> *)assets
                                 photos:(NSArray<UIImage *> *)photos
                            imagePicker:(MYImagePickerViewController *)imagePicker;
/// 完成视频选择
- (void)didSelectedAssetVideo:(PHAsset *)videoAsset
                   coverImage:(UIImage *)coverImage
                  imagePicker:(MYImagePickerViewController *)imagePicker;

@end

@interface MYImagePicker : NSObject

+ (instancetype)imagePicker;

/// 使用默认相册配置打开相册
- (void)showImagePicker:(UIViewController *)viewController delegate:(id<MYImagePickerDelegate>)delegate;
/// 使用指定配置打开相册
- (void)showImagePicker:(UIViewController *)viewController config:(MYImagePickerConfig *)config delegate:(id<MYImagePickerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
