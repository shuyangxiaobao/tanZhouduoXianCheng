//
//  UIViewController+life.m
//  Runtime0424
//
//  Created by 戈强宝 on 2018/4/25.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

#import "UIViewController+life.h"
#import <objc/message.h>
#import "NSObject+Swizzling.h"

@implementation UIViewController (life)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [UIViewController meth]
        [UIViewController methodExchangeWithOriginSelector:@selector(viewWillAppear:) byNewSelector:@selector(life_viewWillAppear:)];

    });
}

-(void)life_viewDidLoad{
    [self life_viewDidLoad];
    NSString *className = NSStringFromClass([self class]);
    //    NSLog(@"🐱🐱🐱🐱 viewDidLoad 初始化控制器:%@",className);
}

-(void)life_viewWillAppear:(BOOL)animated{
    [self life_viewWillAppear:animated];
    NSString *className = NSStringFromClass([self class]);
    if([className containsString:@"NavigationController"]){
        return;
    }
    NSLog(@"🐱🐱🐱🐱 viewWillAppear 即将进入控制器:%@",className);
}

-(void)life_viewWillDisappear:(BOOL)animated{
    [self life_viewWillDisappear:animated];
    NSString *className = NSStringFromClass([self class]);
    //    NSLog(@"🐱🐱🐱🐱 即将离开控制器:%@",className);
}


@end
