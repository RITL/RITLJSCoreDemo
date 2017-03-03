//
//  ViewController.swift
//  RITLJSCoreDemo
//
//  Created by YueWen on 2017/3/2.
//  Copyright © 2017年 YueWen. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

// 设置为true表示使用WKWebView，false表示使用UIWebView
let ritl_useWkWebView = true




class RITLJSWebViewController: UIViewController {
    
    
    // 使用WkWebView
    lazy var wkWebView : WKWebView = {
        
        let webView: WKWebView = WKWebView(frame: self.view.bounds)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.configuration.userContentController.add(RITLSciptMessageHandler(self), name: "ChangedMessage")// 添加处理
        
        return webView
    }()
    

    
    // 使用UIWebView
    lazy var webView : UIWebView = {
       
        let webView: UIWebView = UIWebView(frame: self.view.bounds)
        
        webView.backgroundColor = .white
        webView.delegate = self
        
        return webView
    }()
    
    
    // MARK: 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 通过contenxt运行javaScript
        __testValueInContext()
        
        // Swift-javaScript使用iOS客户端的代码 - 目前貌似不支持Swift
        __textJavaScriptUseSwift()
        
        // ObjC - javaScript使用iOS客户端的代码
        __textJavaScriptUseObjc()
        
        
        //记载本地网页
        let path = Bundle.main.path(forResource: "index", ofType: "html")
        let request = URLRequest(url: URL(fileURLWithPath: path!))
        
        //设置本地导航
        navigationItem.title = ritl_useWkWebView ? "WKWebView" : "UIWebView"
        
        //进行加载
        if ritl_useWkWebView {
            
            __loadWKWebView(request)
        }else {
            
            __loadUIWebView(request)
        }
        
    }

    
    deinit {
        print("\(type(of: self)) deinit")
        
        
        if ritl_useWkWebView {
            wkWebView.configuration.userContentController.removeAllUserScripts()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: JSContext/JSValue
    func __testValueInContext(){
        
        /**
         该方法的作用:个人感觉就是通过初始化JSContext对象，获得运行javaScript的环境.
         在此就可以运行常用的js代码（可以把JSContext当做一个游览器环境，在此运行js脚本）
         */
        
        
        let context = JSContext()

        //编写javaScript代码
//        let _ = context?.evaluateScript("var textnumber = 1")
//        let _ = context?.evaluateScript("var names = ['Yue','Xiao','Wen']")
//        let _ = context?.evaluateScript("var triple = function(value){ return value + 3 }")
//        let returnValue = context?.evaluateScript("triple(3)") //因为有返回值，需要接收一下
        
        //使用ES6,在当前环境下效果是一样的，详细可见ES6
        let _ = context?.evaluateScript("var textnumber = 1")//如果单纯的运行这几句，使用let关键词也是可以的，使用var是因为下面获取创建的变量，原因见下面注释.
        let _ = context?.evaluateScript("var names = ['Yue','Xiao','Wen']")
        let _ = context?.evaluateScript("var triple = (value) => value + 3")
        let returnValue = context?.evaluateScript("triple(3)") //因为有返回值，需要接收一下
        
        //打印结果:returnValue = Optional(6)
        print("__testValueInContext --- returnValue = \(returnValue?.toNumber())")
        
        
        
        ///获得context创建的变量 
        
        /**
         注: 这里能获取的变量必须为var定义的当前环境的全局变量，使用const以及ES6的let关键词声明则获取不到
         */
        
        //通过变量名字获取对象
        let names = context?.objectForKeyedSubscript("names")
        
        //通过定义顺序的下标获取对象
        let firstName = names?.objectAtIndexedSubscript(0) //Yue
        
        //打印结果:names = Optional([Yue, Xiao, Wen])
        print("__testValueInContext --- names = \(names?.toArray())\nfirstName = \(firstName)")
        
        
        
        /// 获得context创建的函数变量
        let function = context?.objectForKeyedSubscript("triple")
        
        //运行
        let result = function?.call(withArguments: [3])
        
        //打印结果:context-function's result = Optional(6)
        print("__testValueInContext --- context-function's result = \(result?.toNumber())")
        
        
        /// 捕获JS运行错误
        context?.exceptionHandler = {(context,exception) in
            
            //打印错误
            print("__testValueInContext --- JS error = \(exception)\n")
        }
        
        
        /**
         执行一个错误的js,因为没有函数Triple,会调用上面的exceptionHandler
         打印结果: JS error = Optional(ReferenceError: Can't find variable: Triple)
         */
        let _ = context?.evaluateScript("Triple(3)")
    }
    
    
    
    // MARK: JavaScript use iOS with Swift   ---  Failture
    func __textJavaScriptUseSwift(){
        
        let context = JSContext()
        
        //初始化一个闭包
        let stringHandler : (String) -> String = { (value) in
            
            var value = value
            
            value.append(" I am appending word with closure!")
            
            return value
        }
        
        //封装成JSValue
        let handerValue = JSValue(object: stringHandler, in: context)
        
        context?.setObject(handerValue, forKeyedSubscript: "stringHandler" as NSString)
        
        let result = context?.evaluateScript("stringHandler('Hello')")
        
        // 结果：undefined - - 很无解有没有！！！！
        print("I am Swift ,result = \(result?.toString())\n")
    }
    
    
    
    // MARK: JavaScript use iOS with ObjC   --- Success
    func __textJavaScriptUseObjc(){
        
        let result = RITLJSCoreObject.textJavaScriptUseiOS(inObjC: "Hello")
        
        print("I am Objc, result = \(result?.toString())\n")
        
    }
    
    
    // MARK: UIWebView
    func __loadUIWebView(_ request:URLRequest) {
        
        view.addSubview(webView)
        
        
        
        webView.loadRequest(request)
    }
    
    
    // MARK: wkWebView
    func __loadWKWebView(_ request:URLRequest){
        
        view.addSubview(wkWebView)
        
        
        
        wkWebView.load(request)
    }
    
}


// MARK: UIWebView-Delegate 系列
extension RITLJSWebViewController : UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //获得JSContent对象
        guard  let context : JSContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext? else {
            return
        }
        
        //告诉web，这里是UIWebView
        context.evaluateScript("sureType('UIWebView')")
        
        //初始化一个Export对象
        let exportObject = RITLExportObject()
        
        exportObject.dosomething = { [weak self](value) in
            
            self?.navigationItem.title = value
            
            //回应
            
        }
        
        exportObject.registerSelf(to: context)
        
        let i = 0
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print("error = \(error.localizedDescription)")
    }
}



// MARK: WKWebView-Delegate 系列
extension RITLJSWebViewController : WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        //如果body体是约定好的字符串，并且通过标志ChangedMessage传递并且存在body体
        guard message.body is String,message.name ==  "ChangedMessage",let body:String = message.body as? String else { return }
        
        //设置导航
        navigationItem.title = body
        
        //执行通知HTML
        wkWebView.evaluateJavaScript("iosTellSomething('已将\(body)设置成导航Title')") { (_, error) in
            
            print("error = \(error?.localizedDescription)")
        }
    }
}



// 是为了使用JS确认一下类型，实际开发不需要在这个代理下进行如下操作
extension RITLJSWebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
        //确认类型
        webView.evaluateJavaScript("sureType('WKWebView')", completionHandler: nil)
    }
}


extension RITLJSWebViewController : WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        
        print("alert = \(message)")
        
        completionHandler()
    }

}


