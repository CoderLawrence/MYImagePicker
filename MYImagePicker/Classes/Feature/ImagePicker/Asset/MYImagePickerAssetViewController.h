//
//  MYImagePickerAssetViewController.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/22.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MYAlbum;
@class MYImagePickerViewController;

@interface MYImagePickerAssetViewController : MYImagePickerBaseViewController

@property (nonatomic, strong, readonly) MYAlbum *albumModel;
@property (nonatomic, weak) MYImagePickerViewController *assetPickerVC;

/// 设置相册数据
- (void)setAlbumModel:(MYAlbum *)albumModel;

@end

NS_ASSUME_NONNULL_END
