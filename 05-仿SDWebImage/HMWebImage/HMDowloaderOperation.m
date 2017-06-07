//
//  HMDowloaderOperation.m
//  05-仿SDWebImage
//
//  Created by ItHeiMa on 2017/6/5.
//  Copyright © 2017年 itHeima. All rights reserved.
//

#import "HMDowloaderOperation.h"

@interface HMDowloaderOperation ()

@property (nonatomic,copy)NSString *urlStr;

@property (nonatomic,copy)void(^successBlock)(UIImage *img);

@end

@implementation HMDowloaderOperation


+(instancetype)dowloaderWithUrlStr:(NSString *)urlStr andSuccess:(void (^)(UIImage *))successBlock{
    
    HMDowloaderOperation *op = [[self alloc] init];
    
    op.urlStr = urlStr;
    
    op.successBlock = successBlock;
    
    return op;
}


//队列执行的入口
//把操作添加到队列后,队列会自己来执行你这个操作,就是从main里执行
//只不过默认的main方法里面什么都没有实现
-(void)main{
    
    //用这个类去下载图片的
    //就应该在这里去下载图片
    //下载图片需要什么?网址,现在有吗?没有
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *img = [UIImage imageWithData:data];
    
    //下载图片后调用成功的block
    //调用block时,是在什么线程下调用的,那么执行block的时候,也是这个线程
    
    if(self.isCancelled){
        
        return;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.successBlock(img);
    }];
    
}

@end
