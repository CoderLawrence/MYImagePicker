//
//  MYImagePickerVideoViewController.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/22.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerVideoViewController.h"

#import "MYAsset.h"
#import "MYAlbum.h"

#import "Masonry.h"

#import "MYImagePickerMacro.h"

#import "MYImagePickerVideoCell.h"
#import "MYImagePickerVideoLayout.h"

#import "MYImagePickerConfig.h"
#import "MYImagePickerViewController.h"
#import "MYImagePickerVideoPreviewViewController.h"

#import "UIColor+MYImagePicker.h"

#import "MYImagePickerManager.h"
#import "MYImagePickerManager+Queue.h"

static NSString *const MYImagePickerVideoCellReuseIdentifier = @"MYImagePickerVideoCellReuseIdentifier";

@interface MYImagePickerVideoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<MYAlbum *> *albumModels;
@property (nonatomic, strong) NSMutableArray<MYAsset *> *assetModels;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation MYImagePickerVideoViewController

//MARK: - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        _assetModels = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self handlerUpdateAbumModels];
}

//MARK: - getter && setter
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat height = MY_IMG_SCREEN_H - MY_IMG_Navigation_H;
        CGRect frame = CGRectMake(0, 0, MY_IMG_SCREEN_W, height);
        MYImagePickerVideoLayout *flowLayout = [[MYImagePickerVideoLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        [_collectionView registerClass:[MYImagePickerVideoCell class] forCellWithReuseIdentifier:MYImagePickerVideoCellReuseIdentifier];
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
        [_tipsLabel setText:@"暂时没有视频哦～"];
        [_tipsLabel setHidden:YES];
    }
    
    return _tipsLabel;
}

//MARK: - 视图更新
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

- (void)handlerUpdateAbumModels
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [[MYImagePickerManager shared] getAllAlbums:YES allowPickingImage:NO needFetchAssets:YES completion:^(NSArray<MYAlbum *> * _Nonnull models) {
                if ([models count] > 0) {
                    self->_albumModels = models;
                    for (MYAlbum *album in self->_albumModels) {
                        if ([album.models count] > 0) {
                            [self.assetModels addObjectsFromArray:album.models];
                        }
                    }
                }
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.assetModels count] > 0) {
                [self.collectionView reloadData];
            } else {
                [self.tipsLabel setHidden:NO];
            }
        });
    });
}

//MARK: - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetModels count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYImagePickerVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MYImagePickerVideoCellReuseIdentifier forIndexPath:indexPath];
    MYAsset *model = [self.assetModels objectAtIndex:indexPath.row];
    MYImagePickerConfig *config = self.assetPickerVC.config;
    BOOL isOutVideoTime = (model.videoTime < config.allowMinVideoTime || model.videoTime > config.allowMaxVideoTime);
    if (config.previewVideoTimeLimit && isOutVideoTime) {
        [cell setPreviewVideoTimeLimit:YES];
    } else {
        [cell setPreviewVideoTimeLimit:NO];
    }
    
    [cell setModel:model];
    cell.index = indexPath.item;
    
    __weak typeof(self) weakSelf = self;
    [cell setDidConnotSelectButtonClick:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showVideoTimeLimitAlert:strongSelf];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYAsset *assetModel = [self.assetModels objectAtIndex:indexPath.item];
    MYImagePickerVideoPreviewViewController *videoVC = [[MYImagePickerVideoPreviewViewController alloc] init];
    [videoVC setModel:assetModel];
    
    __weak typeof(self) wSelf = self;
    __weak typeof(videoVC) weakVideoVC = videoVC;
    [videoVC setDoneButtonClick:^(MYAsset * _Nonnull asset, UIImage * _Nonnull cover , UIButton *sender) {
        __strong typeof(weakVideoVC) strongVideoVC = weakVideoVC;
        __strong typeof(wSelf) sSelf = wSelf;
        if (sSelf == nil) { return; }
        //视频选择时长限制
        MYImagePickerConfig *config = sSelf.assetPickerVC.config;
        BOOL isOutVideoTime = (asset.videoTime < config.allowMinVideoTime || asset.videoTime > config.allowMaxVideoTime);
        if (isOutVideoTime) {
            [sSelf showVideoTimeLimitAlert:strongVideoVC];
            sender.enabled = YES;
            return;
        }
        
        [sSelf.navigationController dismissViewControllerAnimated:YES completion:^{
            if ([sSelf.assetPickerVC.delegate respondsToSelector:@selector(didSelectedAssetVideo:coverImage:imagePicker:)]) {
                [sSelf.assetPickerVC.delegate didSelectedAssetVideo:assetModel.asset coverImage:cover imagePicker:sSelf.assetPickerVC];
            }
        }];
    }];
    
    [self.navigationController pushViewController:videoVC animated:YES];
}

//MARK: - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpace = [MYImagePickerVideoCell itemSpace];
    return UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace, itemSpace);
}

//MARK: - 弹窗
- (void)showVideoTimeLimitAlert:(UIViewController *)viewController
{
    if (viewController == nil) { return; }
    NSString *message = [NSString stringWithFormat:@"视频时长不能小于 %.0f s或大于 %.0f s", self.assetPickerVC.config.allowMinVideoTime, self.assetPickerVC.config.allowMaxVideoTime];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirmAction];
    [viewController presentViewController:alertVC animated:YES completion:nil];
}

@end
