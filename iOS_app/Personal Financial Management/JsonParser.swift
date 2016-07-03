//
//  JsonParser.swift
//  Personal Financial Management
//
//  Created by chsun on 7/1/16.
//  Copyright © 2016 Chang Sun. All rights reserved.
//

import Foundation

class JsonParser{
    var jsonData = [String : AnyObject]()
    private var parserSuccess: Bool = true
    
    init(rawData: NSData){
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(rawData, options: .AllowFragments)
            jsonData = json as! [String : AnyObject]
            
        }
        catch{
            parserSuccess = false
            print("Failed to parse the json \(error)")
        }
    }
    
    //Whether the parser is successful
    func isSuccess() -> Bool {
        return parserSuccess
    }
    
    //return the key pointed value of json
    //The getValue returns either string or subset of the json node.
    func getValue(jsonKey: String) -> AnyObject? {
        if let rst = jsonData[jsonKey]{
            return rst
        }
        return nil
    }

}