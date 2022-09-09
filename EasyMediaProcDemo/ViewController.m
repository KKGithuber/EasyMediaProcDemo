//
//  ViewController.m
//  KKVideoPlayer
//
//  Created by yujianwu on 2022/2/7.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "VideoPlayerViewController.h"
#import "VideoToolBoxEncoderViewController.h"
#import "FFmpegCmdToolsViewController.h"
#import "VideoListViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"KKVideoPlayer";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIButton *playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playerButton setTitle:@"播放视频" forState:UIControlStateNormal];
    [playerButton setTitle:@"播放视频" forState:UIControlStateHighlighted];
    [playerButton setTitle:@"播放视频" forState:UIControlStateSelected];
    [playerButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [playerButton setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [playerButton setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [playerButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *encodeVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [encodeVideoButton setTitle:@"视频编码" forState:UIControlStateNormal];
    [encodeVideoButton setTitle:@"视频编码" forState:UIControlStateHighlighted];
    [encodeVideoButton setTitle:@"视频编码" forState:UIControlStateSelected];
    [encodeVideoButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [encodeVideoButton setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [encodeVideoButton setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [encodeVideoButton addTarget:self action:@selector(encodeVideo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ffmpegCmdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ffmpegCmdButton setTitle:@"命令行工具" forState:UIControlStateNormal];
    [ffmpegCmdButton setTitle:@"命令行工具" forState:UIControlStateHighlighted];
    [ffmpegCmdButton setTitle:@"命令行工具" forState:UIControlStateSelected];
    [ffmpegCmdButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [ffmpegCmdButton setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [ffmpegCmdButton setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [ffmpegCmdButton addTarget:self action:@selector(ffmpegCmd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:playerButton];
    [self.view addSubview:encodeVideoButton];
    [self.view addSubview:ffmpegCmdButton];
    [playerButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(100);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(44);
    }];
    [encodeVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(playerButton.mas_bottom);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(44);
    }];
    [ffmpegCmdButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(encodeVideoButton.mas_bottom);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
}

- (void)playVideo {
//    if ([self isSimuLator]) {
//        [self showMessage:@"模拟器会出现播放异常情况，建议在真机上播放"];
//        return;
//    }
    VideoListViewController *ctrl = [VideoListViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)encodeVideo {
    if ([self isSimuLator]) {
        [self showMessage:@"不支持模拟器"];
        return;
    }
    VideoToolBoxEncoderViewController *ctrl = [VideoToolBoxEncoderViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)ffmpegCmd {
    FFmpegCmdToolsViewController *ctrl = [FFmpegCmdToolsViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (BOOL)isSimuLator {
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        return YES;
    }
    return NO;
}

- (void)showMessage:(NSString *)message {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertCtrl addAction:actionCancel];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

@end
