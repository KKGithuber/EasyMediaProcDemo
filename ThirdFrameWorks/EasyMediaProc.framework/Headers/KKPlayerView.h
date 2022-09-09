//
//  KKPlayerView.h
//  EasyMediaProc
//
//  Created by yujianwu on 2022/2/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KKCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class KKDecoder;
@interface KKPlayerView : UIView
@property(nonatomic,weak)KKDecoder *decoder;
@property(nonatomic,assign)KKPlayerStatus playerStatus;
- (instancetype)initWithRenderType:(KKRenderType)renderType;
- (void)destory;
- (void)updateRenderViewOnce;
@end

NS_ASSUME_NONNULL_END
