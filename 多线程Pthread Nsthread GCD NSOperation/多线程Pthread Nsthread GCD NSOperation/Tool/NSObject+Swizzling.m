//
//  NSObject+Swizzling.m
//  Runtime0424
//
//  Created by 戈强宝 on 2018/4/25.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/message.h>

@implementation NSObject (Swizzling)

+(void)methodExchangeWithOriginSelector:(SEL)originSElector byNewSelector:(SEL)newSElector{
    //在类方法里面 self 代表类
    NSLog(@"%@",self);
    NSLog(@"%@",[self class]);
    Method originMethod = class_getInstanceMethod(self, originSElector);
    Method newMethod = class_getInstanceMethod(self, newSElector);
    
    
    //让原先方法指向新的实现
    BOOL didAddMethod = class_addMethod(self, originSElector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        //新的方法指向原先的实现
        class_replaceMethod(self, newSElector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, newMethod);
    }
}




@end
