//
//  MYAlbum.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYAsset;
@class PHAssetCollection;
@class PHFetchResult;

NS_ASSUME_NONNULL_BEGIN

@interface MYAlbum : NSObject

/// 相册图片集合
@property (nonatomic, strong, nullable) PHFetchResult *results;
/// 相册标识符
@property (nonatomic, copy, nullable) NSString *identifier;
/// 相册标题
@property (nonatomic, copy, nullable) NSString *name;
/// 相册图片数量
@property (nonatomic, assign) NSInteger count;
/// 是否为相机胶卷
@property (nonatomic, assign) BOOL isCameraRoll;
/// 解析完成的图片结构体
@property (nonatomic, strong) NSArray<MYAsset *> *models;

/// 设置相册元数据，是否需要解析相册数据
- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets;
/// 设置相册元数据，是否需要解析相册数据，过滤指定数据源
- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets allowPickingImage:(BOOL)allowPickingImage allowPickingVideo:(BOOL)allowPickingVideo;
///加载相册资源
- (void)startFetchAssetWithAllowPickingImage:(BOOL)allowPickingImage allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^_Nullable)(NSArray<MYAsset *> *models))completion;

@end

NS_ASSUME_NONNULL_END
