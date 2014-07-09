//
//  Exchange.swift
//  ElongClient
//
//  Created by jian.zhao on 14-6-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

import UIKit
import Foundation

class Exchange: ElongBaseViewController,HttpUtilDelegate {

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization

    }
    
    init(title titleStr: String!, style: NavBarBtnStyle) {
        super.init(title:titleStr,style:style)

        loadNetData(false, requestCache: true)
    }

    func loadNetData(showAlert:Bool,requestCache:Bool){
    
        var req:NSDictionary = ["forceUpdate":requestCache]
        var paramJson:NSString  = req.JSONString()
        var url:NSString = PublicMethods.composeNetSearchUrl("mtools",forService:"exchangeRates",andParam:paramJson)
        
        var http = HttpUtil()
        http.requestWithURLString(url,content:nil,startLoading:showAlert,endLoading:showAlert,delegate:self)
    }
    
    //- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData;         // 请求完成


    func httpConnectionDidFinished(util: HttpUtil!, responseData: NSData!) {
    
        var root:NSDictionary  = PublicMethods.unCompressData(responseData)
//        if let some = Utils.checkJsonIsError(root) {
//            return;
//        }
        
        var dataArray:NSArray = root["rates"] as NSArray
        println(dataArray)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
