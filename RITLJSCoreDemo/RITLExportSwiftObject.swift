//
//  RITLExportSwiftObject.swift
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/5.
//  Copyright © 2017年 YueWen. All rights reserved.
//

import UIKit

protocol RITLJSSwiftExport {
    
    func saySomething(something:String)
}



class RITLExportSwiftObject: NSObject {

    var doSomething: ((String?) -> Void)?
    
    override init() {
        super.init()
    }
}



extension RITLExportSwiftObject : RITLJSSwiftExport {
    
    func saySomething(something: String) {
        
        doSomething?(something)
    }
}
