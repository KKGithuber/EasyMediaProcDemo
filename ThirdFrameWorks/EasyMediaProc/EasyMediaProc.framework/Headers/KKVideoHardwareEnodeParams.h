//
//  KKVideoHardwareEnodeParams.h
//  EasyMediaProc
//
//  Created by yujianwu on 2022/5/1.
//

#import <Foundation/Foundation.h>
#import "KKCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

#define VideoHardwareEnodeDefaultWidth 1920
#define VideoHardwareEnodeDefaultHeight 1280
#define VideoHardwareEnodeDefaultFPS 30
#define VideoHardwareEnodeDefaultBitrate 3 * 1024 * 1024 * 8 // 3M bit/s

@interface KKVideoHardwareEnodeParams : NSObject
@property(nonatomic,assign)NSInteger width;
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,assign)NSInteger fps;
@property(nonatomic,assign)NSInteger bitrate;
@property(nonatomic,assign)KKVideoToolBoxEncoderType encoderType;
@end

NS_ASSUME_NONNULL_END
