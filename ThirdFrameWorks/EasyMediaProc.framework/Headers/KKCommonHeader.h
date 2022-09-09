//
//  CommonHeader.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/2/9.
//

#ifndef CommonHeader_h
#define CommonHeader_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 强弱引用
 */
#define ddsmacro_concat(A, B) A ## B
#define weak(VAR)             __weak   __typeof(VAR)  ddsmacro_concat(VAR, _weak_) = (VAR)
#define strong(VAR)           __strong __typeof(ddsmacro_concat(VAR, _weak_)) VAR = ddsmacro_concat(VAR, _weak_); if (!VAR) return

// log level
#ifdef DEBUG
#define KKPlayerLog(...) NSLog(__VA_ARGS__)
#else
#define KKPlayerLog(...)
#endif

typedef NS_ENUM(NSInteger, KKErrorType) {
    KKErrorTypeNone,
    KKErrorTypeUrlEmpty, // url 为空
    KKErrorTypeFormatCreate, // 创建AVFormatContext错误
    KKErrorTypeOpenInput, // 打开媒体文件错误
    KKErrorTypeFindStream, // 获取音视频stream信息错误
    KKErrorTypeVideoStreamNotFound, // 未能找到Video Stream
    KKErrorTypeAudioStreamNotFound, // 未能找到Audio Stream
    KKErrorTypeAudioVideoCodecFail, // 音视频不能解码
    KKErrorTypeCodecContextCreate, // 创建音视频解码器错误
    KKErrorTypeCodecContextSetParam, // 设置音视频解码器参数错误
    KKErrorTypeCodecFindDecoder, // 未能找到对应的解码器
    KKErrorTypeCodecOpen, // 打开解码器错误
    KKErrorTypeCodecSuccess,
    KKErrorTypeInputParamsError, // 输入参数错误
    KKErrorTypeNotSupportFormat,
    KKErrorTypeUnknown,
};

typedef NS_ENUM(NSUInteger, KKTrackType) {
    KKTrackTypeUnknown,
    KKTrackTypeVideo,
    KKTrackTypeAudio,
    KKTrackTypeSubtitle,
};

typedef NS_ENUM(NSUInteger, KKVideoFrameRotateType) {
    KKVideoFrameRotateType0,
    KKVideoFrameRotateType90,
    KKVideoFrameRotateType180,
    KKVideoFrameRotateType270,
};

typedef NS_ENUM(NSUInteger, KKFrameType) {
    KKFrameTypeVideo,
    KKFrameTypeAVYUVVideo,
    KKFrameTypeCVYUVVideo,
    KKFrameTypeAudio,
    KKFrameTypeSubtitle,
    KKFrameTypeArtwork,
};

typedef NS_ENUM(NSUInteger, KKGLFrameType) {
    KKGLFrameTypeNV12,
    KKGLFrameTypeYUV420,
};

typedef NS_ENUM(NSUInteger, KKVideoToolBoxError) {
    KKVideoToolBoxErrorExtradataSize,
    KKVideoToolBoxErrorExtradataData,
    KKVideoToolBoxErrorCreateFormatDescription,
    KKVideoToolBoxErrorCreateSession,
    KKVideoToolBoxErrorNotH264,
    KKVideoToolBoxErrorNotSupport,
    KKVideoToolBoxErrorPrepareToEncodeFrames,
    KKVideoToolBoxErrorEncodeFrame,
    KKVideoToolBoxErrorCreateAVIOContext,
    KKVideoToolBoxErrorNotAVCC_HVCC
};

typedef NS_ENUM(NSUInteger, KKDecoderStatus) {
    KKDecoderStatusNone,
    KKDecoderStatusStart,
    KKDecoderStatusPause,
    KKDecoderStatusStop,
    KKDecoderStatusSeeking,
    KKDecoderStatusBuffering,
    KKDecoderStatusError
};

typedef NS_ENUM(NSUInteger, KKDecoderType) {
    KKDecoderTypeAudio,
    KKDecoderTypeVideo,
};

typedef NS_ENUM(NSUInteger, KKPlayerStatus) {
    KKPlayerStatusNone,
    KKPlayerStatusPlaying,
    KKPlayerStatusPause,
    KKPlayerStatusStop,
    KKPlayerStatusSeeking,
    KKPlayerStatusBuffering,
    KKPlayerStatusError,
    KKPlayerStatusReadPacketFinish,
    KKPlayerStatusUnknown
};

typedef NS_ENUM(NSUInteger, KKAudioPlayerInterruptionType) {
    KKAudioPlayerInterruptionTypeBegin,
    KKAudioPlayerInterruptionTypeEnded,
};

typedef NS_ENUM(NSUInteger, KKAudioPlayerInterruptionOption) {
    KKAudioPlayerInterruptionOptionNone,
    KKAudioPlayerInterruptionOptionShouldResume,
};

typedef NS_ENUM(NSUInteger, KKAudioPlayerRouteChangeReason) {
    KKAudioPlayerRouteChangeReasonOldDeviceUnavailable,
};

typedef NS_ENUM(NSInteger, KKRenderType) {
    KKRenderTypeOpenGLES,
    KKRenderTypeMetal
};

typedef NS_ENUM(NSInteger, KKVideoToolBoxEncoderType) {
    KKVideoToolBoxEncoderTypeH264,
    KKVideoToolBoxEncoderTypeHEVC
};

typedef NS_ENUM(NSInteger, KKAudioType) {
    KKAudioTypeAc3,
    KKAudioTypeAac,
    KKAudioTypeAiff,
    KKAudioTypeFlac,
    KKAudioTypeM4a,
    KKAudioTypeMP3,
    KKAudioTypeOgg,
    KKAudioTypeWav,
    KKAudioTypeWma,
    KKAudioTypeUnknown
};

typedef NS_ENUM(NSInteger, KKVideoType) {
    KKVideoTypeMP4,
    KKVideoTypeAVI,
    KKVideoTypeMKV,
    KKVideoTypeFLV,
    KKVideoTypeMOV,
    KKVideoTypeWMV,
    KKVideoTypeMPEG,
    KKVideoTypeASF,
    KKKVideoTypeUnknown
};

typedef NS_ENUM(NSInteger, KKSpeedRate) {
    KKSpeedRate0_5, // 0.5x
    KKSpeedRate1_0, // 1.0x
    KKSpeedRate1_5, // 1.5x
    KKSpeedRate2_0, // 2.0x
    KKSpeedRate2_5, // 2.5x
    KKSpeedRate3_0, // 3.0x
};

typedef NS_ENUM(NSInteger, KKPixelFormat) {
    KKPixelFormatNONE = -1,
    KKPixelFormatYUV420P,
    KKPixelFormatNV12,
    KKPixelFormatNV21,
};

typedef void(^CompletedBlock)(BOOL completed);
typedef void(^CompletedHandler)(KKErrorType result);
//typedef void(^ProgressHandler)(float progress);

#endif /* CommonHeader_h */
