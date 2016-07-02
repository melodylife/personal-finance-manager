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
        if let infoPlist = NSBundle.mainBundle().infoDictionary{
            serviceURL = infoPlist["Service URL"] as? String
        }
    }
    
    let semaphore = dispatch_semaphore_create(SEMAHORE.HTTP_CALL.rawValue)
    
    //Check the availability of service
    func isConnected() -> Bool {
        let path = "healthcheck"
        let method = HTTP_METHOD.GET.rawValue
        
        let (blRst , jsonRst): (Bool , JsonParser?) = httpCall(path, queryPara: [:], httpMethod: method, uploadData: nil)
        
        return blRst && ("success" == jsonRst!.getValue("result"))
    }
    
    //Universal http request handler
    func httpCall(handlerPath: String , queryPara:[String:String] , httpMethod:HTTP_METHOD.RawValue , uploadData:NSData?) -> (Bool , JsonParser?){
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
        
        print("This is the url \(urlStr)")
        
        let reqURL = NSURL(string: urlStr)
        let reqTemp = NSMutableURLRequest(URL: reqURL!)
        reqTemp.HTTPMethod = httpMethod
        reqTemp.HTTPBody = uploadData
        
        //Call the REST service
        let session = NSURLSession.sharedSession()
        
        var isConnected = true
        let task = session.dataTaskWithRequest(reqTemp){
        (data , response , error) -> Void in
            if((error) != nil){
                //print("Here's the connection error \(error!.description)")
                isConnected = false
            }
            if (isConnected){
                let httpRes = response as! NSHTTPURLResponse
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
             dispatch_semaphore_signal(self.semaphore)
            
        }
        task.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return runTup
    }

}