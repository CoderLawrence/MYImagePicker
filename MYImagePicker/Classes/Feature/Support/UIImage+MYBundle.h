//
//  UIImage+TYBundle.h
//  TYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MYBundle)

+ (NSBundle *)myp_imagePickerBundle;
+ (UIImage *_Nullable)myp_imageNamedFromBundle:(NSString *)name;

+ (UIImage *)myp_imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
