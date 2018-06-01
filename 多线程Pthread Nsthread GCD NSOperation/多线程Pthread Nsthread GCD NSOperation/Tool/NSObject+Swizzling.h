//
//  NSObject+Swizzling.h
//  Runtime0424
//
//  Created by 戈强宝 on 2018/4/25.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

/**
 方法交换

 @param originSElector originSElector
 @param newSElector newSElector
 */
+(void)methodExchangeWithOriginSelector:(SEL) originSElector byNewSelector:(SEL) newSElector;
@end
