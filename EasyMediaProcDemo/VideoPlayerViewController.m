//
//  VideoPlayerViewController.m
//  KKVideoPlayer
//
//  Created by yujianwu on 2022/4/3.
//

#import "VideoPlayerViewController.h"
#import <EasyMediaProc/KKPlayer.h>
#import <Masonry/Masonry.h>
#import "KKPlayerControllView.h"

@interface VideoPlayerViewController ()<KKPlayerDelegate, KKPlayerControllViewDelegate>
@property(nonatomic)KKPlayer *player;
@property(nonatomic)KKPlayerControllView *controllView;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
//    NSString *path = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [path stringByAppendingString:@"/test.asf"];
    
    self.player = [[KKPlayer alloc]initWithUrl:_filePath
                                      autoPlay:YES
                         useHardwareAccelerate:YES
                                     speedRate:KKSpeedRate1_0
                                    renderType:KKRenderTypeMetal];
    self.player.delegate = self;
    
    [self.view addSubview:self.player.playerView];
    [self.player.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(300);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.controllView];
    [self.controllView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.player.playerView);
    }];
    
    UIButton *b0_5x = [self buttonWithText:@"0.5x" selector:@selector(speedPlay:)];
    [b0_5x setTag:KKSpeedRate0_5];
    [self.view addSubview:b0_5x];
    [b0_5x mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.player.playerView.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *b1_0x = [self buttonWithText:@"1.0x" selector:@selector(speedPlay:)];
    [b1_0x setTag:KKSpeedRate1_0];
    [self.view addSubview:b1_0x];
    [b1_0x mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(b0_5x.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *b1_5x = [self buttonWithText:@"1.5x" selector:@selector(speedPlay:)];
    [b1_5x setTag:KKSpeedRate1_5];
    [self.view addSubview:b1_5x];
    [b1_5x mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(b1_0x.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *b2_0x = [self buttonWithText:@"2.0x" selector:@selector(speedPlay:)];
    [b2_0x setTag:KKSpeedRate2_0];
    [self.view addSubview:b2_0x];
    [b2_0x mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(b1_5x.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *b2_5x = [self buttonWithText:@"2.5x" selector:@selector(speedPlay:)];;
    [b2_5x setTag:KKSpeedRate2_5];
    [self.view addSubview:b2_5x];
    [b2_5x mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(b2_0x.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *b3_0x = [self buttonWithText:@"3.0x" selector:@selector(speedPlay:)];;
    [b3_0x setTag:KKSpeedRate3_0];
    [self.view addSubview:b3_0x];
    [b3_0x mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(b2_5x.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark -- button

- (UIButton *)buttonWithText:(NSString *)text selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateHighlighted];
    [button setTitle:text forState:UIControlStateSelected];
    [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [button setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark -- KKPlayerDelegate

- (void)playerStatus:(KKPlayerStatus)status error:(KKErrorType)errorType {
    self.controllView.playerStatus = status;
    switch (status) {
        case KKPlayerStatusPlaying: {
            KKPlayerLog(@"player start");
            break;
        }
        case KKPlayerStatusPause: {
            KKPlayerLog(@"player pause");
            break;
        }
        case KKPlayerStatusStop: {
            KKPlayerLog(@"player stop");
            break;
        }
        case KKPlayerStatusSeeking: {
            KKPlayerLog(@"player seeking");
            break;
        }
        case KKPlayerStatusBuffering: {
            KKPlayerLog(@"player buffering");
            break;
        }
        case KKPlayerStatusError: {
            KKPlayerLog(@"player error : error type : %ld", errorType);
            break;
        }
        default:
            break;
    }
}

- (void)updateProgress:(NSTimeInterval)progress {
    self.controllView.progress = progress;
}

- (void)updateDuration:(NSTimeInterval)duration {
    self.controllView.duration = duration;
}

#pragma mark -- 倍速播放

- (void)speedPlay:(id)sender {
    UIButton *buttom = (UIButton *)sender;
    self.player.speedRate = buttom.tag;
}

#pragma mark -- KKPlayerControllViewDelegate

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause:nil];
}

- (void)seekToPosition:(NSTimeInterval)position completed:(CompletedBlock)completedBlock {
    [self.player seekToPosition:position completed:completedBlock];
}

#pragma mark -- getter

- (KKPlayerControllView *)controllView {
    if (!_controllView) {
        _controllView = [KKPlayerControllView new];
        _controllView.delegate = self;
    }
    return _controllView;
}

@end
