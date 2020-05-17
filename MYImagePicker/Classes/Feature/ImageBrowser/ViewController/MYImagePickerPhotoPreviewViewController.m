//
//  MYImagePickerPhotoPreviewViewController.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/26.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerPhotoPreviewViewController.h"

#import <Photos/Photos.h>

#import "MYAsset.h"
#import "MYImagePickerCropManager.h"

#import "MYImagePickerMacro.h"

#import "UIView+MYLayout.h"
#import "UIImage+MYBundle.h"
#import "UIView+MYImagePickerCrop.h"
#import "UIViewController+MYImagePickerHUD.h"

#import "MYImagePickerAssetPreviewCell.h"
#import "MYImagePickerPreNavigationBar.h"

#import "MYImagePickerConfig.h"
#import "MYImagePickerViewController.h"

static NSString *const MYImagePickerPreviewPohotoReuseCellIdentifier = @"MYImagePickerPreviewPohotoReuseCellIdentifier";

@interface MYImagePickerPhotoPreviewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) MYImagePickerPreNavigationBar *naviBar;

@property (nonatomic, assign) double progress;

@end

@implementation MYImagePickerPhotoPreviewViewController

@synthesize cropRect = _cropRect;

//MARK: - 生命周期
- (instancetype)init
{
    self = [super init];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_currentIndex) {
        CGPoint offset = CGPointMake((self.view.myp_width + 20) * self.currentIndex, 0);
        [_collectionView setContentOffset:offset animated:NO];
    }
    
    [self refershAssetSelectedStatus];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat height = MY_IMG_SCREEN_H - MY_IMG_Navigation_H;
    _flowLayout.itemSize = CGSizeMake(self.view.myp_width + 20, height);
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, MY_IMG_Navigation_H, self.view.myp_width + 20, height);
    [_collectionView setCollectionViewLayout:_flowLayout];
    
    [self configCropView];
}

//MARK: - getter && setter
- (MYImagePickerPreNavigationBar *)naviBar
{
    if (_naviBar == nil) {
        CGFloat height = [MYImagePickerPreNavigationBar height];
        CGRect frame = CGRectMake(0, 0, MY_IMG_SCREEN_W, height);
        _naviBar = [[MYImagePickerPreNavigationBar alloc] initWithFrame:frame];
        [_naviBar.nextButton setTitle:@"下一步(0)" forState:UIControlStateNormal];
        [_naviBar.backButton addTarget:self
                                action:@selector(onBackButtonClick)
                      forControlEvents:UIControlEventTouchUpInside];
        [_naviBar.nextButton addTarget:self
                                action:@selector(onDoneButtonClick:)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _naviBar;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.myp_width + 20), 0);
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[MYImagePickerAssetPreviewCell class] forCellWithReuseIdentifier:MYImagePickerPreviewPohotoReuseCellIdentifier];
    }
    
    return _collectionView;
}

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

//MARK: - 视图更新
- (void)setupUI
{
    [self.view addSubview:self.naviBar];
    [self.view addSubview:self.collectionView];
}

- (void)configCropView
{
    MYImagePickerConfig *config = self.imagePickerVC.config;
    if (config.maxImagesCount <= 1 && config.allowCrop) {
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
        
        [self.view bringSubviewToFront:self.naviBar];
    }
}

//MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.myp_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.myp_width + 20);
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
}

//MARK: - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.models count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYAsset *model = [self.models objectAtIndex:indexPath.item];
    MYImagePickerAssetPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MYImagePickerPreviewPohotoReuseCellIdentifier forIndexPath:indexPath];
    cell.allowCrop = self.allowCrop;
    cell.cropRect = self.cropRect;
    cell.scaleAspectFillCrop = self.scaleAspectFillCrop;
    [cell setIndex:[self.imagePickerVC.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1];
    __weak typeof(_imagePickerVC) weakImagePickerVC = _imagePickerVC;
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        __strong typeof(weakCell) strongCell = weakCell;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakImagePickerVC) strongImagePickerVC = weakImagePickerVC;
        // 1. cancel select / 取消选择
        if (isSelected) {
            strongCell.previewView.selectedButton.selected = NO;
            model.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:strongImagePickerVC.selectedModels];
            for (MYAsset *model_item in selectedModels) {
                if ([model.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                    [strongSelf.imagePickerVC removeSelectedModel:model_item];
                    break;
                }
            }
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            MYImagePickerConfig *assetConfig = strongSelf.imagePickerVC.config;
            if (strongImagePickerVC.selectedModels.count < assetConfig.maxImagesCount) {
                if (assetConfig.maxImagesCount == 1 && !assetConfig.allowPreview) {
                    model.isSelected = YES;
                    [strongSelf.imagePickerVC addSelectedModel:model];
                    return;
                }
                 
                strongCell.previewView.selectedButton.selected = YES;
                model.isSelected = YES;
                [strongImagePickerVC addSelectedModel:model];
            } else {
                [strongSelf showPhotoSelectLimitAlert];
            }
        }
        
        if (model.isSelected) {
            NSInteger index = [strongImagePickerVC.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1;
            [strongCell setIndex:index];
        }
        
        [strongCell updateSelectedStatus];
        [strongSelf refershAssetSelectedStatus];
    };
    
    cell.model = model;
    
    return cell;
}

//MARK:  - 私有方法
- (void)refershAssetSelectedStatus
{
    if (self.allowCrop && self.imagePickerVC.config.maxImagesCount <= 1) {
        [self.naviBar.nextButton setHidden:NO];
        [self.naviBar.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    } else {
        self.naviBar.nextButton.hidden = self.imagePickerVC.selectedModels.count <= 0;
        [self.naviBar.nextButton setTitle:[NSString stringWithFormat:@"下一步(%zd)", self.imagePickerVC.selectedModels.count] forState:UIControlStateNormal];
    }
}

//MARK: - 弹窗
- (void)showPhotoSelectLimitAlert
{
    NSString *message = [NSString stringWithFormat:@"你最多只能选择 %zd 张照片", self.imagePickerVC.config.maxImagesCount];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//MARK: - 方法重载
- (void)onBackButtonClick
{
    [super onBackButtonClick];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)onDoneButtonClick:(UIButton *)sender
{
    //图片裁剪
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    MYImagePickerAssetPreviewCell *cell = (MYImagePickerAssetPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    if (self.allowCrop && [cell isKindOfClass:[MYImagePickerAssetPreviewCell class]]) {
        sender.enabled = NO;
        [self myp_showProgressHUD];
        UIImage *cropedImage = [MYImagePickerCropManager cropImageView:cell.previewView.imageView toRect:self.cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (self.needCircleCrop) {
            cropedImage = [MYImagePickerCropManager circularClipImage:cropedImage];
        }
        
        sender.enabled = YES;
        [self myp_hideProgressHUD];
        if (self.doneButtonClickBlockCropMode) {
            MYAsset *model = self.models[self.currentIndex];
            self.doneButtonClickBlockCropMode(cropedImage, model.asset);
        }
    } else {
        if ([self.imagePickerVC handleDoneButtonClick]) {
            sender.enabled = NO;
        }
    }
}

+ (BOOL)needNavigationBarHidden
{
    return YES;
}

@end
