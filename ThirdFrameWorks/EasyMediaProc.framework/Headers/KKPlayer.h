//
//  KKPlayer.h
//  EasyMediaProc
//
//  Created by yujianwu on 2022/2/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KKPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KKPlayerDelegate <NSObject>
- (void)playerStatus:(KKPlayerStatus)status error:(KKErrorType)errorType;
- (void)updateProgress:(NSTimeInterval)progress;
- (void)updateDuration:(NSTimeInterval)duration;
@end

@interface KKPlayer : NSObject
@property(nonatomic,readonly)KKPlayerView *playerView;
@property(nonatomic,weak)id<KKPlayerDelegate> delegate;
@property(nonatomic,assign,readonly)KKPlayerStatus playerStatus;
@property(nonatomic,assign,readonly)KKErrorType errorType;
@property(nonatomic,assign,readonly)NSTimeInterval progress;
@property(nonatomic,assign)KKSpeedRate speedRate;
- (instancetype)initWithUrl:(NSString *)url
                   autoPlay:(BOOL)autoPlay
      useHardwareAccelerate:(BOOL)useHardwareAccelerate
                  speedRate:(KKSpeedRate)speedRate
                 renderType:(KKRenderType)renderType;
- (void)play;
- (void)pause:(nullable CompletedBlock)completedBlock;
- (void)resume;
- (void)stop:(nullable CompletedBlock)completedBlock;
- (void)seekToPosition:(NSTimeInterval)position completed:(CompletedBlock)completedBlock;
- (void)seekToSecond:(NSTimeInterval)second completed:(CompletedBlock)completedBlock;
- (void)destory;
@end

NS_ASSUME_NONNULL_END
