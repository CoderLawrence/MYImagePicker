//
//  MYImagePickerCropImageViewController.h
//  Pods
//
//  Created by Lawrence on 2020/5/17.
//

#import "MYImagePickerBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;
@class MYImagePickerViewController;

@interface MYImagePickerCropImageViewController : MYImagePickerBaseViewController

/// 相册容器视图
@property (nonatomic, weak) MYImagePickerViewController *imagePickerVC;
/// 相册数据源
@property (nonatomic, strong) MYAsset *model;
/// 允许裁剪,默认为YES
@property (nonatomic, assign) BOOL allowCrop;
// 裁剪框的尺寸
@property (nonatomic, assign) CGRect cropRect;
/// 需要圆角裁剪框
@property (nonatomic, assign) BOOL needCircleCrop;
/// 圆角裁剪框半径大小
@property (nonatomic, assign) NSInteger circleCropRadius;
/// 是否图片等比缩放填充cropRect区域
@property (nonatomic, assign) BOOL scaleAspectFillCrop;
/// 裁剪回调
@property (nonatomic, copy) void (^doneButtonClickBlockCropMode)(UIImage *cropedImage, id asset);

- (instancetype)initWithModel:(MYAsset *)model;

@end

NS_ASSUME_NONNULL_END
