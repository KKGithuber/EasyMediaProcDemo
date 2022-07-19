//
//  KKPlayerControllView.h
//  KKVideoPlayer
//
//  Created by yujianwu on 2022/3/16.
//

#import <UIKit/UIKit.h>
#import <EasyMediaProc/KKCommonHeader.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKPlayerControllViewDelegate <NSObject>
- (void)play;
- (void)pause;
- (void)seekToPosition:(NSTimeInterval)position completed:(CompletedBlock)completedBlock;
@end

@interface KKPlayerControllView : UIView
@property(nonatomic,weak)id<KKPlayerControllViewDelegate> delegate;
@property(nonatomic,assign)NSTimeInterval progress;
@property(nonatomic,assign)KKPlayerStatus playerStatus;
@property(nonatomic,assign)NSTimeInterval duration;
@end

NS_ASSUME_NONNULL_END
