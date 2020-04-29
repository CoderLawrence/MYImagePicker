//
//  MYImagePicker.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/28.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePicker.h"

#import "MYImagePickerConfig.h"

#import "MYImagePickerViewController.h"
#import "MYImagePickerNavigationController.h"

@implementation MYImagePicker

+ (instancetype)imagePicker
{
    MYImagePicker *imagePicker = [[MYImagePicker alloc] init];
    return imagePicker;
}

- (instancetype)init
{
    self = [super init];
    if (self) {}
    return self;
}

- (void)showImagePicker:(UIViewController *)viewController delegate:(id<MYImagePickerDelegate>)delegate
{
    if (viewController == nil) { return; }
    MYImagePickerConfig *config = [MYImagePickerConfig defaultConfig];
    MYImagePickerViewController *imagePickerVC = [[MYImagePickerViewController alloc] initWithConfig:config delegate:delegate];
    MYImagePickerNavigationController *navi = [[MYImagePickerNavigationController alloc] initWithRootViewController:imagePickerVC];
    [viewController presentViewController:navi animated:YES completion:nil];
}

- (void)showImagePicker:(UIViewController *)viewController config:(MYImagePickerConfig *)config delegate:(id<MYImagePickerDelegate>)delegate
{
    if (viewController == nil) { return; }
    MYImagePickerViewController *imagePickerVC = [[MYImagePickerViewController alloc] initWithConfig:config delegate:delegate];
    MYImagePickerNavigationController *navi = [[MYImagePickerNavigationController alloc] initWithRootViewController:imagePickerVC];
    [viewController presentViewController:navi animated:YES completion:nil];
}

@end
