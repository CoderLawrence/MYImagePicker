//
//  MYImagePickerViewController.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerViewController.h"

#import <Photos/Photos.h>

#import "MYImagePickerMacro.h"

#import "MYImagePickerAlbumView.h"
#import "MYImagePickerNavigationBar.h"
#import "MYImagePickerSegmentControl.h"
#import "MYImagePickerAuthorizationTipsView.h"

#import "MYImagePickerAssetViewController.h"
#import "MYImagePickerVideoViewController.h"
#import "UIViewController+MYImagePickerHUD.h"

#import "MYImagePickerConfig.h"
#import "MYImageFetchOperation.h"

#import "UIImage+MYBundle.h"
#import "UIView+MYLayout.h"

#import "MYImagePickerManager+Queue.h"
#import "MYImagePickerManager+Helper.h"
#import "MYImagePickerManager+Authorization.h"

NSString *const MYImageAssetPickeReloadNotificationKey = @"MYImageAssetPickeReloadNotificationKey";

@interface MYImagePickerViewController ()<UIScrollViewDelegate, MYImagePickerSegmentControlDelegate>
{
    BOOL _shouldShowAlbum;
    NSArray<MYAlbum *> *_albumModels;
    NSInteger _currentIndex;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MYImagePickerNavigationBar *naviBar;
@property (nonatomic, strong) MYImagePickerAlbumView *albumView;
@property (nonatomic, strong) MYImagePickerSegmentControl *segmentControl;
@property (nonatomic, strong) MYImagePickerAuthorizationTipsView *authorizationTipsView;

@property (nonatomic, strong) MYImagePickerAssetViewController *assetChildVC;
@property (nonatomic, strong) MYImagePickerVideoViewController *videoChildVC;

@end

@implementation MYImagePickerViewController

//MARK: - 初始化
- (instancetype)initWithConfig:(MYImagePickerConfig *)config
                      delegate:(id<MYImagePickerDelegate>)delegate
{
    self = [super init];
    if (self) {
        config = config?:[MYImagePickerConfig defaultConfig];
        self.config = config;
        self.delegate = delegate;
        NSArray *assets = self.config.selectedAssets;
        self.selectedAssets = [assets mutableCopy];
        [self checkAlbumAuthorization];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

//MARK：- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self handlerEventlistener];
    [self handlerFetchAlbumData];
    [self addObserver];
}

//MARK: - setter
- (void)setSelectedAssets:(NSMutableArray *)selectedAssets {
    _selectedAssets = selectedAssets;
    _selectedModels = [NSMutableArray array];
    _selectedAssetIds = [NSMutableArray array];
    for (PHAsset *asset in selectedAssets) {
        MYAsset *model = [MYAsset assetWithPHAsset:asset mediaType:[[MYImagePickerManager shared] getAssetType:asset]];
        model.isSelected = YES;
        [self addSelectedModel:model];
    }
}

- (void)addSelectedModel:(MYAsset *)model
{
    [_selectedModels addObject:model];
    [_selectedAssetIds addObject:model.asset.localIdentifier];
}

- (void)removeSelectedModel:(MYAsset *)model
{
    [_selectedModels removeObject:model];
    [_selectedAssetIds removeObject:model.asset.localIdentifier];
}

//MARK: - 懒加载
- (MYImagePickerSegmentControl *)segmentControl
{
    if (_segmentControl == nil) {
        CGFloat segmentLeft = (MY_IMG_SCREEN_W - 136)/2;
        CGFloat segmentTop = MY_IMG_Navigation_Top + (40 - 26)/2;
        CGRect frame = CGRectMake(segmentLeft, segmentTop, 136, 26);
        BOOL needVideoItem = self.config.allowPickingVideoAsset;
        _segmentControl = [[MYImagePickerSegmentControl alloc] initWithFrame:frame
                                                               needVideoItem:needVideoItem];
        [_segmentControl setDelegate:self];
    }
    
    return _segmentControl;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        CGFloat height = MY_IMG_SCREEN_H - [MYImagePickerNavigationBar height];
        CGRect frame = CGRectMake(0, [MYImagePickerNavigationBar height], MY_IMG_SCREEN_W, height);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView setBounces:NO];
        [_scrollView setPagingEnabled:YES];
        
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    return _scrollView;
}

- (MYImagePickerNavigationBar *)naviBar
{
    if (_naviBar == nil) {
        CGFloat height = [MYImagePickerNavigationBar height];
        CGRect frame = CGRectMake(0, 0, MY_IMG_SCREEN_W, height);
        _naviBar = [[MYImagePickerNavigationBar alloc] initWithFrame:frame];
        [_naviBar.backButton addTarget:self
                                action:@selector(onBackButtonClick)
                      forControlEvents:UIControlEventTouchUpInside];
        [_naviBar.nextButton addTarget:self
                                action:@selector(onNextButtonClick)
                      forControlEvents:UIControlEventTouchUpInside];
        [_naviBar.nextButton setHidden:YES];
    }
    
    return _naviBar;
}

- (MYImagePickerAlbumView *)albumView
{
    if (_albumView == nil) {
        CGFloat height = MY_IMG_SCREEN_H - [MYImagePickerNavigationBar height];
        CGRect frame = CGRectMake(0, [MYImagePickerNavigationBar height], MY_IMG_SCREEN_W, height);
        _albumView = [[MYImagePickerAlbumView alloc] initWithFrame:frame];
        [_albumView setHidden:YES];
    }
    
    return _albumView;
}

- (MYImagePickerAuthorizationTipsView *)authorizationTipsView
{
    if (_authorizationTipsView == nil) {
        CGFloat height = MY_IMG_SCREEN_H - MY_IMG_Navigation_H;
        CGRect frame = CGRectMake(0, self.naviBar.myp_bottom, self.view.myp_width, height);
        _authorizationTipsView = [[MYImagePickerAuthorizationTipsView alloc] initWithFrame:frame];
    }
    
    return _authorizationTipsView;
}

//MARK: - 视图更新
- (void)setupUI
{
    [self setupBackground];
    [self.view addSubview:self.naviBar];
    [self.naviBar addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.albumView];
    [self.view bringSubviewToFront:self.naviBar];
    [self addAssetChildViewControllers];
}

- (void)setupBackground
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)addAssetChildViewControllers
{
    NSArray<UIViewController *> *childViewControllers;
    self.assetChildVC = [[MYImagePickerAssetViewController alloc] init];
    self.assetChildVC.assetPickerVC = self;
    
    if (self.config.allowPickingVideoAsset) {
        self.videoChildVC = [[MYImagePickerVideoViewController alloc] init];
        self.videoChildVC.assetPickerVC = self;
        childViewControllers = @[self.assetChildVC, self.videoChildVC];
    } else {
        childViewControllers = @[self.assetChildVC];
    }
    
    for (int i = 0; i < childViewControllers.count; i++) {
        UIViewController *childVC = childViewControllers[i];
        [childVC willMoveToParentViewController:self];
        [self addChildViewController:childVC];
        CGFloat height = MY_IMG_SCREEN_H - [MYImagePickerNavigationBar height];
        CGRect frame = CGRectMake(MY_IMG_SCREEN_W * i, 0, MY_IMG_SCREEN_W, height);
        [childVC.view setFrame:frame];
        [self.scrollView addSubview:childVC.view];
        [childVC didMoveToParentViewController:self];
    }
    
    
    CGFloat height = MY_IMG_SCREEN_H - [MYImagePickerNavigationBar height];
    [self.scrollView setContentSize:CGSizeMake(MY_IMG_SCREEN_W * [childViewControllers count], height)];
}

