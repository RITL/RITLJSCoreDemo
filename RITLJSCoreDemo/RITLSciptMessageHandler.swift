//
//  RITLSciptMessageHandler.swift
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/3.
//  Copyright © 2017年 YueWen. All rights reserved.
//

import UIKit
import WebKit


/// 避免直接使用WKScriptMessageHandler引起内存泄露
class RITLSciptMessageHandler : NSObject
{

    weak var delegate : WKScriptMessageHandler?
    
    init(_ delegate:WKScriptMessageHandler?) {
        
        super.init()
        
        self.delegate = delegate
    }
}


extension RITLSciptMessageHandler : WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
       delegate?.userContentController(userContentController, didReceive: message)
    }
}
