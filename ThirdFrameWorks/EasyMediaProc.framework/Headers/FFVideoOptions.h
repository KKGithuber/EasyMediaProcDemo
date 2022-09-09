//
//  FFVideoOptions.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/4/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FFRange.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFVideoOptions : NSObject
@property(nonatomic,assign)CGFloat bitRate;
@property(nonatomic,assign)NSInteger fps;
@property(nonatomic,strong)NSString *aspect; // 16:9
@property(nonatomic)FFRange *range; // 如果不指定  则默认整个视频长度
- (NSString *)optionDescription;
@end

NS_ASSUME_NONNULL_END