//MARK: - 逻辑处理
- (void)checkAlbumAuthorization
{
    if ([[MYImagePickerManager shared] authorizationStatusAuthorized] == NO) {
        if ([PHPhotoLibrary authorizationStatus] == 0) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:NO];
        }
    }
}

- (void)handlerFetchAlbumData
{
    //请求相册是否已经授权
    if ([[MYImagePickerManager shared] authorizationStatusAuthorized] == NO) {
        __weak typeof(self) wSelf = self;
        [self.authorizationTipsView setOnSettingButtonClick:^{
            __strong typeof(wSelf) sSelf = wSelf;
            [sSelf settingBtnClick];
        }];
        [self.view addSubview:self.authorizationTipsView];
        return;
    }
    
    [self myp_showProgressHUD];
    [MYImagePickerManager pefromAsynQueue:^{
        [[MYImagePickerManager shared] getAllAlbums:NO
                                  allowPickingImage:YES
                                    needFetchAssets:NO
                                         completion:^(NSArray<MYAlbum *> * _Nonnull models) {
            [MYImagePickerManager performMainThread:^{
                if ([models count] > 0) {
                    self->_albumModels = models;
                    [self.albumView setAlbums:models];
                    [self.albumView reloadData];
                    MYAlbum *album = models.firstObject;
                    [self.assetChildVC setAlbumModel:album];
                    [self myp_hideProgressHUD];
                }
            }];
        }];
    }];
}

