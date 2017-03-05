//
//  RITLExportObject.m
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/3.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLExportObject.h"

@implementation RITLExportObject
    
-(void)registerSelfToContext:(JSContext *)context
{
    context[@"RITLExportObject"] = self;
}
    
@end


@implementation RITLExportObject (RITLJSExport)
    
- (void)saySomething:(NSString *)thing
{
    if (self.dosomething) {
        self.dosomething(thing);
    }
}
    
@end
