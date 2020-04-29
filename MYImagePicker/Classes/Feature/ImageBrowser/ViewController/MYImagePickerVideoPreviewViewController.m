//
//  MYImagePickerVideoPreviewViewController.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/25.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerVideoPreviewViewController.h"

#import "MYAsset.h"

#import "MYImagePickerManager.h"
#import "MYImagePickerManager+Queue.h"

#import "Masonry.h"
#import "MYImagePickerMacro.h"

#import "UIView+MYLayout.h"
#import "UIImage+MYBundle.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MYImagePickerPreNavigationBar.h"

@interface MYImagePickerVideoPreviewViewController ()

@property (nonatomic, strong) UIImage *cover;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) MYImagePickerPreNavigationBar *naviBar;

@end

@implementation MYImagePickerVideoPreviewViewController

//MARK: - 生命周期
- (instancetype)init
{
    self = [super init];
    if (self) {}
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self configMoviePlayer];
}

//MARK: - getter && setter
- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        CGRect frame = CGRectMake(0, 0, MY_IMG_SCREEN_W, 2);
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        [_progressView setProgressTintColor:[UIColor redColor]];
        [_progressView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
    }
    
    return _progressView;
}

- (MYImagePickerPreNavigationBar *)naviBar
{
    if (_naviBar == nil) {
        CGFloat height = [MYImagePickerPreNavigationBar height];
        CGRect frame = CGRectMake(0, 0, MY_IMG_SCREEN_W, height);
        _naviBar = [[MYImagePickerPreNavigationBar alloc] initWithFrame:frame];
        [_naviBar.backButton addTarget:self
                                action:@selector(onBackButtonClick)
                      forControlEvents:UIControlEventTouchUpInside];
        [_naviBar.nextButton addTarget:self
                                action:@selector(onDoneButtonClick:)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _naviBar;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [_indicatorView setColor:[UIColor whiteColor]];
    }
    
    return _indicatorView;
}

//MARK: - 视图相关
- (void)setupUI
{
    [self configBackground];
    [self.view addSubview:self.naviBar];
    [self.view addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(MY_IMG_Navigation_H/2);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)configBackground
{
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)configPlayButton
{
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage myp_imageNamedFromBundle:@"MY_Video_Pre_Play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage myp_imageNamedFromBundle:@"MY_Video_Pre_Play_High"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
}


//MARK: - 视频相关初始化
- (void)configMoviePlayer
{
    if (self.model == nil || self.model.asset == nil) {
        return;
    }
    
    self.naviBar.nextButton.enabled = NO;
    [self.indicatorView startAnimating];
    [[MYImagePickerManager shared] getPhotoWithAsset:self.model.asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
        if (!isDegraded && photo) {
            self->_cover = photo;
        }
    }];
    
    [[MYImagePickerManager shared] getVideoWithAsset:self.model.asset
                                     progressHandler:nil
                                videoAssetCompletion:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        [MYImagePickerManager performMainThread:^{
            if (avAsset != nil) {
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
                self->_player = [AVPlayer playerWithPlayerItem:playerItem];
                self->_playerLayer = [AVPlayerLayer playerLayerWithPlayer:self->_player];
                self->_playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                CGFloat playerHeight = MY_IMG_SCREEN_H - [MYImagePickerPreNavigationBar height];
                CGRect playerFrame = CGRectMake(0, [MYImagePickerPreNavigationBar height], MY_IMG_SCREEN_W, playerHeight);
                self->_playerLayer.frame = playerFrame;
                [self.view.layer addSublayer:self->_playerLayer];
                [self addProgressObserver];
                [self configPlayButton];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer) name:AVPlayerItemDidPlayToEndTimeNotification object:self->_player.currentItem];
                [self.indicatorView stopAnimating];
                self.naviBar.nextButton.enabled = YES;
            }
        }];
    }];
}

- (void)addProgressObserver{
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = self.progressView;
    [self.view addSubview:progress];
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviBar.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(MY_IMG_SCREEN_W, 2));
    }];
    
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

//MARK: - 事件响应
- (void)pausePlayer {
    [_player pause];
    [self.progressView setProgress:0.0f];
    [self.playButton setImage:[UIImage myp_imageNamedFromBundle:@"MY_Video_Pre_Play"] forState:UIControlStateNormal];
}

- (void)playButtonClick
{
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
        [self.playButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self pausePlayer];
    }
}

- (void)onDoneButtonClick:(UIButton *)sender
{
    sender.enabled = NO;
    if (self.doneButtonClick) {
        self.doneButtonClick(self.model, self->_cover, sender);
    }
}

//MARK: - 方法重载
+ (BOOL)needNavigationBarHidden
{
    return YES;
}

@end
