//
//  KKVideoCapturePreview.h
//  EasyMediaProc
//
//  Created by yujianwu on 2022/5/1.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKVideoCapturePreview : UIView
@property(nonatomic,assign) AVLayerVideoGravity videoGravity;
- (instancetype)initWithSession:(AVCaptureSession __weak*)session videoGravity:(AVLayerVideoGravity)gravity;
- (void)updateSession:(AVCaptureSession __weak*)session videoGravity:(AVLayerVideoGravity)gravity;
@end

NS_ASSUME_NONNULL_END
