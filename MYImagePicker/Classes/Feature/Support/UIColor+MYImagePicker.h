//
//  UIColor+TYImagePicker.h
//  TYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MYHexColor(a) [UIColor myp_colorWithHexNumber:a]

@interface UIColor (MYImagePicker)

+ (UIColor *)myp_hexStringColor:(NSString *)strColor;
+ (UIColor *)myp_colorWithHexNumber:(NSUInteger)hexColor;

@end

NS_ASSUME_NONNULL_END
