//
//  KKAudioHardwareEncodParams.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 44100 22050 11025 5500
typedef NS_ENUM(NSInteger, KKAudioSampleRate) {
    KKAudioSampleRate44100 = 44100,
    KKAudioSampleRate22050 = 22050,
    KKAudioSampleRate11025 = 11025,
    KKAudioSampleRate5500 = 5500,
};

typedef NS_ENUM(NSInteger, KKAudioSampleBit) {
    KKAudioSampleBit16 = 16,
    KKAudioSampleBit8 = 8,
};

@interface KKAudioHardwareEncodParams : NSObject
@property(nonatomic,assign)KKAudioSampleRate sampleRate;
@property(nonatomic,assign)KKAudioSampleBit sampleBit;
@property(nonatomic,assign)NSInteger bitrate;
@property(nonatomic,assign)NSInteger channels;
+ (instancetype)defaultParams;
@end

NS_ASSUME_NONNULL_END
