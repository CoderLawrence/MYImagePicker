//
//  MYImagePickerNavigationBar.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImagePickerNavigationBar : UIView

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *nextButton;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
