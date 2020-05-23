//
//  MYImagePickerCropImageViewController.m
//  Pods
//
//  Created by Lawrence on 2020/5/17.
//

#import "MYImagePickerCropImageViewController.h"

#import "MYAsset.h"

#import "MYImagePickerConfig.h"

#import "MYImagePickerMacro.h"
#import "UIView+MYLayout.h"
#import "UIColor+MYImagePicker.h"
#import "UIView+MYImagePickerCrop.h"
#import "UIViewController+MYImagePickerHUD.h"

#import "MYImagePickerCropManager.h"

#import "MYImagePickerPhotoPreviewView.h"
#import "MYImagePickerViewController.h"

@interface MYImagePickerCropImageViewController ()

@property (nonatomic, strong) UIView *cropView;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confimButton;
@property (nonatomic, strong) MYImagePickerPhotoPreviewView *previewView;

@end

@implementation MYImagePickerCropImageViewController

@synthesize cropRect = _cropRect;

//MARK: - 生命周期
- (instancetype)initWithModel:(MYAsset *)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.previewView.frame = self.view.bounds;
    CGFloat btnY =  MY_IMG_SCREEN_H - 15 - MY_IMG_IPHONE_BOTTOM - 32;
    CGRect cancelBtnFrame = CGRectMake(15, btnY, 60, 32);
    self.cancelButton.frame =cancelBtnFrame;
    CGRect confrimBtnFrame = CGRectMake(MY_IMG_SCREEN_W - 15 - 60, btnY, 60, 32);
    self.confimButton.frame = confrimBtnFrame;
    [self configCropView];
}

//MARK: - getter && setter
- (UIView *)cropView
{
    if (_cropView == nil) {
        _cropView = [[UIView alloc] init];
        [_cropView setBackgroundColor:[UIColor clearColor]];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0f;
        [_cropView setUserInteractionEnabled:NO];
    }
    
    return _cropView;
}

- (UIView *)cropBgView
{
    if (_cropBgView == nil) {
        _cropBgView = [[UIView alloc] init];
        [_cropBgView setUserInteractionEnabled:NO];
        [_cropBgView setBackgroundColor:[UIColor clearColor]];
    }
    
    return _cropBgView;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton addTarget:self action:@selector(onBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:18]];
        [_cancelButton setTitleColor:MYHexColor(0xffffff) forState:UIControlStateNormal];
    }
    
    return _cancelButton;
}

- (UIButton *)confimButton
{
    if (_confimButton == nil) {
        _confimButton = [[UIButton alloc] init];
        [_confimButton addTarget:self action:@selector(onConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_confimButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confimButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:18]];
        [_confimButton setTitleColor:MYHexColor(0xffffff) forState:UIControlStateNormal];
    }
    
    return _confimButton;
}

- (CGRect)cropRect
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    BOOL isFullScreen = self.view.myp_height == screenHeight;
    if (isFullScreen) {
        return _cropRect;
    } else {
        CGRect newCropRect = _cropRect;
        newCropRect.origin.y -= ((screenHeight - self.view.myp_height) / 2);
        return newCropRect;
    }
}

- (void)setModel:(MYAsset *)model {
    _previewView.model = model;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _previewView.allowCrop = allowCrop;
}

- (void)setScaleAspectFillCrop:(BOOL)scaleAspectFillCrop {
    _scaleAspectFillCrop = scaleAspectFillCrop;
    _previewView.scaleAspectFillCrop = scaleAspectFillCrop;
}

- (void)setCropRect:(CGRect)cropRect {
    _cropRect = cropRect;
    _previewView.cropRect = cropRect;
}

//MARK: - 视图更新
- (void)setupUI
{
    [self configSubviews];
    [self.view setBackgroundColor:MYHexColor(0x000000)];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configSubviews {
    self.previewView = [[MYImagePickerPhotoPreviewView alloc] initWithFrame:CGRectZero];
    [self.previewView setShowSelectBtn:NO];
    [self.previewView setModel:self.model];
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confimButton];
}

- (void)configCropView
{
    if (self.circleCropRadius > 0) {
        self.cropRect = CGRectMake(self.view.myp_width / 2 - _circleCropRadius, self.view.myp_height / 2 - _circleCropRadius, _circleCropRadius * 2, _circleCropRadius * 2);
    }
    
    [self.cropView removeFromSuperview];
    [self.cropBgView removeFromSuperview];
    
    [self.cropBgView setFrame:self.view.bounds];
    [self.view addSubview:self.cropBgView];
    [UIView my_overlayClippingWithView:self.cropBgView
                              cropRect:self.cropRect
                         containerView:self.view
                        needCircleCrop:self.needCircleCrop];
    
    [self.cropView setFrame:self.cropRect];
    [self.view addSubview:self.cropView];
    if (self.needCircleCrop) {
        self.cropView.layer.cornerRadius = self.cropRect.size.width / 2;
        [self.cropView setClipsToBounds:YES];
    }
    
    [self.view bringSubviewToFront:self.cancelButton];
    [self.view bringSubviewToFront:self.confimButton];
}

//MARK: - 事件响应
- (void)onConfirmBtnClick:(UIButton *)sender
{
    sender.enabled = NO;
    [self myp_showProgressHUD];
    UIImage *cropedImage = [MYImagePickerCropManager cropImageView:self.previewView.imageView toRect:self.cropRect zoomScale:self.previewView.scrollView.zoomScale containerView:self.view];
    if (self.needCircleCrop) {
        cropedImage = [MYImagePickerCropManager circularClipImage:cropedImage];
    }
    
    sender.enabled = YES;
    [self myp_hideProgressHUD];
    if (self.doneButtonClickBlockCropMode) {
        self.doneButtonClickBlockCropMode(cropedImage, self.model.asset);
    }
}

//MARK: - 方法重载
+ (BOOL)needNavigationBarHidden
{
    return YES;
}

@end
