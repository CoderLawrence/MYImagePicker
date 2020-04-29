//
//  MYImagePickerPreNavigationBar.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImagePickerPreNavigationBar : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *nextButton;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
