//
//  MYImagePickerManager+Helper.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/22.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerManager.h"
#import "MYAsset.h"

@class PHAsset;
@class PHAssetCollection;

NS_ASSUME_NONNULL_BEGIN

@interface MYImagePickerManager (Helper)

/// 检查照片大小是否满足最小要求
- (BOOL)isPhotoSelectableWithAsset:(PHAsset *)asset;
- (BOOL)isCameraRollAlbum:(PHAssetCollection *)metadata;
- (MYAssetModelMediaType)getAssetType:(PHAsset *)asset;

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration;

/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage;
/// 缩放图片至新尺寸
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

/// 判断asset是否是视频
- (BOOL)isVideo:(PHAsset *)asset;

/// 获取优化后的视频转向信息
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset;

@end

NS_ASSUME_NONNULL_END
