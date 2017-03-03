//
//  RITLExportObject.h
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/3.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol RITLJSExport <NSObject,JSExport>
    
JSExportAs(say,
- (void)saySomething:(NSString *)thing
);
    
@end


@interface RITLExportObject : NSObject
    
@property (nonatomic, copy) void(^dosomething)(NSString *);
    
- (void)registerSelfToContext:(JSContext *)context;
    
@end

@interface RITLExportObject (RITLJSExport)
    
    
@end
