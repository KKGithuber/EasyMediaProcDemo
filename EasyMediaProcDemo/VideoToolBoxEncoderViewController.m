//
//  VideoToolBoxEncoderViewController.m
//  KKVideoPlayer
//
//  Created by yujianwu on 2022/4/3.
//

#import "VideoToolBoxEncoderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import <EasyMediaProc/KKVideoHardwareEncoder.h>
#import <EasyMediaProc/KKAudioHardwareEncoder.h>
#import <EasyMediaProc/KKCaptureSession.h>

@interface VideoToolBoxEncoderViewController ()<KKVideoHardwareEncoderDelegate, KKCaptureSessionDelegate, KKAudioHardwareEncoderDelegate>
@property(nonatomic,strong)KKVideoHardwareEncoder *videoEncoder;
@property(nonatomic,strong)KKAudioHardwareEncoder *audioEncoder;
@property(nonatomic,strong)KKCaptureSession *captureSession;
@property(nonatomic)FILE *videoFileHandler;
@property(nonatomic)NSFileHandle *audioFileHandler;
@end

@implementation VideoToolBoxEncoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initFile];
    [self initCapture];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:0];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitle:@"开始" forState:UIControlStateHighlighted];
    [btn setTitle:@"开始" forState:UIControlStateSelected];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(startOrStop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.captureSession.preview.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchBtn setTag:0];
    [switchBtn setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [switchBtn setTitle:@"切换摄像头" forState:UIControlStateHighlighted];
    [switchBtn setTitle:@"切换摄像头" forState:UIControlStateSelected];
    [switchBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [switchBtn setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [switchBtn setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [switchBtn addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    [switchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(btn.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
}

- (void)dealloc {
    [_videoEncoder destory];
    [_audioEncoder destory];
    [_captureSession destory];
    if (self.videoFileHandler) {
        fclose(self.videoFileHandler);
        self.videoFileHandler = NULL;
    }
    if (self.audioFileHandler) {
        [self.audioFileHandler closeFile];
        self.audioFileHandler = NULL;
    }
}

- (void)initFile{
    NSString *path = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [path stringByAppendingString:@"/capture_test.asf"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:videoPath error:nil];
    if( (self.videoFileHandler = fopen([videoPath UTF8String], "w+")) == NULL ){
    }
    NSLog(@"video file path : %@", videoPath);
    
    NSString *audioPath = [path stringByAppendingString:@"/capture_test.aac"];
    [fileManager removeItemAtPath:audioPath error:nil];
    [fileManager createFileAtPath:audioPath contents:nil attributes:nil];
    self.audioFileHandler = [NSFileHandle fileHandleForWritingAtPath:audioPath];
    NSLog(@"audio file path : %@", audioPath);
}

- (void)initCapture {
    self.captureSession = [[KKCaptureSession alloc]initWithSessionType:KKCaptureSessionTypeAll];
    self.captureSession.presention = AVCaptureSessionPreset1920x1080;
    self.captureSession.videoGravity = AVLayerVideoGravityResizeAspect;
    self.captureSession.cameraPosition = AVCaptureDevicePositionBack;
    self.captureSession.delegate = self;
    
    self.captureSession.preview.frame = CGRectMake(0, (self.view.frame.size.height - 300) / 2, self.view.frame.size.width, 300);
    self.captureSession.preview.backgroundColor = [UIColor blackColor];
    self.captureSession.preview.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view addSubview:self.captureSession.preview];
    
    CGSize size = self.captureSession.presentionSize;
    KKVideoHardwareEnodeParams *params = [KKVideoHardwareEnodeParams new];
    params.fps = 30;
    params.bitrate = 1 * 1024 * 1024 * 3;
    params.encoderType = KKVideoToolBoxEncoderTypeHEVC;
    params.width = size.width;
    params.height = size.height;
    self.videoEncoder = [[KKVideoHardwareEncoder alloc]initWithParams:params];
    self.videoEncoder.delegate = self;
    
    KKAudioHardwareEncodParams *param = [KKAudioHardwareEncodParams defaultParams];
    self.audioEncoder = [[KKAudioHardwareEncoder alloc]initWithParams:param];
    self.audioEncoder.delegate = self;
}

#pragma mark -- KKCaptureSessionDelegate

- (void)onSampleBuffer:(CMSampleBufferRef)sampleBuffer mediaType:(nonnull AVMediaType)mediaType {
    if (mediaType == AVMediaTypeVideo) {
        [self.videoEncoder encodeSampleBuffer:sampleBuffer];
    } else if (mediaType == AVMediaTypeAudio) {
        [self.audioEncoder encodeSampleBuffer:sampleBuffer];
    }
}

- (void)onStopCapture {
    if (self.videoFileHandler != nil) {
        fclose(self.videoFileHandler);
        self.videoFileHandler = nil;
    }
    if (self.audioFileHandler != nil) {
        [self.audioFileHandler closeFile];
        self.audioFileHandler = nil;
    }
    NSString *path = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [path stringByAppendingString:@"/capture_test.asf"];
    NSString *audioPath = [path stringByAppendingString:@"/capture_test.aac"];
    [self showAlert:[NSString stringWithFormat:@"video path : %@, audio path: %@", videoPath, audioPath]];
}

#pragma mark -- KKVideoHardwareEncoderDelegate

- (void)onVideoEncodeError:(NSError *)error {
    NSLog(@"KKVideoToolBoxEncoder encode error : %@", error);
}

- (void)onVideoEncodeData:(uint8_t *)data size:(NSInteger)size timestmp:(CMTime)timestmp isKeyFrame:(BOOL)isKeyFrame isVSP:(BOOL)isVSP {
    if (data != NULL && self.videoFileHandler) {
        fwrite(data, 1, size, self.videoFileHandler);
    }
}

#pragma mark -- KKAudioHardwareEncoderDelegate

- (void)onAudioEncodeData:(NSData *)data timestmp:(CMTime)timestmp{
    [self.audioFileHandler seekToEndOfFile];
    [self.audioFileHandler writeData:data];
}

#pragma mark -- 切换摄像头

- (void)switchCamera:(id)sender {
    AVCaptureDevicePosition position = self.captureSession.cameraPosition;
    if (position == AVCaptureDevicePositionBack) {
        position = AVCaptureDevicePositionFront;
    } else {
        position = AVCaptureDevicePositionBack;
    }
    self.captureSession.cameraPosition = position;
}

#pragma mark -- 开始结束

- (void)startOrStop:(id)sender {
    UIButton *btn = (UIButton *)sender ;
    NSInteger tag = btn.tag;
    if (tag == 0) {
        [btn setTitle:@"结束" forState:UIControlStateNormal];
        [btn setTitle:@"结束" forState:UIControlStateHighlighted];
        [btn setTitle:@"结束" forState:UIControlStateSelected];
        [btn setTag:1];
        [self.captureSession startCapture];
    } else {
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        [btn setTitle:@"开始" forState:UIControlStateHighlighted];
        [btn setTitle:@"开始" forState:UIControlStateSelected];
        [btn setTag:0];
        [self.captureSession stopCapture];
    }
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertCtrl addAction:actionCancel];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

@end
