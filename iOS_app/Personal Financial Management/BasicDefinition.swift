//
//  BasicDefinition.swift
//  Personal Financial Management
//
//  Created by chsun on 7/1/16.
//  Copyright © 2016 Chang Sun. All rights reserved.
//

import Foundation

enum HTTP_METHOD: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DEL = "DEL"
}

enum SEMAHORE: Int {
    case http_CALL = 0
}

enum REST_RESULT: Int{
    case success = 0
    case failed = -1
    case verified = 1
    case no_DATA = 2
}
