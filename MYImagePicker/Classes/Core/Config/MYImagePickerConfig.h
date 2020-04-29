//
//  MYImagePickerConfig.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

/// 默认选择图片最大数，默认9张图片
FOUNDATION_EXPORT NSUInteger const kYTMaxImageCount;

@interface MYImagePickerConfig : NSObject

/// Default is YES, if set NO, user can't preview photo.
/// 默认为YES，如果设置为NO,预览按钮将隐藏,用户将不能去预览照片
@property (nonatomic, assign) BOOL allowPreview;

/// Default is 9 / 默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

/// The minimum count photos user must pick, Default is 0
/// 最小照片必选张数,默认是0
@property (nonatomic, assign) NSInteger minImagesCount;

/// 预览视频时长限制，默认为NO
@property (nonatomic, assign) BOOL previewVideoTimeLimit;
/// 允许预览视频的最小时长，默认为5秒，单位为秒
@property (nonatomic, assign) NSTimeInterval allowMinVideoTime;
/// 允许预览视频的最长时长，默认为30秒，单位为秒
@property (nonatomic, assign) NSTimeInterval allowMaxVideoTime;

/// Sort photos ascending by modificationDate，Default is YES
/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/// The pixel width of output image, Default is 828px，you need to set photoPreviewMaxWidth at the same time
/// 导出图片的宽度，默认828像素宽，你需要同时设置photoPreviewMaxWidth的值
@property (nonatomic, assign) CGFloat photoWidth;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

/// Default is 15, While fetching photo, HUD will dismiss automatic if timeout;
/// 超时时间，默认为15秒，当取图片时间超过15秒还没有取成功时，会自动dismiss HUD；
@property (nonatomic, assign) NSInteger timeout;

/// Default is YES, if set NO, the original photo button will hide. user can't picking original photo.
/// 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
/// 已经选择的图片集合
@property (nonatomic, strong) NSArray<PHAsset *> *selectedAssets;
/// 默认为NO，如果设置为YES，代理方法里photos和infos会是nil，只返回assets
@property (nonatomic, assign) BOOL onlyReturnAsset;

/// 默认配置
+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
