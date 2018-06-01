//
//  GCDViewController.m
//  多线程Pthread Nsthread GCD NSOperation
//
//  Created by 戈强宝 on 2018/5/30.
//  Copyright © 2018年 戈强宝. All rights reserved.
//


/**
 GCD 核心概念:将任务添加到队列,指定任务执行的方法
 - 任务
 - 使用block 封装
 - block 就是一个提前准备好的代码块,在需要的时候执行
 - 队列(负责调度任务)
 - 串行队列: 一个接一个的调度任务
 - 并发队列: 可以同时调度多个任务
 - 任务执行函数(任务都需要在线程中执行!!)
 - 同步执行: 不会到线程池里面去获取子线程!
 - 异步执行: 只要有任务,哥么就会到线程池取子线程!(主队列除外!)
 小结:
 - 开不开线程,取决于执行任务的函数,同步不开,异步才能开
 - 开几条线程,取决于队列,串行开一条,并发可以开多条(异步)
 */





/*
 全局队列 & 并发队列
 1> 名称,并发队列取名字,适合于企业开发跟踪错误
 2> release,在MRC 并发队列 需要使用的
 dispatch_release(q);//ARC 情况下不需要release !
 
 
 全局队列 & 串行队列
 全局队列: 并发,能够调度多个线程,执行效率高
 - 费电
 串行队列:一个一个执行,执行效率低
 - 省点
 
 判断依据:用户上网方式
 - WIFI : 可以多开线程
 - 流量  : 尽量少开线程
 
 */

#import "GCDViewController.h"
#import "GCDLoadViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- 1.同步执行方法,这句话不执行完,就不会执行下一个任务,同步执行不会开启线程

- (IBAction)gcdDemo1:(UIButton *)sender {
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    void(^task)(NSInteger index)= ^(NSInteger index){
        NSLog(@"%@ 000",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"111");
        NSLog(@"index = %ld",(long)index);
    };
    dispatch_sync(q, ^{
        task(10);
    });
    NSLog(@"22222");
}
/**
 异步执行任务  哥么如果任务没有执行完毕,可以不用等待,异步执行下一个任务
 具备开启线程的能力!  异步通常又是多线程的代名词!!
 */
