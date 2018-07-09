//
//  ResponseData.swift
//  Todo
//
//  Created by Corotata on 2018/7/6.
//  Copyright © 2018 Corotata. All rights reserved.
//

import HandyJSON

struct ResponseData<T:HandyJSON>: HandyJSON {
    var code: HTTPCode.RawValue?
    var data: T?
    var message: String!
}


struct ResponseArrayData<T:HandyJSON>: HandyJSON {
    var code: HTTPCode.RawValue?
    var data: [T]?
    var message: String!
}
