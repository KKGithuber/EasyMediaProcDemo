//
//  KKPlayerControllView.m
//  KKVideoPlayer
//
//  Created by yujianwu on 2022/3/16.
//

#import "KKPlayerControllView.h"
#import <Masonry/Masonry.h>

#define MIN_POSITION_DIFF 0.05

@interface KKPlayerControllView()
@property(nonatomic)CAGradientLayer *topGradient;
@property(nonatomic)CAGradientLayer *bottomGradient;
@property(nonatomic)UIButton *playPauseButton;
@property(nonatomic)UILabel *startTimeLabel;
@property(nonatomic)UISlider *slider;
@property(nonatomic)UILabel *endTimeLabel;
@property(nonatomic)UIButton *landScene;
@property(nonatomic)BOOL sliderDarging;
@property(nonatomic)NSTimeInterval targetPosition;
@end

@implementation KKPlayerControllView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    KKPlayerLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topGradient.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    self.bottomGradient.frame = CGRectMake(0, self.frame.size.height - 44, self.frame.size.height, 44);
}

- (void)setup {
    [self.layer addSublayer:self.topGradient];
    [self.layer addSublayer:self.bottomGradient];
    [self addSubview:self.playPauseButton];
    [self addSubview:self.startTimeLabel];
    [self addSubview:self.slider];
    [self addSubview:self.endTimeLabel];
    [self layoutUI];
    
    self.targetPosition = -1;
}

- (void)layoutUI {
    [self.playPauseButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(15).priority(998);
        make.bottom.mas_equalTo(self).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.startTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseButton);
        make.left.mas_equalTo(self.playPauseButton.mas_right).mas_offset(8);
        make.width.mas_equalTo(60);
    }];
    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseButton);
        make.left.mas_equalTo(self.startTimeLabel.mas_right).mas_offset(8);
        make.right.mas_equalTo(self.endTimeLabel.mas_left).mas_offset(-8);
    }];
    [self.endTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-15).priority(998);
        make.centerY.mas_equalTo(self.playPauseButton);
        make.width.mas_equalTo(60);
    }];
}

- (void)playOrPause {
    BOOL shouldPlay = !self.playPauseButton.selected;
    if (shouldPlay) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(play)]) {
            [self.delegate play];
        }
        self.playPauseButton.selected = YES;
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
        }
        self.playPauseButton.selected = NO;
    }
}

#pragma mark -- 滑动条

- (void)sliderValueDidChanged:(id)sender {
    NSTimeInterval position = self.slider.value;
    NSTimeInterval time = self.duration * position;
    self.startTimeLabel.text = [self formatDuration:time full:self.duration >= 3600];
}

- (void)sliderBegin:(id)sender {
    self.sliderDarging = YES;
}

- (void)sliderEnd:(id)sender {
    weak(self);
    self.targetPosition = self.slider.value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(seekToPosition:completed:)]) {
        [self.delegate seekToPosition:self.targetPosition completed:^(BOOL completed) {
            strong(self);
            self.sliderDarging = NO;
        }];
    }
}

#pragma mark -- 更新进度

- (void)updateProgress:(NSTimeInterval)progress {
    if (self.sliderDarging) {
        return;
    }
    if (self.targetPosition != -1 && fabs(self.targetPosition - progress) > MIN_POSITION_DIFF) {
        return;
    }
    self.targetPosition = -1;
    self.slider.value = progress;
    self.startTimeLabel.text = [self formatDuration:self.duration * progress full:self.duration >= 3600];
}

#pragma mark -- @property setter

- (void)setProgress:(NSTimeInterval)progress {
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgress:progress];
    });
}

- (void)setPlayerStatus:(KKPlayerStatus)playerStatus {
    if (_playerStatus == playerStatus) {
        return;
    }
    _playerStatus = playerStatus;
    switch (playerStatus) {
        case KKPlayerStatusPause: {
            self.playPauseButton.selected = NO;
            break;
        }
        case KKPlayerStatusPlaying: {
            self.playPauseButton.selected = YES;
            break;
        }
        case KKPlayerStatusStop: {
            self.playPauseButton.selected = NO;
            self.startTimeLabel.text = [self formatDuration:0 full:self.duration >= 3600];
            self.slider.value = 0;
            break;
        }
        default:
            break;
    }
}

- (void)setDuration:(NSTimeInterval)duration {
    if (_duration == duration) {
        return;
    }
    _duration = duration;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.endTimeLabel.text = [self formatDuration:duration full: duration >= 3600];
    });
}

#pragma mark -- 时间转换

- (NSString*)formatDuration:(NSTimeInterval)duration full:(BOOL)full {
    if (duration <= 0) {
        return full ? @"00:00:00" : @"00:00";
    }
    long h = duration / 3600;
    long m = (((NSInteger)duration) % 3600) / 60 ;
    long s = ((NSInteger)duration) % 60;
    if (h > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", h, m, s];
    }
    return full ? [NSString stringWithFormat:@"00:%02ld:%02ld", m, s] : [NSString stringWithFormat:@"%02ld:%02ld", m, s];
}
#pragma mark -- @property getter

- (CAGradientLayer *)topGradient {
    if (!_topGradient) {
        _topGradient = ({
            CAGradientLayer *view = [[CAGradientLayer alloc]init];
            view.startPoint = CGPointMake(0.5, 0);
            view.endPoint = CGPointMake(0.5, 1);
            view.colors = @[
                [UIColor.blackColor colorWithAlphaComponent:0.5],
                UIColor.clearColor
            ];
            view;
        });
    }
    return _topGradient;
}

- (CAGradientLayer *)bottomGradient {
    if (!_bottomGradient) {
        _bottomGradient = ({
            CAGradientLayer *view = [[CAGradientLayer alloc]init];
            view.startPoint = CGPointMake(0.5, 1);
            view.endPoint = CGPointMake(0.5, 0);
            view.colors = @[
                [UIColor.blackColor colorWithAlphaComponent:0.5],
                UIColor.clearColor
            ];
            view;
        });
    }
    return _bottomGradient;
}

- (UIButton *)playPauseButton {
    if (!_playPauseButton) {
        _playPauseButton = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            view.contentMode = UIViewContentModeScaleAspectFit;
            [view setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            [view setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
            [view addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
    }
    return _playPauseButton;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = ({
            UILabel *view = [UILabel new];
            view.font = [UIFont systemFontOfSize:12];
            view.textColor = UIColor.whiteColor;
            view.text = @"00:00";
            view.textAlignment = NSTextAlignmentCenter;
            view;
        });
    }
    return _startTimeLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = ({
            UISlider *view = [[UISlider alloc]initWithFrame:CGRectZero];
            view.minimumValue = 0.0;
            view.maximumValue = 1.0;
            view.value = 0.0;
            view.minimumTrackTintColor = UIColor.redColor;
            view.maximumTrackTintColor = UIColor.whiteColor;
            view.thumbTintColor = UIColor.whiteColor;
            [view addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
            [view addTarget:self action:@selector(sliderBegin:) forControlEvents:UIControlEventTouchDown];
            [view addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
            view;
        });
    }
    return _slider;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = ({
            UILabel *view = [UILabel new];
            view.font = [UIFont systemFontOfSize:12];
            view.textColor = UIColor.whiteColor;
            view.text = @"00:00";
            view.textAlignment = NSTextAlignmentCenter;
            view;
        });
    }
    return _endTimeLabel;
}

@end
