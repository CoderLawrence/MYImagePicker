//
//  MYImagePickerManager.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;
@class MYAlbum;

@class AVAsset;
@class AVAudioMix;

@interface MYImagePickerManager : NSObject

/// Sort photos ascending by modificationDate，Default is YES
/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/// Minimum selectable photo width, Default is 0
/// 最小可选中的图片宽度，默认是0，小于这个宽度的图片不可选中
@property (nonatomic, assign) NSInteger minPhotoWidthSelectable;
@property (nonatomic, assign) NSInteger minPhotoHeightSelectable;
@property (nonatomic, assign) BOOL hideWhenCanNotSelect;

@property (nonatomic, assign) BOOL shouldFixOrientation;

@property (nonatomic, assign) BOOL isPreviewNetworkImage;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
/// The pixel width of output image, Default is 828px / 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

/// Default is 3, Use in photos collectionView in TZPhotoPickerController
/// 默认3列, TZPhotoPickerController中的照片collectionView
@property (nonatomic, assign) NSInteger columnNumber;

/// 单例
+ (instancetype)shared;

/// 禁止初始化
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

///////////////////////////////////////////////////////////////////////////////// 相册获取相关 /////////////////////////////////////////////////////////////////////////////////
///获取所有相册
- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage needFetchAssets:(BOOL)needFetchAssets completion:(void (^)(NSArray<MYAlbum *> *models))completion;

//////////////////////////////////////////////////////////////////////////////// 获取图片相关 //////////////////////////////////////////////////////////////////////////////////
- (void)getAssetsFromFetchResult:(PHFetchResult *)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<MYAsset *> *_Nullable models))completion;
/// 获取封面缩略图
- (PHImageRequestID)getPostImageWithAlbumModel:(MYAlbum *)model completion:(void (^)(UIImage *postImage))completion;
/// 根据设置获取相册图片
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^_Nullable)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
/// 根据宽度获取图片
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^_Nullable)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

- (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;

////////////////////////////////////////////////////////////////////////////// 获取视频相关 ///////////////////////////////////////////////////////////////////////////////////////
- (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem * playerItem, NSDictionary * info))completion;

- (void)getVideoWithAsset:(PHAsset *)asset progressHandler:(void (^_Nullable)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler videoAssetCompletion:(void (^)(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info))completion;

///////////////////////////////////////////////////////////////////////////////// 导出视频 //////////////////////////////////////////////////////////////////////////////////////////
/// Export video 导出视频 presetName: 预设名字，默认值是AVAssetExportPreset640x480
- (void)getVideoOutputPathWithAsset:(PHAsset *)asset success:(void (^)(NSString *outputPath))success failure:(void (^_Nullable)(NSString *errorMessage, NSError *error))failure;
/// Export video 导出视频 presetName: 预设名字，默认值是AVAssetExportPreset640x480
- (void)getVideoOutputPathWithAsset:(PHAsset *)asset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^_Nullable)(NSString *errorMessage, NSError *error))failure;
/// Export video 导出视频 presetName: 预设名字，默认值是AVAssetExportPreset640x480，是否需要修正视频转向
- (void)getVideoOutputPathWithAsset:(PHAsset *)asset needFixComposition:(BOOL)needFixComposition presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^_Nullable)(NSString *errorMessage, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
