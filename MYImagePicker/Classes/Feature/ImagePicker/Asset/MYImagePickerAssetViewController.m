//
//  MYImagePickerAssetViewController.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/22.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerAssetViewController.h"

#import "MYAsset.h"
#import "MYAlbum.h"

#import "MYImagePickerMacro.h"
#import "MYImagePickerAssetLayout.h"

#import "Masonry.h"
#import "UIColor+MYImagePicker.h"

#import "MYImagePickerManager+Queue.h"

#import "MYImagePickerConfig.h"
#import "MYImagePickerAssetCell.h"
#import "MYImagePickerViewController.h"
#import "MYImagePickerCropImageViewController.h"
#import "MYImagePickerPhotoPreviewViewController.h"

static NSString *const MYImagePickerAssetCellReuseIdentifier = @"MYImagePickerAssetCellReuseIdentifier";

@interface MYImagePickerAssetViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) MYAlbum *albumModel;

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MYImagePickerAssetViewController

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

- (void)setupUI
{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(258);
        make.height.mas_equalTo(@23.0f);
    }];
}

//MARK: - getter && setter
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat height = MY_IMG_SCREEN_H - MY_IMG_Navigation_H;
        CGRect frame = CGRectMake(0, 0, MY_IMG_SCREEN_W, height);
        MYImagePickerAssetLayout *flowLayout = [[MYImagePickerAssetLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        [_collectionView registerClass:[MYImagePickerAssetCell class] forCellWithReuseIdentifier:MYImagePickerAssetCellReuseIdentifier];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _collectionView;
}

- (UILabel *)tipsLabel
{
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_tipsLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        [_tipsLabel setTextColor:[UIColor myp_colorWithHexNumber:0x999999]];
        [_tipsLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipsLabel setText:@"暂时没有照片哦～"];
        [_tipsLabel setHidden:YES];
    }
    
    return _tipsLabel;
}

//MARk: - 公开方法
- (void)setAlbumModel:(MYAlbum *)albumModel
{
    _albumModel = albumModel;
    [self handlerUpdateAssetModels];
}

//MARK: - 私有方法
- (void)handlerUpdateAssetModels
{
    __weak typeof(self) wSelf = self;
    [self.albumModel startFetchAssetWithAllowPickingImage:YES allowPickingVideo:NO completion:^(NSArray<MYAsset *> * _Nonnull models) {
        __strong typeof(wSelf) sSelf = wSelf;
        [MYImagePickerManager performMainThread:^{
            if ([models count] > 0) {
                [sSelf.collectionView reloadData];
                [sSelf.tipsLabel setHidden:YES];
            } else {
                [sSelf.tipsLabel setHidden:NO];
            }
        }];
    }];
}

- (void)handlerOnCropImage:(UIImage *)cropImage asset:(PHAsset *)asset
{
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        id<MYImagePickerDelegate> delegate = strongSelf.assetPickerVC.delegate;
        if (delegate && [delegate respondsToSelector:@selector(didSelectedImageWithAssetModels:photos:imagePicker:)]) {
            [delegate didSelectedImageWithAssetModels:@[asset]
                                               photos:@[cropImage]
                                          imagePicker:strongSelf.assetPickerVC];
        }
    }];
}

//MARK: - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.albumModel == nil || [self.albumModel.models count] == 0) {
        return 0;
    }
    
    return [self.albumModel.models count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYImagePickerAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MYImagePickerAssetCellReuseIdentifier forIndexPath:indexPath];
    MYAsset *assetModel = [self.albumModel.models objectAtIndex:indexPath.row];
    cell.allowPreview = self.assetPickerVC.config.allowPreview;
    cell.showSelectBtn = self.assetPickerVC.config.showSelectBtn;
    
    [cell setModel:assetModel];
    if (assetModel.isSelected) {
        cell.index = [self.assetPickerVC.selectedAssetIds indexOfObject:assetModel.asset.localIdentifier] + 1;
    }
    
    if (self.assetPickerVC.selectedModels.count >= self.assetPickerVC.config.maxImagesCount && !assetModel.isSelected) {
        cell.cannotSelectLayerButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        cell.cannotSelectLayerButton.hidden = NO;
    } else {
        cell.cannotSelectLayerButton.hidden = YES;
    }
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        __strong typeof(weakCell) strongCell = weakCell;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 1. cancel select / 取消选择
        if (isSelected) {
            strongCell.selectedButton.selected = NO;
            assetModel.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:strongSelf.assetPickerVC.selectedModels];
            for (MYAsset *model_item in selectedModels) {
                if ([assetModel.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                    [strongSelf.assetPickerVC removeSelectedModel:model_item];
                    break;
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MYImageAssetPickeReloadNotificationKey object:strongSelf.assetPickerVC];
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            MYImagePickerConfig *assetConfig = strongSelf.assetPickerVC.config;
            if (strongSelf.assetPickerVC.selectedModels.count < assetConfig.maxImagesCount) {
                if (assetConfig.maxImagesCount == 1 && !assetConfig.allowPreview) {
                    assetModel.isSelected = YES;
                    [strongSelf.assetPickerVC addSelectedModel:assetModel];
                    return;
                }
                
                strongCell.selectedButton.selected = YES;
                assetModel.isSelected = YES;
                [strongSelf.assetPickerVC addSelectedModel:assetModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:MYImageAssetPickeReloadNotificationKey object:strongSelf.assetPickerVC];
            } else {
                [strongSelf showPhotoSelectLimitAlert];
            }
        }
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    if (self.assetPickerVC.config.allowCrop) {
        MYAsset *model = [self.albumModel.models objectAtIndex:index];
        MYImagePickerCropImageViewController *cropImageVC = [[MYImagePickerCropImageViewController alloc] initWithModel:model];
        [cropImageVC setImagePickerVC:self.assetPickerVC];
        [cropImageVC setCropRect:self.assetPickerVC.config.cropRect];
        [cropImageVC setCircleCropRadius:self.assetPickerVC.config.circleCropRadius];
        [cropImageVC setNeedCircleCrop:self.assetPickerVC.config.needCircleCrop];
        [cropImageVC setAllowCrop:self.assetPickerVC.config.allowCrop];
        [cropImageVC setScaleAspectFillCrop:self.assetPickerVC.config.scaleAspectFillCrop];
        [self.navigationController pushViewController:cropImageVC animated:YES];
    } else {
        MYImagePickerPhotoPreviewViewController *previewVC = [[MYImagePickerPhotoPreviewViewController alloc] init];
        [previewVC setImagePickerVC:self.assetPickerVC];
        //数据源赋值
        [previewVC setModels:[self.albumModel.models mutableCopy]];
        [previewVC setCurrentIndex:index];
        
        __weak typeof(self) weakSelf = self;
        [previewVC setBackButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.collectionView reloadData];
            [strongSelf.assetPickerVC refershAssetSelectedStatus];
        }];
        
        [previewVC setDoneButtonClickBlockCropMode:^(UIImage * cropedImage, id asset) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handlerOnCropImage:cropedImage asset:asset];
        }];
        
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpace = [MYImagePickerAssetCell itemSpace];
    return UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace, itemSpace);
}

//MARK: - 弹窗
- (void)showPhotoSelectLimitAlert
{
    NSString *message = [NSString stringWithFormat:@"你最多只能选择 %zd 张照片", self.assetPickerVC.config.maxImagesCount];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
