//
//  NSThreadViewController.m
//  多线程Pthread Nsthread GCD NSOperation
//
//  Created by 戈强宝 on 2018/5/30.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

//  并发编程!!Pthread NSThread   GCD NSOperation 并发技术!

#import "NSThreadViewController.h"
#import "LoadImageViewController.h"

@interface NSThreadViewController ()

/** 原子属性  */
@property(atomic,strong)NSObject *test;
@property(nonatomic,strong)NSObject *lock;
@property(nonatomic,assign) NSInteger tickets;


@end


@implementation NSThreadViewController
@synthesize test = _test;

- (void)viewDidLoad {
    [super viewDidLoad];
    _lock = [NSObject new];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loadImage:(UIButton *)sender {
    LoadImageViewController *vc = [[LoadImageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int index = -1;
    index ++;
    switch (7) {
        case 0:{
            [self threadDemo1];
        }
            break;
        case 1:{
            [self threadDemo2];
        }
            break;
        case 2:{
            [self threadDemo3];
        }
            break;
        case 3:{
            [self threadDemo4];
        }
            break;
        case 4:{
            [self exitDemo];
            
        }
            break;
        case 5:{
            [self threadDemo6];
        }
            break;
        case 6:{
            [self demo7];
        }
            break;
        case 7:{
            [self demo8];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 1.创建线程方式
-(void)threadDemo1{
    
    NSLog(@"A-------------");
    
    // 创建一个NSThread
    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(demo:) object:@"Thread"];
    //启动线程
    [thread start];
    for (int i = 0; i<10; i++) {
        NSLog(@"%d",i);
    }
    NSLog(@"B-------------");
}


#pragma mark  2.创建线程方式
-(void)threadDemo2{
    //1
    NSLog(@"A---%@",[NSThread currentThread]);
    
    //detach ==> 分离
    [NSThread detachNewThreadSelector:@selector(demo:) toTarget:self withObject:@"Detach"];
    //1
    NSLog(@"B---%@",[NSThread currentThread]);
}

#pragma mark 3.创建线程方式(线程通信)
-(void)threadDemo3{
    
    //1
    NSLog(@"A---%@",[NSThread currentThread]);
    
    //InBackground 就是在后台(子线程)运行!!
    //是NSObject的分类 意味着所有的基础NSObject的都可以使用这个方法
    //非常方便.不用NSThread对象
    [self performSelectorInBackground:@selector(demo:) withObject:@"background"];
    //1
    NSLog(@"B---%@",[NSThread currentThread]);
}

-(void)demo:(id)obj{
    for (int i = 0; i < 2; i++) {
        //!=1
        NSLog(@"C---------------%@",[NSThread currentThread]);
    }
}

#pragma mark  4.线程状态
-(void)threadDemo4{
    //创建线程
    NSThread * t = [[NSThread alloc]initWithTarget:self selector:@selector(theadStatus) object:nil];
    // 线程就绪(CPU翻牌)
    [t start];
}

-(void)theadStatus{
    for (int i = 0; i < 20;i++) {
        //阻塞,当运行满足某个条件,会让线程"睡一会"
        //提示:sleep 方法是类方法,会直接休眠当前线程!!
        if (i == 8) {
            NSLog(@"睡一会");
            [NSThread sleepForTimeInterval:2.0];
        }
        NSLog(@"%@  %d",[NSThread currentThread],i);
        
        //当线程满足某一个条件时,可以强行终止的
        //exit 类方法,哥么终止当前线程!!!!
        if (i == 15) {
            //一旦强行终止线程,后续的所有代码都不会被执行
            //注意:在终止线程执勤啊,应该要释放之前分配的对象!!
            [NSThread exit];
        }
    }
    NSLog(@"能来吗???");
}



#pragma mark  5.线程退出

-(void)exitDemo{
    [self performSelectorInBackground:@selector(starMainThread) withObject:nil];
    //注意!!! exit会杀掉主线程!但是APP不会挂掉!!
    [NSThread exit];
}

-(void)starMainThread{
    [NSThread sleepForTimeInterval:1.0];
    //开启主线程!!
    [[NSThread mainThread] start];
}

#pragma mark  6.线程属性
-(void)threadDemo6{
    NSThread * t = [[NSThread alloc]initWithTarget:self selector:@selector(demo:) object:nil];
    //在大型的商业项目中,通常希望程序在崩溃的时候,能够获取到程序准确的所以在的线程!
    t.name = @"Thread A";
    //优先级 从 0.0 -- 1.0  默认值 0.5
    /**  优先级翻转
     优先级 只是保证 CPU 调度的可能性会高!
     
     多线程目的:将耗时操作放在后台,不阻塞UI线程!
     建议:在开发的时候,不要修改优先级
     
     在多线程开发中,不要相信一次的运行结果!!
     */
    t.threadPriority = 0.1;
    [t start];
    
    NSThread * t1 = [[NSThread alloc]initWithTarget:self selector:@selector(demo6) object:nil];
    //在大型的商业项目中,通常希望程序在崩溃的时候,能够获取到程序准确的所以在的线程!
    t1.name = @"Thread B";
    t1.threadPriority = 1.0;
    [t1 start];
}
-(void)demo6{
    for (int i = 0; i < 20 ; i++) {
        NSLog(@"%@ %d",[NSThread currentThread],i);
    }
    //    if (![NSThread isMainThread]) {
    //        NSMutableArray * arr = [NSMutableArray array];
    //        [arr addObject:nil];
    //    }
    
}

#pragma mark 7.原子属性
-(void)setTest:(NSObject *)test{
    @synchronized(self){
        _test = test;
    }
}

-(NSObject *)test{
    return _test;
}

-(void)demo7{
    
    //nonatomic: 非原子属性
    //atomic   : 原子属性,保证这个属性的安全性(线程安全),就是针对多线程设计的!
    //原子属性的目的:多个线程写入这个对象的时候,保证同一时间只有一个线程能够执行!
    //单写多读的一种多线程技术,同样有可能出现"脏数据",重新读一下.
    
    /*
     OC 中定义属性,通常会生成 _成员变量 如果同时重写了getter&setter _成员变量 就不自动生成!
     @synthesize 合成指令,在Xcode4.5 之前非常常见.
     
     */
    
    
    /**
     实际上,原子属性内部有一个锁,自旋锁
     自旋锁 & 互斥锁
     - 共同点:
     都能够保证线程安全.
     - 不同点:
     互斥锁:如果线程被锁在外面,哥么就会进入休眠状态,等待锁打开,然后被唤醒!
     自旋锁:如果线程被锁在外面,哥么就会用死循环的方式,一直等待锁打开!
     
     无论什么锁,都很消耗新能.效率不高
     
     
     * 线程安全
     在多个线程进行读写操作时,仍然保证数据正确!
     
     * UI 线程,共同约定:所有更新UI 的操作都放在主线程上执行!
     原因:UIKit框架都是线程不安全的!!(因为线程安全效率下降!)
     
     */
    NSData * data ;
    //原子属性 == YES 先把文件保存在一个临时的文件中,等全部写入之后,再改名
    [data writeToFile:@"hank.mp4" atomically:YES];
    
}


#pragma mark 8.@synchronized 互斥锁
-(void)demo8{
    self.tickets = 20;
    NSThread *t1 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
    t1.name = @"A";
    NSThread *t2 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
    t2.name = @"B";
    [t1 start];
    [t2 start];
    
    
}

-(void)saleTickets{
    while (YES) {
        [NSThread sleepForTimeInterval:0.1];
        @synchronized(_lock){
            //互斥锁 -- 保证锁内的代码,同一时间,只有一条线程执行!
            //互斥锁 的范围 应该尽量小,范围大了 效率就差!!
            //1.判断是否有票
            //参数:任意OC对象都OK!一般用self!全局对象
            //局部变量,每一个线程单独拥有的,因此没法加锁!!!
            if (self.tickets > 0) {
                //2.如果有就卖一张
                self.tickets--;
                NSLog(@"剩下%d张票  %@",self.tickets,[NSThread currentThread]);
            }else{
                //3.如果没有了,提示用户
                NSLog(@"卖完了! %@",[NSThread currentThread]);
                break;
            }
        }
    }
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

















