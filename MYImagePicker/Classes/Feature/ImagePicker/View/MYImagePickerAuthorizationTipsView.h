//
//  MYImagePickerAuthorizationTipsView.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/5/13.
//  Copyright © 2020 GZ-Inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImagePickerAuthorizationTipsView : UIView

@property (nonatomic, copy) void (^onSettingButtonClick)(void);

@end

NS_ASSUME_NONNULL_END
