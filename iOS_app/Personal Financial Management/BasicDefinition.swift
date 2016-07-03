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
    case HTTP_CALL = 0
}

enum REST_RESULT: Int{
    case SUCCESS = 0
    case FAILED = -1
    case VERIFIED = 1
    case NO_DATA = 2
}