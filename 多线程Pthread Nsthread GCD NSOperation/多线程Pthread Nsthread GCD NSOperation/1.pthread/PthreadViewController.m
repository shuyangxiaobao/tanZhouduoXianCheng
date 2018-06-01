//
//  PthreadViewController.m
//  多线程Pthread Nsthread GCD NSOperation
//
//  Created by 戈强宝 on 2018/5/30.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

#import "PthreadViewController.h"
#import <pthread.h>

@interface PthreadViewController ()

@end

@implementation PthreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int index = -1;
    index ++;
    switch (index%5) {
        case 0:{
            [self pthreadDemo];
        }
            break;
        default:
            break;
    }
}

#pragma mark 1.pthread 使用
-(void)pthreadDemo{
    
    /**
     pthread 是属于 POSIX 多线程开发框架
     
     参数:
     1.指向线程代号的指针
     2.线程的属性
     3.指向函数的指针
     4.传递给该函数的参数
     
     返回值
     - 如果是0,标示正确
     - 如果非0,标示错误代码
     
     void *   (*)      (void *)
     返回值   (函数指针)  (参数)
     void *  和OC中的  id 是等价的!
     
     
     */
    NSString * str = @"hello Hank";
    pthread_t threadId;
    /**
     - 在 ARC 开发中,如果涉及到和C语言中的相同的数据类型进行转换,需要使用 __bridge "桥接"
     - 在 MRC 不需要
     */
    
    int result = pthread_create(&threadId, NULL, &demo, (__bridge  void *)(str));
    
    if (result == 0) {
        NSLog(@"OK");
    }else{
        NSLog(@"error %d",result);
    }
    
    
    
}

void * demo(void * param){
    NSLog(@"%@ %@",[NSThread currentThread],param);
    
    return NULL;
}




@end