#pragma mark- 2.在全局队列开启异步执行任务
- (IBAction)gcdDemo2:(UIButton *)sender {
    //1.创建队列
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    //2 定义任务 -- block
    void(^task)(void) = ^(void) {
        NSLog(@"%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    };
    //3. 添加任务到队列
    dispatch_async(q, task);
    NSLog(@"最后执行");
}

#pragma mark- 3.回归主线程
- (IBAction)gcdDemo3:(UIButton *)sender {
    //指定任务执行方法 -- 异步
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"111111%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回归主线程 222222%@",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:3];
        });
        NSLog(@"444444");
    });
    NSLog(@"3333333%@",[NSThread currentThread]);
}
#pragma mark- 4.GCD下载图片
- (IBAction)gcdDemo4:(UIButton *)sender {
    GCDLoadViewController *vc= [[GCDLoadViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 5.串行队列,同步任务
/**
 *   不会开启线程,会顺序执行
 */
- (IBAction)gcdDemo5:(UIButton *)sender {
    //1.队列 - 串行
    
    /**
     1.队列名称:
     2.队列的属性: DISPATCH_QUEUE_SERIAL 标示串行!
     */
    
    dispatch_queue_t q = dispatch_queue_create("ios1", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(q, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"%@",[NSThread currentThread]);
        }
    });
    
    
}
#pragma mark- 6.串行队列,异步任务

- (IBAction)gcdDemo6:(UIButton *)sender {
    /**
     会开几条线程?会顺序执行吗?
     开一条线程，会顺序执行
     */
    //1.队列 - 串行
    dispatch_queue_t q = dispatch_queue_create("queue6", DISPATCH_QUEUE_SERIAL);
    for (NSUInteger i = 0; i<10; i++) {
        dispatch_async(q, ^{
            NSLog(@"%lu     %@",(unsigned long)i,[NSThread currentThread]);
        });
    }
    //哥么在主线程!
    NSLog(@"come here");
}

#pragma mark- 7.并发队列,异步执行

- (IBAction)gcdDemo7:(UIButton *)sender {
    // 会开线程吗?  顺序执行?  come here?
    //  会          并发执行      不一定
    dispatch_queue_t q = dispatch_queue_create("queue7", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i< 10; i++) {
        dispatch_async(q, ^{
            [NSThread sleepForTimeInterval:0.1];
            NSLog(@"%ld   %@",(long)i,[NSThread currentThread]);
        });
    }
    //哥么在主线程!
    NSLog(@"come here  %@",[NSThread currentThread]);
 }

#pragma mark- 8.并发队列,同步执行
- (IBAction)gcdDemo8:(UIButton *)sender {
    // 会开线程吗?  顺序执行?  come here?
    //  不会          顺序     最后
    dispatch_queue_t q = dispatch_queue_create("queue8", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i< 10; i++) {
        dispatch_sync(q, ^{
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"%d    %@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"come here");
}


//MARK - 同步任务作用!
/**
 在开发中,通常会将耗时操作放后台执行,有的时候,有些任务彼此有"依赖"关系!
 
 例子: 登录,支付,下载
 
 利用同步任务,能够做到任务依赖关系,前一个任务是同步任务,哥么不执行完,队列就不会调度后面的任务
 */
#pragma mark- 9.同步任务作用
- (IBAction)gcdDemo9:(UIButton *)sender {
    dispatch_queue_t loginQueue = dispatch_queue_create("tanzhouios", DISPATCH_QUEUE_CONCURRENT);
    //1.用户登录
    dispatch_sync(loginQueue, ^{
        NSLog(@"用户登录  %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    });
    
    //2.支付
    dispatch_async(loginQueue, ^{
        NSLog(@"支付  %@",[NSThread currentThread]);
    });
    //3.下载
    dispatch_async(loginQueue, ^{
        NSLog(@"下载  %@",[NSThread currentThread]);
    });
}

//MARK : 增强版同步任务
// 可以队列调度多个任务前,指定一个同步任务,让所有的异步任务,等待同步任务执行完成,这就是依赖关系
// - 同步任务,会造成一个死锁!
#pragma mark- 10.增强版同步任务
- (IBAction)gcdDemo10:(UIButton *)sender {
    //队里
    dispatch_queue_t q = dispatch_queue_create("tanzhouios", DISPATCH_QUEUE_CONCURRENT);
    //任务
    void (^task)(void)=^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"%d   %@",i ,[NSThread currentThread]);
        }
        //1.用户登录
        dispatch_sync(q, ^{
            NSLog(@"用户登录  %@",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        });
        //2.支付
        dispatch_async(q, ^{
            NSLog(@"支付  %@",[NSThread currentThread]);
        });
        //3.下载
        dispatch_async(q, ^{
            NSLog(@"下载  %@",[NSThread currentThread]);
        });
        
        
    };
    dispatch_async(q, task);
    //    NSLog(@"come here");
}
#pragma mark- 11.  全局队列 (本质上并发队列)
//MARK:  全局队列 (本质上并发队列)
- (IBAction)gcdDemo11:(UIButton *)sender {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"1111111");
    });
    
//    NSLog(@"0000000");
    return;
    
    //全局队列
    /* 参数
     1. 涉及到系统适配
     iOS 8   服务质量
     QOS_CLASS_USER_INTERACTIVE    用户交互(希望线程快速被执行,不要用好使的操作)
     QOS_CLASS_USER_INITIATED      用户需要的(同样不要使用耗时操作)
     QOS_CLASS_DEFAULT             默认的(给系统来重置队列的)
     QOS_CLASS_UTILITY             使用工具(用来做耗时操作)
     QOS_CLASS_BACKGROUND          后台
     QOS_CLASS_UNSPECIFIED         没有指定优先级
     iOS 7  调度的优先级
     - DISPATCH_QUEUE_PRIORITY_HIGH 2               高优先级
     - DISPATCH_QUEUE_PRIORITY_DEFAULT 0            默认优先级
     - DISPATCH_QUEUE_PRIORITY_LOW (-2)             低优先级
     - DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN 后台优先级
     
     提示:尤其不要选择BACKGROUND 优先级,服务质量,线程执行会慢到令人发指!!!
     
     
     2. 为未来使用的一个保留,现在始终给0.
     
     老项目中,一般还是没有淘汰iOS 7  ,没法使用服务质量
     */
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i< 10; i++) {
        dispatch_async(q, ^{
            NSLog(@"%@  %d",[NSThread currentThread],i);
        });
    }
    NSLog(@"come here");
}


#pragma mark- 12.全局队列,同步执行
- (IBAction)gcdDemo12:(UIButton *)sender {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"000000 %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    });
    NSLog(@"1111111  %@",[NSThread currentThread]);
}

#pragma mark- 13.全局队列,异步执行
- (IBAction)gcdDemo13:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"000000 %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    });
    NSLog(@"1111111  %@",[NSThread currentThread]);
}

#pragma mark- 14.主队列，同步执行(会奔溃)
//会等待主线程上的任务执行结束，才会执行该任务，但是主线程永远不会执行结束(除非杀掉进程),于是形成了死锁

- (IBAction)gcdDemo14:(UIButton *)sender {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"000000 %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    });
    NSLog(@"1111111  %@",[NSThread currentThread]);
}

#pragma mark- 15.主队列，异步执行
- (IBAction)gcdDemo15:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"000000 %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    });
    NSLog(@"1111111  %@",[NSThread currentThread]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

















