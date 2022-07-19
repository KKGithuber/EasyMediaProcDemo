//
//  KKAudioHardwareEncoder.h
//  EasyMediaProc
//
//  Created by yujianwu on 2022/5/1.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KKAudioHardwareEncodParams.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KKAudioHardwareEncoderDelegate <NSObject>
- (void)onAudioEncodeData:(NSData *)data timestmp:(CMTime)timestmp;
@end

@interface KKAudioHardwareEncoder : NSObject
@property(nonatomic,assign,readonly)BOOL already;
@property(nonatomic,weak)id<KKAudioHardwareEncoderDelegate> delegate;
- (instancetype)initWithParams:(KKAudioHardwareEncodParams *)params;
- (void)encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)destory;
@end

NS_ASSUME_NONNULL_END