- (void)handlerEventlistener
{
    __weak typeof(self) wSelf = self;
    //展示相册列表
    [self.segmentControl setOnShowAlbumClick:^(BOOL shouldShow) {
        __strong typeof(wSelf) sSelf = wSelf;
        BOOL isPackup = shouldShow ? NO : YES;
        [sSelf.albumView show:isPackup animation:YES];
    }];
    
    [self.segmentControl setOnItmeClick:^(NSUInteger selectedIndex) {
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf->_currentIndex = selectedIndex;
        [sSelf refershAssetSelectedStatus];
        [sSelf.scrollView setContentOffset:CGPointMake(selectedIndex * MY_IMG_SCREEN_W, 0) animated:YES];
    }];
    
    //点击选中某个相册
    [self.albumView setOnClickAlbumItem:^(MYAlbum * _Nonnull albumTtem) {
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf.segmentControl restShouldShowAlbum];
        [sSelf.assetChildVC setAlbumModel:albumTtem];
    }];
    
    //点击背景收起相册
    [self.albumView setOnClickMaskDismiss:^{
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf.segmentControl restShouldShowAlbum];
    }];
}

- (BOOL)handlerOnCompletionSelectedAssets
{
    if (self.config.minImagesCount && self.selectedModels.count < self.config.minImagesCount) {
        NSString *message = [NSString stringWithFormat:@"请至少选择 %zd 张照片", self.config.minImagesCount];
        [self showAlertWithTitle:message];
        return NO;
    }
    
    [self myp_showProgressHUD];
    NSMutableArray *assets = [NSMutableArray array];
    self.naviBar.nextButton.enabled = NO;
    if (self.config.onlyReturnAsset) {
        for (MYAsset *assetModel in self.selectedAssets) {
            [assets addObject:assetModel.asset];
        }
        
        [self myp_hideProgressHUD];
        __weak typeof(self) wSelf = self;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            __strong typeof(wSelf) sSelf = wSelf;
            if (sSelf == nil) { return; }
            if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(didSelectedImageWithAssetModels:imagePicker:)]) {
                [sSelf.delegate didSelectedImageWithAssetModels:[assets copy] imagePicker:self];
            }
        }];
    } else {
        NSMutableArray *photos = [NSMutableArray array];
        NSMutableArray *infoArr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.selectedModels.count; i++) { [photos addObject:@1];[assets addObject:@1];[infoArr addObject:@1]; }
        
        __block BOOL havenotShowAlert = YES;
        [MYImagePickerManager shared].shouldFixOrientation = YES;
        __block UIAlertController *alertView;
        for (NSInteger i = 0; i < self.selectedModels.count; i++) {
            MYAsset *model = self.selectedModels[i];
            MYImageFetchOperation *operation = [[MYImageFetchOperation alloc] initWithAsset:model.asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
                if (isDegraded) return;
                if (photo) {
                    [photos replaceObjectAtIndex:i withObject:photo];
                }
                
                if (info)  [infoArr replaceObjectAtIndex:i withObject:info];
                [assets replaceObjectAtIndex:i withObject:model.asset];
                
                for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }
                
                if (havenotShowAlert) {
                    [self hideAlertView:alertView];
                    __weak typeof(self) weakSelf = self;
                    [self myp_hideProgressHUD];
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        if (strongSelf == nil) { return; }
                        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didSelectedImageWithAssetModels:photos:imagePicker:)]) {
                            [strongSelf.delegate didSelectedImageWithAssetModels:[assets copy] photos:[photos copy] imagePicker:strongSelf];
                        }
                    }];
                }
            } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
                // 如果图片正在从iCloud同步中,提醒用户
                if (progress < 1 && havenotShowAlert && !alertView) {
                    alertView = [self showAlertWithTitle:@"正在从iCloud同步照片"];
                    havenotShowAlert = NO;
                    return;
                }
                if (progress >= 1) {
                    havenotShowAlert = YES;
                }
            }];
            
            if (self.operationQueue == nil) {
                self.operationQueue = [[NSOperationQueue alloc] init];
                self.operationQueue.maxConcurrentOperationCount = 3;
            }
            
            [self.operationQueue addOperation:operation];
        }
    }
    
    return YES;
}

