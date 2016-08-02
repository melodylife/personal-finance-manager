//
//  Login.swift
//  Personal Financial Management
//
//  Created by chsun on 6/25/16.
//  Copyright © 2016 Chang Sun. All rights reserved.
//

import Foundation

class RESTService{
    
    let httpHandler:HTTPRequestCaller = HTTPRequestCaller()
    
    func loginVerify(_ userID: String , pwd: String) -> Bool{
        let queryParams = ["userid":userID , "password":pwd]
        let httpHandler:HTTPRequestCaller = HTTPRequestCaller()
        let hpMethod = HTTP_METHOD.GET
        let (rst , jsonRst) = httpHandler.httpCall("appinit/login", queryPara: queryParams, httpMethod: hpMethod.rawValue, uploadData: nil)
        
        if(rst){
            if let httpRst = jsonRst?.getValue("result") as? String{
                return (REST_RESULT.verified.rawValue == Int(httpRst))
            }
            else{
                return false
            }
        }
        else{
            print("Failed to call the service")
            return false
        }
        
    }
    
    func  regNewUser(_ emailAddr: String , pwd: String) -> Void {
        //Please do use _id since this is the default key of mongoDB
        let rawData = ["_id":emailAddr , "password":pwd]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: rawData, options: .prettyPrinted)
            let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            if let encodeStr = jsonStr?.data(using: String.Encoding.utf8.rawValue){
                let base64Data = encodeStr.base64EncodedData(options: .lineLength64Characters)
                let (blRst , jsonRst) = httpHandler.httpCall("appinit/reg", queryPara: [:],  httpMethod: HTTP_METHOD.POST.rawValue , uploadData: base64Data)
                if(blRst){
                    if let httpRst = jsonRst?.getValue("result"){
                        print(httpRst)
                    }
                }
            }
        }
        catch{
            print(error)
            return
        }

    }
}
