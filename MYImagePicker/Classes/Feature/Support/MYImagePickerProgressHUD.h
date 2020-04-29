//
//  MYImagePickerProgressHUD.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/29.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImagePickerProgressHUD : UIButton

@property (nonatomic, strong) UILabel *HUDLabel;
@property (nonatomic, assign) CGFloat topMargin;

- (void)showProgressHUD;
- (void)showProgressHUD:(UIView *)forView;
- (void)hidProgressHUD;

@end

NS_ASSUME_NONNULL_END
