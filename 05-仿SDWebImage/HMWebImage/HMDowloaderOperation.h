//
//  HMDowloaderOperation.h
//  05-仿SDWebImage
//
//  Created by ItHeiMa on 2017/6/5.
//  Copyright © 2017年 itHeima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDowloaderOperation : NSOperation


+(instancetype)dowloaderWithUrlStr:(NSString *)urlStr andSuccess:(void(^)(UIImage *))successBlock;

@end
