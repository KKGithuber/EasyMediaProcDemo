//
//  KKVideoHardwareEncoder.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/2/16.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "KKVideoHardwareEnodeParams.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KKVideoHardwareEncoderDelegate <NSObject>
- (void)onVideoEncodeError:(NSError *)error;
- (void)onVideoEncodeData:(uint8_t *)data
                     size:(NSInteger)size
                 timestmp:(CMTime)timestmp
               isKeyFrame:(BOOL)isKeyFrame
                    isVSP:(BOOL)isVSP;
@end

@interface KKVideoHardwareEncoder : NSObject
@property(nonatomic,weak)id<KKVideoHardwareEncoderDelegate>delegate;
@property(nonatomic)KKVideoHardwareEnodeParams *params;
- (instancetype)initWithParams:(KKVideoHardwareEnodeParams *)params;
- (void)encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)destory;
@end

NS_ASSUME_NONNULL_END
