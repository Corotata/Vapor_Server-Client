//
//  Networking.swift
//  Todo
//
//  Created by Corotata on 2018/7/6.
//  Copyright © 2018 Corotata. All rights reserved.
//

import UIKit
import Moya
import HandyJSON

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<TodoAPI>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20

        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}
let ApiProvider = MoyaProvider<TodoAPI>(requestClosure: timeoutClosure)

enum TodoAPI {
    case createTodo(title: String)
    case deleteTodo(id: Int)
    case updateTodoState(id: Int,isFinish: Bool)
    case queryTodos
}


extension TodoAPI: TargetType {
    var method: Moya.Method {
        switch self {
        case .createTodo:
            return .post
        case .deleteTodo:
            return .post
        case .updateTodoState:
            return .post
        case .queryTodos:
            return .get
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parmeters = [String: Any]()
        switch self {
        case .createTodo(let title):
            parmeters["title"] = title
        case .deleteTodo(let id):
            parmeters["id"] = id
        case .updateTodoState(let id,let isFinish):
            parmeters["id"] = id
            parmeters["isFinish"] = isFinish
        case .queryTodos:
            break;
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    /// The target's base `URL`.
    var baseURL: URL { return URL(string: "http://localhost:8080/")! }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .createTodo:
            return "todos/create"
        case .deleteTodo:
            return "todos/delete"
        case .updateTodoState:
            return "todos/updateState"
        case .queryTodos:
            return "todos/query"
        }

    }
}



extension MoyaProvider {
    func requestModel<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ responseData: ResponseData<T>?) -> Void)?) -> Cancellable? {
        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            guard let responseData = try? result.value?.mapObject(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            completion(responseData)
        })
    }
    
    func requestArrayModel<T: HandyJSON>(_ target: Target,
                               model: T.Type,
                               completion: ((_ responseData: ResponseArrayData<T>?) -> Void)?) -> Cancellable? {
        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            guard let responseData = try? result.value?.mapObject(ResponseArrayData<T>.self) else {
                completion(nil)
                return
            }
            completion(responseData)
        })
    }
    
}

extension Response {
    func mapObject<T: HandyJSON>(_ type:T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

