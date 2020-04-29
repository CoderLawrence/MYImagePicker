//
//  MYAsset.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MYImagePickerDefine.h"

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface MYAsset : NSObject

/// 媒体资源类型
@property (nonatomic, assign) MYAssetModelMediaType mediaType;
/// 图片资源标识符
@property (nonatomic, copy) NSString *assetIdentifier;
/// 图片资源数据
@property (nonatomic, readonly) PHAsset *asset;
/// 获取到的图片
@property (nonatomic, strong, nullable) UIImage *assetImage;
/// 是否已经选中图片
@property (nonatomic, assign) BOOL isSelected;
/// 视频时长
@property (nonatomic, copy) NSString *timeLength;
/// 视频时长
@property (nonatomic, assign) NSTimeInterval videoTime;

/// 初始化
+ (MYAsset *)assetWithPHAsset:(PHAsset *)asset
                    mediaType:(MYAssetModelMediaType)mediaType;
/// 初始化
+ (MYAsset *)assetWithPHAsset:(PHAsset *)asset
                    mediaType:(MYAssetModelMediaType)mediaType
                   timeLength:(NSString *)timeLength;

@end

NS_ASSUME_NONNULL_END
