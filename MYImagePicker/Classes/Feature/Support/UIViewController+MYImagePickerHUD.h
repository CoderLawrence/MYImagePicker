//
//  UIViewController+MYImagePickerHUD.h
//  TYImagePicker
//
//  Created by Lawrence on 2020/4/29.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYImagePickerProgressHUD;

@interface UIViewController (MYImagePickerHUD)

@property (nonatomic, strong) MYImagePickerProgressHUD *myp_progressHUD;
@property (nonatomic, assign) NSTimeInterval myp_HUD_timeout;
@property (nonatomic, assign) NSUInteger myp_HUD_timeoutCount;

/// 显示加载loading
- (void)myp_showProgressHUD;
/// 隐藏加载loading
- (void)myp_hideProgressHUD;

@end

NS_ASSUME_NONNULL_END
