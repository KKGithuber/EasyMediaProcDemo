//
//  FFAudioOptions.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/4/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FFRange.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFAudioOptions : NSObject
@property(nonatomic,assign)NSInteger channelCount;
@property(nonatomic,assign)CGFloat bitRate; // 单位kb/s
@property(nonatomic,assign)CGFloat sampleRate;
@property(nonatomic)FFRange *range; // 起始位置，如果不设置，则默认整个音频长度
- (NSString *)optionDescription;
@end

NS_ASSUME_NONNULL_END
