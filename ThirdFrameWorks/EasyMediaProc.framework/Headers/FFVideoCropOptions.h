//
//  FFVideoCropOptions.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/5/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFVideoCropOptions : NSObject
@property(nonatomic)CGPoint position; // 如果不指定，则默认居中裁剪
@property(nonatomic)CGSize size;
@end

NS_ASSUME_NONNULL_END
