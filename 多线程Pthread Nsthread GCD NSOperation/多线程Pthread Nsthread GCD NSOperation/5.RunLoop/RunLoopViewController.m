//
//  RunLoopViewController.m
//  多线程Pthread Nsthread GCD NSOperation
//
//  Created by 戈强宝 on 2018/5/31.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

#import "RunLoopViewController.h"

@interface RunLoopViewController ()
@property(nonatomic,weak)NSTimer *timer;
/** 循环条件 */
@property(assign,nonatomic,getter=isFinished)BOOL finished;

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 1.RunLoop 和 定时器
- (IBAction)runloopClickOne:(UIButton *)sender {
    
    /*
     NSDefaultRunLoopMode - 时钟,网络事件;
     NSRunLoopCommonModes - 用户交互;
     */
    NSTimer *time = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    self.timer = time;
    //加入运行循环
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    
}
#pragma mark 2.RunLoop 和 定时器

- (IBAction)runLoopClickTwo:(UIButton *)sender {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer{
    static int num = 0;
    //如果时钟触发方法,执行非常耗的操作!!
    NSLog(@"%d  %@",num,[NSThread currentThread]);
}

#pragma mark 3.RunLoop 和 NSThread
- (IBAction)runLoopClickThree:(UIButton *)sender {
    //用alloc init 适用于自定义NSThread (子类)
    //    NSThread * t = [[NSThread alloc]init];
    
    NSThread * t1 = [[NSThread alloc]initWithTarget:self selector:@selector(demo) object:nil];
    [t1 start];
    self.finished = NO;
    
    //不执行地方原因,是因为 demo 方法执行的快!""
    [self performSelector:@selector(otherMethod) onThread:t1 withObject:nil waitUntilDone:NO];
    NSLog(@"234234");
    
}

-(void)demo{
    NSLog(@"%@",[NSThread currentThread]);
    //启动当前RunLoop  哥么就是一个死循环!!
    //使用这种方式,可以自己创建一个线程池!
    //    [[NSRunLoop currentRunLoop] run];
    
    //在OC中使用比较多的,退出循环的方式!
    while (!self.isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        
    }
    NSLog(@"能来吗???");
}
-(void)otherMethod{
    for (int i = 0; i<10; i++) {
        
        NSLog(@"%s %@",__func__,[NSThread currentThread]);
    }
    self.finished = YES;
}



-(void)viewDidDisappear:(BOOL)animated{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer =nil;
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