- (void)observeAuthrizationStatusChange {
    [_timer invalidate];
    _timer = nil;
    if ([PHPhotoLibrary authorizationStatus] == 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:NO];
    }
    
    if ([[MYImagePickerManager shared] authorizationStatusAuthorized]) {
        [self.authorizationTipsView removeFromSuperview];
        [self handlerFetchAlbumData];
    }
}

- (void)refershAssetSelectedStatus
{
    if (self->_currentIndex == kMYImagePickerSegmentItemVideo) {
        [self.naviBar.nextButton setHidden:YES];
        return;
    }
    
    self.naviBar.nextButton.hidden = self.selectedModels.count <= 0;
    [self.naviBar.nextButton setTitle:[NSString stringWithFormat:@"下一步(%zd)", self.selectedModels.count] forState:UIControlStateNormal];
}

//MARK: - 通知
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(refershAssetSelectedStatus)
                                                 name:MYImageAssetPickeReloadNotificationKey
                                               object:nil];
}

//MARK: - 公开方法
- (BOOL)handleDoneButtonClick
{
    return [self handlerOnCompletionSelectedAssets];
}

//MARK: - 私有方法
- (void)setConfig:(MYImagePickerConfig *)config
{
    _config = config;
    [MYImagePickerManager shared].sortAscendingByModificationDate = config.sortAscendingByModificationDate;
    [MYImagePickerManager shared].photoWidth = config.photoWidth;
    [MYImagePickerManager shared].photoPreviewMaxWidth = config.photoPreviewMaxWidth;
    [MYImagePickerManager shared].columnNumber = 3;
    self.myp_HUD_timeout = config.timeout;
}

//MARK: - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    _currentIndex = (NSUInteger)(contentOffset.x / scrollView.frame.size.width + 0.5) % 2;
    [self.segmentControl setSelectedIndex:_currentIndex];
}

//MARK: - MYImagePickerSegmentControlDelegate
- (BOOL)canChangedSelectedItem:(MYImagePickerSegmentControl *)segmentControl
{
    if ([[MYImagePickerManager shared] authorizationStatusAuthorized] == NO) {
        return NO;
    }
    
    return YES;
}

- (BOOL)canShowAlbumPage:(MYImagePickerSegmentControl *)segmentControl
{
    return [self->_albumModels count] > 0;
}

//MARK: - 事件响应
- (void)onBackButtonClick
{
    [super onBackButtonClick];
    if (self.operationQueue != nil) {
        [self.operationQueue cancelAllOperations];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelSelectImage:)]) {
        [self.delegate didCancelSelectImage:self];
    }
}

- (void)onNextButtonClick
{
    [self handlerOnCompletionSelectedAssets];
}

- (void)settingBtnClick
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

//MARK: - 弹窗
- (UIAlertController *)showAlertWithTitle:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

- (void)hideAlertView:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
    alertView = nil;
}

//MARK: - 方法重载
+ (BOOL)needNavigationBarHidden
{
    return YES;
}

@end
