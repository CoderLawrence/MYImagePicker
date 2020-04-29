//
//  UIImage+TYBundle.m
//  TYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "UIImage+MYBundle.h"
#import "MYImagePickerManager.h"

static NSArray *my_NSBundlePreferredScales() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    
    return scales;
}

static NSString *myp_NSStringByAppendingNameScale(NSString *string, CGFloat scale) {
    if (!string) return nil;
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}

@implementation UIImage (MYBundle)

+ (NSBundle *)myp_imagePickerBundle
{
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    associateBundleURL = [associateBundleURL URLByAppendingPathComponent:@"MYImagePicker"];
    associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
    NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
    associateBundleURL = [associateBunle URLForResource:@"MYImagePicker" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:associateBundleURL];
    return bundle;
}

+ (UIImage *)myp_imageNamedFromBundle:(NSString *)name
{
    NSString *res = name, *path = nil;
    CGFloat scale = 1;
    NSArray *scales = my_NSBundlePreferredScales();
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = myp_NSStringByAppendingNameScale(res, scale);
        path = [[self myp_imagePickerBundle] pathForResource:scaledName ofType:@"png"];
        if (path) break;
    }
    
    if (!path.length) return nil;
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)myp_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
       
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
       
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
       
    return image;
}

@end
