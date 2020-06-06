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
FOUNDATION_EXPORT NSUInteger const kMYPMaxImageCount;

@interface MYImagePickerConfig : NSObject

/// 默认为YES，如果设置为NO,预览按钮将隐藏,用户将不能去预览照片
@property (nonatomic, assign) BOOL allowPreview;

///  默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

/// 最小照片必选张数,默认是0
@property (nonatomic, assign) NSInteger minImagesCount;

/// 预览视频时长限制，默认为NO
@property (nonatomic, assign) BOOL previewVideoTimeLimit;
/// 允许预览视频的最小时长，默认为5秒，单位为秒
@property (nonatomic, assign) NSTimeInterval allowMinVideoTime;
/// 允许预览视频的最长时长，默认为30秒，单位为秒
@property (nonatomic, assign) NSTimeInterval allowMaxVideoTime;

/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/// 导出图片的宽度，默认828像素宽，你需要同时设置photoPreviewMaxWidth的值
@property (nonatomic, assign) CGFloat photoWidth;

/// 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

/// 超时时间，默认为15秒，当取图片时间超过15秒还没有取成功时，会自动dismiss HUD；
@property (nonatomic, assign) NSInteger timeout;

/// 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
/// 已经选择的图片集合
@property (nonatomic, strong) NSArray<PHAsset *> *selectedAssets;
/// 默认为NO，如果设置为YES，代理方法里photos和infos会是nil，只返回assets
@property (nonatomic, assign) BOOL onlyReturnAsset;
/// 是否允许同时选择图片和视频，默认为YES，如果设置为NO，视频选择卡片不显示
@property (nonatomic, assign) BOOL allowPickingVideoAsset;
/// 是否显示图片选择列表选择按钮，默认YES
@property (nonatomic, assign) BOOL showSelectBtn;

/// 是否图片等比缩放填充cropRect区域
@property (nonatomic, assign) BOOL scaleAspectFillCrop;
/// 允许裁剪,默认为NO
@property (nonatomic, assign) BOOL allowCrop;
/// 裁剪框的尺寸
@property (nonatomic, assign) CGRect cropRect;
/// 需要圆角裁剪框
@property (nonatomic, assign) BOOL needCircleCrop;
/// 圆角裁剪框半径大小
@property (nonatomic, assign) NSInteger circleCropRadius;

/// 默认配置
+ (instancetype)defaultConfig;
/// 默认裁剪图片配置，只能选择一张图片
+ (instancetype)defaultCropImageConfig;

@end

NS_ASSUME_NONNULL_END
