//
//  UIView+MYLayout.h
//  TYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MYOscillatoryAnimationType) {
    MYOscillatoryAnimationToBigger,
    MYOscillatoryAnimationToSmaller,
};

@interface UIView (MYLayout)

@property (nonatomic) CGFloat myp_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat myp_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat myp_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat myp_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat myp_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat myp_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat myp_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat myp_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint myp_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  myp_size;        ///< Shortcut for frame.size.

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(MYOscillatoryAnimationType)type;

@end

NS_ASSUME_NONNULL_END
