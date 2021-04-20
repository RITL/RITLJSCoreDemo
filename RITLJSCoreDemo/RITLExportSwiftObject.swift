//
//  RITLExportSwiftObject.swift
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/5.
//  Copyright © 2017年 YueWen. All rights reserved.
//

import UIKit

@objc protocol RITLJSSwiftExport: JSExport {
    
    func say(_ something: String)
    
    func test(t: String) -> String
}



@objc class RITLExportSwiftObject: NSObject {

    var doSomething: ((String?) -> Void)?
    override init() {
        super.init()
    }
}



extension RITLExportSwiftObject : RITLJSSwiftExport {
    
    
    
    func say(_ something: String) {
        doSomething?(something)
    }
    
    func test(t: String) -> String {
        return t
    }
    
}
