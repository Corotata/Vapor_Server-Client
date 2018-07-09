//
//  HTTPErrorCode.swift
//  App
//
//  Created by Corotata on 2018/7/6.
//


enum HTTPCode: Int {
    case success = 0
    case noContent = 1001
    case illegalParameter = 1002
    
}


extension HTTPCode {
    var message: String {
        switch self {
        case .success:
            return "Success."
        case .noContent:
            return "Not Content."
        case .illegalParameter:
            return "Illegal Parameter."
        }
    }
}

