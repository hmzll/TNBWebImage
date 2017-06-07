//
//  ViewController.m
//  05-仿SDWebImage
//
//  Created by ItHeiMa on 2017/6/5.
//  Copyright © 2017年 itHeima. All rights reserved.
//

#import "ViewController.h"
#import "HMDowloaderOperation.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "HMAppInfo.h"

@interface ViewController ()

@property (nonatomic,strong)NSOperationQueue *queue;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,copy)NSString *lastUrl;


@property (nonatomic,strong)NSMutableDictionary *opCaches;

@end

@implementation ViewController{
    
    NSArray<HMAppInfo *> *_appList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadJasonData];

    self.queue = [NSOperationQueue new];
    
    _opCaches = [NSMutableDictionary dictionary];

    /*
    //操作对象下载完图片后能调用
    HMDowloaderOperation *op = [HMDowloaderOperation new];
    
    //给它图片下载地址
    op.urlStr = @"http://www.itheima.com/images/logo.png";
    
    //传入下载图片成功后调用的block
    op.successBlock = ^(UIImage *img){
        
        _imageView.image = img;
    };
    
    //队列会自动安排子线程来调度你这个操作(调度你操作里的main方法)
    [self.queue addOperation:op];
    */
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //随机数获得随机索引
    int index = arc4random_uniform((u_int32_t)_appList.count);
    
    //随机取到实体类
    HMAppInfo *app = _appList[index];

    NSLog(@"%@", app.icon);

    //如果上一次的网址跟这次取到的网址不一样,我就取消上一条操作
    //并且需要不是第一次来才做这个判断
    if (![_lastUrl isEqualToString:app.icon] && _lastUrl != nil) {
        
        //取消上一条操作 调用operation对象的cancel方法,不会取消操作,它只是把任务的isCancelled属性改为YES而已
        //所以,如果需要取消,我们还必须在op对象的内部根据isCancelled来做一些处理
        [_opCaches[_lastUrl] cancel];
        
        //如果取消了就没必要再留在缓存池里了
        [_opCaches removeObjectForKey:_lastUrl];
    }
    
        //通过类方法创建对象并传递数据
    HMDowloaderOperation *op = [HMDowloaderOperation dowloaderWithUrlStr:app.icon andSuccess:^(UIImage *img) {
        
        _imageView.image = img;
    }];
    
    [_opCaches setObject:op forKey:app.icon];
    
    _lastUrl = app.icon;

    
    [self.queue addOperation:op];
}


-(void)loadJasonData{
    
    //创建一个网络请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //get
    
    //参数1:网址(字符串)
    //参数2:请求参数(nil)
    //参数3:进度(nil)
    //参数4:网络资源请求后成功后会调用的block
    //参数5:失败调用的block(nil)
    
    //自己以异步的方式帮你去加载数据的
    //并且加载完以后,会自动以主线程调用成功的block,所以只要在成功的block里刷新UI就可以了
    [manager GET:@"https://raw.githubusercontent.com/hmzll/szios10/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        _appList = [NSArray yy_modelArrayWithClass:[HMAppInfo class] json:responseObject];

        
    } failure:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
