//
//  RITLJSCoreObject.m
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/2.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLJSCoreObject.h"

@implementation RITLJSCoreObject


+(JSValue *)textJavaScriptUseiOSInObjC:(NSString *)value
{
    JSContext * context = [JSContext new];
    
    //设置block
    context[@"stringHandler"] = ^(NSString * oldValue){
        
        NSMutableString * valueHandler = [[NSMutableString alloc]initWithString:oldValue];
        
        [valueHandler appendString:@" I am append String"];
        
        return valueHandler;
    };
    
    NSString * js = [NSString stringWithFormat:@"stringHandler('%@')",value];
    
    //注入
    return [context evaluateScript:js];
    
}


@end

