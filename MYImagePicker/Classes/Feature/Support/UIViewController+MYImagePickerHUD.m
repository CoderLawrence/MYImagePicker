//
//  UIViewController+MYImagePickerHUD.m
//  TYImagePicker
//
//  Created by Lawrence on 2020/4/29.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "UIViewController+MYImagePickerHUD.h"
#import <objc/Runtime.h>

#import "MYImagePickerMacro.h"
#import "UIView+MYLayout.h"
#import "MYImagePickerProgressHUD.h"

@implementation UIViewController (MYImagePickerHUD)

- (void)setMyp_HUD_timeout:(NSTimeInterval)typ_HUD_timeout
{
    objc_setAssociatedObject(self,
                             @selector(myp_HUD_timeout),
                             @(typ_HUD_timeout),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimeInterval)myp_HUD_timeout
{
    return [objc_getAssociatedObject(self, @selector(myp_HUD_timeout)) doubleValue];
}

- (void)setMyp_HUD_timeoutCount:(NSUInteger)typ_HUD_timeoutCount
{
    objc_setAssociatedObject(self,
                             @selector(myp_HUD_timeoutCount),
                             @(typ_HUD_timeoutCount),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)myp_HUD_timeoutCount
{
    return [objc_getAssociatedObject(self, @selector(myp_HUD_timeoutCount)) unsignedIntegerValue];
}

- (void)setMyp_progressHUD:(MYImagePickerProgressHUD *)typ_progressHUD
{
    objc_setAssociatedObject(self,
                             @selector(myp_progressHUD),
                             typ_progressHUD,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYImagePickerProgressHUD *)myp_progressHUD
{
    return objc_getAssociatedObject(self, @selector(myp_progressHUD));
}

- (void)myp_showProgressHUD
{
    if (self.myp_progressHUD == nil) {
        CGRect frame = CGRectMake(0, 0, self.view.myp_width, self.view.myp_height);
        MYImagePickerProgressHUD *progressHUD = [[MYImagePickerProgressHUD alloc] initWithFrame:frame];
        [progressHUD.HUDLabel setText:@"正在处理..."];
        progressHUD.topMargin = MY_IMG_Navigation_H;
        self.myp_progressHUD = progressHUD;
    }
    
    [self.myp_progressHUD showProgressHUD];
    
    self.myp_HUD_timeoutCount++;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.myp_HUD_timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.myp_HUD_timeoutCount--;
        if (strongSelf.myp_HUD_timeoutCount <= 0) {
            strongSelf.myp_HUD_timeoutCount = 0;
            [strongSelf myp_hideProgressHUD];
        }
    });
}

- (void)myp_hideProgressHUD
{
    if (self.myp_progressHUD != nil) {
        [self.myp_progressHUD hidProgressHUD];
    }
}

@end
