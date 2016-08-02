//
//  HTTPRequestCaller.swift
//  Personal Financial Management
//
//  Created by chsun on 7/1/16.
//  Copyright © 2016 Chang Sun. All rights reserved.
//

import Foundation


class HTTPRequestCaller{

    var serviceURL: String? = nil
    init(){
        if let infoPlist = Bundle.main.infoDictionary{
            serviceURL = infoPlist["Service URL"] as? String
        }
    }
    
    let semaphore = DispatchSemaphore(value: SEMAHORE.http_CALL.rawValue)
    
    //Check the availability of service
    func isConnected() -> Bool {
        let path = "healthcheck"
        let method = HTTP_METHOD.GET.rawValue
        
        let (blRst , jsonRst): (Bool , JsonParser?) = httpCall(path, queryPara: [:], httpMethod: method, uploadData: nil)
        
        //The getValue returns AnyObject. So it needs explicitly type casting. 
        return blRst && (REST_RESULT.success.rawValue == Int(jsonRst!.getValue("result") as! NSNumber))
    }
    
    //Universal http request handler
    func httpCall(_ handlerPath: String , queryPara:[String:String] , httpMethod:HTTP_METHOD.RawValue , uploadData:Data?) -> (Bool , JsonParser?){
        var runTup:(Bool , JsonParser?) = (false , nil)
        
        if(nil == serviceURL){
            return runTup
        }
        
        //Construct query string
        var queryStr =  (0 == queryPara.count) ? "" : "?"
        if (queryPara.count != 0){
            for (key , value) in queryPara{
                queryStr = "\(queryStr)\(key)=\(value)&"
            }
        }
        let urlStr = "\(serviceURL!)/\(handlerPath)\(queryStr)"
        
        let reqURL = URL(string: urlStr)
        var reqTemp = URLRequest(url: reqURL!)
        reqTemp.httpMethod = httpMethod
        reqTemp.httpBody = uploadData
        
        //Call the REST service
        //let session = URLSession()
        let session = URLSession.shared
        
        
        var isConnected = true
  
        let task = session.dataTask(with:reqTemp,completionHandler:{
        (data , response , error) in
            if((error) != nil){
                //print("Here's the connection error \(error!.description)")
                isConnected = false
            }
            if (isConnected){
                let httpRes = response as! HTTPURLResponse
                let statusCode = httpRes.statusCode
            
                if(200 == statusCode){
                    let jsonRst:JsonParser = JsonParser(rawData: data!)
                    if(jsonRst.isSuccess()){
                        if let verifyRst = jsonRst.getValue("result"){
                            print ("This is the result \(verifyRst)");
                            runTup = (true , jsonRst);
                        }
                    }
            
                }
            }
            self.semaphore.signal()
            })
        task.resume()
        
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return runTup
    }

}
