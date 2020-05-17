//
//  MYImagePickerConfig.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerConfig.h"

#import "MYImagePickerMacro.h"

NSUInteger const kYTMaxImageCount = 9;

@implementation MYImagePickerConfig

//MARK: - 类方法
+ (instancetype)defaultConfig
{
    MYImagePickerConfig *config = [[MYImagePickerConfig alloc] init];
    return config;
}


+ (instancetype)defaultCropImageConfig
{
    MYImagePickerConfig *config = [[MYImagePickerConfig alloc] init];
    config.maxImagesCount = 1;
    config.allowCrop = YES;
    config.showSelectBtn = NO;
    config.allowPickingVideoAsset = NO;
    NSInteger left = 15;
    NSInteger widthHeight = MY_IMG_SCREEN_W - 2 * left;
    NSInteger top = (MY_IMG_SCREEN_H - widthHeight) / 2;
    config.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    return config;
}

//MARK: - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeout = 15;
        self.photoWidth = 828.0;
        self.photoPreviewMaxWidth = 600;
        self.allowCrop = NO;
        self.allowPreview = YES;
        self.minImagesCount = 1;
        self.maxImagesCount = kYTMaxImageCount;
        self.sortAscendingByModificationDate = NO;
        self.selectedAssets = @[];
        self.onlyReturnAsset = NO;
        self.previewVideoTimeLimit = NO;
        self.allowMinVideoTime = 5;
        self.allowMaxVideoTime = 30;
        self.allowPickingVideoAsset = YES;
        self.showSelectBtn = YES;
    }
    
    return self;
}

- (void)setPhotoPreviewMaxWidth:(CGFloat)photoPreviewMaxWidth {
    _photoPreviewMaxWidth = photoPreviewMaxWidth;
    if (photoPreviewMaxWidth > 800) {
        _photoPreviewMaxWidth = 800;
    } else if (photoPreviewMaxWidth < 500) {
        _photoPreviewMaxWidth = 500;
    }
}

@end
