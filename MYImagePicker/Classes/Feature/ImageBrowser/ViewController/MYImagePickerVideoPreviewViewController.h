//
//  MYImagePickerVideoPreviewViewController.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/25.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;

@interface MYImagePickerVideoPreviewViewController : MYImagePickerBaseViewController

@property (nonatomic, strong) MYAsset *model;
@property (nonatomic, copy) void (^doneButtonClick)(MYAsset *asset, UIImage *cover, UIButton *sender);

@end

NS_ASSUME_NONNULL_END
