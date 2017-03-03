//
//  RITLJSCoreObject.h
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/2.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


/// 用于使用ObjC的注入
@interface RITLJSCoreObject : NSObject


/// 使用Objc进行block注入
+ (JSValue *)textJavaScriptUseiOSInObjC:(NSString *)value;

@end





