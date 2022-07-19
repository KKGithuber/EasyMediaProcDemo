//
//  FFmpegTools.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/4/26.
//

#import <Foundation/Foundation.h>
#import "FFAudioOptions.h"
#import "FFVideoOptions.h"
#import "FFVideoCropOptions.h"
#import "FFRange.h"
#import "KKCommonHeader.h"
#import "CmdCustomUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFmpegTools : NSObject

+ (instancetype)shareInstance;

- (void)rotateVideoWithPI:(NSString *)pi
                inputPath:(NSString *)inputPath
               outputPath:(NSString *)outputPath
                    range:(nullable FFRange *)range
                completed:(CompletedHandler)completedBlock;

- (void)convertAudio:(NSString *)inputPath
          outputPath:(NSString *)outputPath
           audioType:(KKAudioType)audioType
             options:(nullable FFAudioOptions *)options
           completed:(CompletedHandler)completedBlock;

- (void)convertVideo:(NSString *)inputPath
          outputPath:(NSString *)outputPath
           videoType:(KKVideoType)videoType
             options:(nullable FFVideoOptions *)options
           completed:(CompletedHandler)completedBlock;

- (void)captureVideoCover:(NSString *)inputPath
               outputPath:(NSString *)outputPath
                    range:(nullable FFRange *)range
                completed:(CompletedHandler)completedBlock;

- (void)speedPlay:(NSString *)inputPath
       outputPath:(NSString *)outputPath
             rate:(KKSpeedRate)rate
        completed:(CompletedHandler)completedBlock;

- (void)videoCrop:(NSString *)inputPath
       outputPath:(NSString *)outputPath
      cropOptions:(FFVideoCropOptions *)cropOptions
        completed:(CompletedHandler)completedBlock;

- (void)scaleVideo:(NSString *)inputPath
        outputPath:(NSString *)outputPath
             scale:(CGFloat)scale
         completed:(CompletedHandler)completedBlock;

- (void)runCmd:(NSString *)commandStr completionBlock:(void(^)(NSInteger result))completionBlock;

- (void)registerProgressHandler:(ProgressHandler)hadnler;

@end

NS_ASSUME_NONNULL_END
