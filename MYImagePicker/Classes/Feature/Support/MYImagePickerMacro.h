//
//  MYImagePickerMacro.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/25.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#ifndef MYImagePickerMacro_h
#define MYImagePickerMacro_h

#import <UIKit/UIKit.h>

#define MY_IMG_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);\
})

#define MY_IMG_IPHONE_BOTTOM \
({CGFloat bottom = 0.0;\
if (@available(iOS 11.0, *)) {\
bottom = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;\
}\
(bottom);\
})

#define MY_IMG_Navigation_Top (MY_IMG_IPHONE_X ? 44 : 20)
#define MY_IMG_Navigation_H (MY_IMG_Navigation_Top + 40)

#define MY_IMG_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define MY_IMG_SCREEN_H [UIScreen mainScreen].bounds.size.height

#endif /* MYImagePickerMacro_h */
