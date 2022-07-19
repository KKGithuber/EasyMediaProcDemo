//
//  KKCaptureSession.h
//  EasyMediaProc
//
//  Created by yujianwu on 2022/5/1.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KKVideoCapturePreview.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KKCaptureSessionType) {
    KKCaptureSessionTypeVideo = 1,
    KKCaptureSessionTypeAudio = 2,
    KKCaptureSessionTypeAll
};

@protocol KKCaptureSessionDelegate <NSObject>
- (void)onSampleBuffer:(CMSampleBufferRef)sampleBuffer mediaType:(AVMediaType)mediaType;
- (void)onStopCapture;
@end

@interface KKCaptureSession : NSObject
@property(nonatomic,weak)id<KKCaptureSessionDelegate>delegate;
@property(nonatomic,strong,readonly)KKVideoCapturePreview *preview;
@property(nonatomic,strong,readonly)AVCaptureSession *session;
@property(nonatomic,assign)AVCaptureDevicePosition cameraPosition; // AVCaptureSessionPreset1920x1080
@property(nonatomic,strong)AVCaptureSessionPreset presention;
@property(nonatomic,assign)AVLayerVideoGravity videoGravity;
@property(nonatomic,assign,readonly)BOOL videoAlready;
@property(nonatomic,assign,readonly)BOOL audioAlready;
@property(nonatomic,assign,readonly)CGSize presentionSize;
- (instancetype)initWithSessionType:(KKCaptureSessionType)type;
- (void)startCapture;
- (void)stopCapture;
- (void)destory;
@end

NS_ASSUME_NONNULL_END
