//
//  FFRange.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFRange : NSObject
@property(nonatomic,assign)NSInteger start; // 开始位置，单位秒,如果为-1，则从头开始
@property(nonatomic,assign)NSInteger length; // 长度，单位秒，如果为-1，则不做长度限制
@property(nonatomic,readonly)NSString *startTimestamp; // HH:mm:ss.xxx
@property(nonatomic,readonly)NSString *lengthTimestamp; // HH:mm:ss.xxx
+ (instancetype)defaultRange;
+ (instancetype)rangeWithStart:(NSInteger)start length:(NSInteger)length;
- (NSString *)rangeDescription;
@end

NS_ASSUME_NONNULL_END
