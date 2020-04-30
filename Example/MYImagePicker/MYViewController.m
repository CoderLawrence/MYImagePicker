//
//  MYViewController.m
//  MYImagePicker
//
//  Created by zengqingsong on 04/29/2020.
//  Copyright (c) 2020 zengqingsong. All rights reserved.
//

#import "MYViewController.h"

#import "MYImagePicker.h"
#import "MYImagePickerManager.h"

@interface MYViewController ()<MYImagePickerDelegate>

@end

@implementation MYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"打开相册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick
{
    MYImagePickerConfig *config = [MYImagePickerConfig defaultConfig];
//    config.allowPickingVideoAsset = NO;
    [[MYImagePicker imagePicker] showImagePicker:self config:config delegate:self];
}

//MARK: - MYImagePickerDelegate
- (void)didCancelSelectImage:(MYImagePickerViewController *)imagePicker
{
    
}

- (void)didSelectedImageWithAssetModels:(NSArray<PHAsset *> *)assets imagePicker:(MYImagePickerViewController *)imagePicker
{
    
}

- (void)didSelectedImageWithAssetModels:(NSArray<PHAsset *> *)assets photos:(NSArray<UIImage *> *)photos imagePicker:(MYImagePickerViewController *)imagePicker
{
    
}

- (void)didSelectedAssetVideo:(PHAsset *)videoAsset coverImage:(UIImage *)coverImage imagePicker:(MYImagePickerViewController *)imagePicker
{
    //导出视频
    [[MYImagePickerManager shared] getVideoOutputPathWithAsset:videoAsset success:^(NSString * _Nonnull outputPath) {
        if ([outputPath length] > 0) {
            
        }
    } failure:^(NSString * _Nonnull errorMessage, NSError * _Nonnull error) {
        
    }];
}

@end
