//
//  MYImagePickerBaseViewController.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerBaseViewController.h"

@interface MYImagePickerBaseViewController ()

@end

@implementation MYImagePickerBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[self class] needNavigationBarHidden]) {
        [self.navigationController.navigationBar setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([[self class] needNavigationBarHidden]) {
        [self.navigationController.navigationBar setHidden:NO];
    }
}

- (void)onBackButtonClick
{
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

+ (BOOL)needNavigationBarHidden
{
    return NO;
}

@end
