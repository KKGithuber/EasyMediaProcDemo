//
//  FFmpegCmdToolsViewController.m
//  KKVideoPlayer
//
//  Created by kkfinger on 2022/4/26.
//

#import "FFmpegCmdToolsViewController.h"
#import <EasyMediaProc/FFmpegTools.h>
#import <Masonry/Masonry.h>
#import "VideoPlayerViewController.h"

@interface FFmpegCmdToolsViewController ()
@property(nonatomic)UIAlertController *waitingAlert;
@end

@implementation FFmpegCmdToolsViewController

- (instancetype)init {
    if (self = [super init]) {
        [[FFmpegTools shareInstance] registerProgressHandler:^(float progress) {
            KKPlayerLog(@"********* process progress : %f", progress);
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *rotateButton = [self buttonWithText:@"旋转视频" selector:@selector(rotateVideo)];
    [self.view addSubview:rotateButton];
    [rotateButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(100);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *fetchAudioButton = [self buttonWithText:@"音频格式转换" selector:@selector(convertAudio)];
    [self.view addSubview:fetchAudioButton];
    [fetchAudioButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(rotateButton.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *convertVideoButton = [self buttonWithText:@"视频格式转换" selector:@selector(convertVideo)];
    [self.view addSubview:convertVideoButton];
    [convertVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(fetchAudioButton.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *speedPlayButton = [self buttonWithText:@"倍速播放" selector:@selector(speedPlay)];
    [self.view addSubview:speedPlayButton];
    [speedPlayButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(convertVideoButton.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *cropButton = [self buttonWithText:@"视频裁剪" selector:@selector(cropVideo)];
    [self.view addSubview:cropButton];
    [cropButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(speedPlayButton.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *scaleButton = [self buttonWithText:@"视频缩放" selector:@selector(scaleVideo)];
    [self.view addSubview:scaleButton];
    [scaleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(cropButton.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark -- 旋转视频

- (void)rotateVideo {
    [self showOrHideWaiting:NO];
    NSString *outPutVideoPath = [NSString stringWithFormat:@"%@/temp.mkv", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) firstObject]];
    NSString *inputVideoPath = [[NSBundle mainBundle] pathForResource:@"TearsOfSteel 720p h265" ofType:@"mkv"];
    FFRange *range = [FFRange rangeWithStart:0 length:100];
    [[FFmpegTools shareInstance]rotateVideoWithPI:@"PI"
                                        inputPath:inputVideoPath
                                       outputPath:outPutVideoPath
                                            range:range
                                        completed:^(NSInteger result) {
        [self showOrHideWaiting:YES];
        [self playWithPath:outPutVideoPath];
//        [self showMessage:outPutVideoPath];
    }];
}

#pragma mark -- 音频格式转换

- (void)convertAudio {
    KKAudioType audioType = KKAudioTypeFlac;
    NSString *fileType = @"aac";
    if (audioType == KKAudioTypeFlac) {
        fileType = @"flac";
    } else if (audioType == KKAudioTypeMP3) {
        fileType = @"mp3";
    } else if (audioType == KKAudioTypeWav) {
        fileType = @"wav";
    } else if (audioType == KKAudioTypeOgg) {
        fileType = @"ogg";
    } else if (audioType == KKAudioTypeWma) {
        fileType = @"wma";
    } else if (audioType == KKAudioTypeM4a) {
        fileType = @"m4a";
    } else if (audioType == KKAudioTypeAiff) {
        fileType = @"aiff";
    } else if (audioType == KKAudioTypeAc3) {
        fileType = @"ac3";
    }
    [self showOrHideWaiting:NO];
    NSString *outPutPath = [NSString stringWithFormat:@"%@/audio_%@.%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) firstObject], fileType, fileType];
    NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"TearsOfSteel 720p h265" ofType:@"mkv"];
//    NSString *inputPath = [[NSBundle mainBundle]pathForResource:@"audio_aac" ofType:@"aac"];
    FFRange *range = [FFRange rangeWithStart:0 length:120];
    FFAudioOptions *options = [FFAudioOptions new];
    options.range = range;
    options.channelCount = 2;
    options.sampleRate = 16000;
    options.bitRate = 300;
    [[FFmpegTools shareInstance]convertAudio:inputPath
                                  outputPath:outPutPath
                                   audioType:audioType
                                     options:options
                                   completed:^(KKErrorType result) {
        [self showOrHideWaiting:YES];
//        [self showMessage:outPutPath];
        [self playWithPath:outPutPath];
    }];
}

#pragma mark -- 提取视频数据

- (void)convertVideo {
    KKVideoType videoType = KKVideoTypeASF;
    NSString *fileType = @"mp4";
    if (videoType == KKVideoTypeAVI) {
        fileType = @"avi";
    } else if (videoType == KKVideoTypeMKV) {
        fileType = @"mkv";
    } else if (videoType == KKVideoTypeFLV) {
        fileType = @"flv";
    } else if (videoType == KKVideoTypeMOV) {
        fileType = @"mov";
    } else if (videoType == KKVideoTypeWMV) {
        fileType = @"wmv";
    } else if (videoType == KKVideoTypeMPEG) {
        fileType = @"mpeg";
    } else if (videoType == KKVideoTypeASF) {
        fileType = @"asf";
    }
    [self showOrHideWaiting:NO];
    NSString *outPutPath = [NSString stringWithFormat:@"%@/video_convert_%@.%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) firstObject], fileType, fileType];
    NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"i-see-fire" ofType:@"mp4"];
    [[FFmpegTools shareInstance]convertVideo:inputPath
                                  outputPath:outPutPath
                                   videoType:videoType
                                     options:nil
                                   completed:^(KKErrorType result) {
        [self showOrHideWaiting:YES];
//        [self showMessage:outPutPath];
        [self playWithPath:outPutPath];
    }];
}

#pragma mark -- 倍速播放

- (void)speedPlay {
    [self showOrHideWaiting:NO];
    NSString *outPutVideoPath = [NSString stringWithFormat:@"%@/Speed_TearsOfSteel 720p h265.mkv", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) firstObject]];
    NSString *inputVideoPath = [[NSBundle mainBundle] pathForResource:@"TearsOfSteel 720p h265" ofType:@"mkv"];
    KKSpeedRate rate = KKSpeedRate2_0;
    [[FFmpegTools shareInstance]speedPlay:inputVideoPath
                               outputPath:outPutVideoPath
                                     rate:rate
                                completed:^(KKErrorType result) {
        [self showOrHideWaiting:YES];
//        [self showMessage:outPutVideoPath];
        [self playWithPath:outPutVideoPath];
    }];
}

#pragma mark -- 视频裁剪

- (void)cropVideo {
    [self showOrHideWaiting:NO];
    NSString *outPutVideoPath = [NSString stringWithFormat:@"%@/Crop TearsOfSteel 720p h265.mkv", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) firstObject]];
    NSString *inputVideoPath = [[NSBundle mainBundle] pathForResource:@"TearsOfSteel 720p h265" ofType:@"mkv"];
    FFVideoCropOptions *opts = [FFVideoCropOptions new];
    opts.size = CGSizeMake(1280/2, 720/2); // 1280x720
    opts.position = CGPointMake(0, 0);
    [[FFmpegTools shareInstance]videoCrop:inputVideoPath
                               outputPath:outPutVideoPath
                              cropOptions:opts
                                completed:^(KKErrorType result) {
        [self showOrHideWaiting:YES];
//        [self showMessage:outPutVideoPath];
        [self playWithPath:outPutVideoPath];
    }];
}

#pragma mark -- 视频缩放

- (void)scaleVideo {
    [self showOrHideWaiting:NO];
    NSString *outPutVideoPath = [NSString stringWithFormat:@"%@/Scale TearsOfSteel 720p h265.mkv", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) firstObject]];
    NSString *inputVideoPath = [[NSBundle mainBundle] pathForResource:@"TearsOfSteel 720p h265" ofType:@"mkv"];
    [[FFmpegTools shareInstance]scaleVideo:inputVideoPath
                                outputPath:outPutVideoPath
                                     scale:0.5
                                 completed:^(KKErrorType result) {
        [self showOrHideWaiting:YES];
//        [self showMessage:outPutVideoPath];
        [self playWithPath:outPutVideoPath];
    }];
}

#pragma mark -- 显示信息弹框

- (void)showMessage:(NSString *)message {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [UIPasteboard generalPasteboard].string = message;
    }];
    [alertCtrl addAction:actionCancel];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    KKPlayerLog(@"output path : %@", message);
}

#pragma mark -- 播放

- (void)playWithPath:(NSString *)path {
    VideoPlayerViewController *ctrl = [VideoPlayerViewController new];
    ctrl.filePath = path;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark -- wating

- (void)showOrHideWaiting:(BOOL)hide {
    if (!self.waitingAlert) {
        self.waitingAlert = [UIAlertController alertControllerWithTitle:nil message:@"正在处理中" preferredStyle:UIAlertControllerStyleAlert];
    }
    if (hide) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self presentViewController:self.waitingAlert animated:YES completion:nil];
    }
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

@end
