//
//  APIManager.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/28/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation

class APIDataSouce {
    var method: APIMethod!
    var identifier: String!
    var parameters: [String: AnyObject]? = nil
    var apiURL: String!
    var imageData: NSData?
}

class APINavigation {
    var errors: AnyObject?
    var validationErrors: AnyObject?
    var warnings: AnyObject?
    var infos: AnyObject?
    
    init(data: AnyObject) {
        
    }
}

public enum APIMethod: String {
    case GET, POST
}

class APIResponseData {
    var identifier: String!
    var data: AnyObject?
    var currentPage: Int = 0
    var totalPage: Int = 0
    var previousURL: String?
    var nextURL: String?
    var navigation: APINavigation?
    
    
    init(_ respone: AnyObject?, method: APIMethod, identifier: String!) {
        self.identifier = identifier
        if let _dataResponse = respone {
            if let result: NSDictionary = _dataResponse["result"] as? NSDictionary {
                switch method {
                case .POST:
                    self.data = result
                    break
                case .GET:
                    if let data = result["data"] as? NSArray {
                        self.data = data
                    }
                    if let currentPage:String = result["currentPage"] as? String {
                        self.currentPage = Int(currentPage) ?? 0
                    }
                    if let totalPage:String = result["totalPage"] as? String {
                        self.totalPage = Int(totalPage) ?? 0
                    }
                    if let previousURL:String = result["previous"] as? String {
                        self.previousURL = previousURL
                    }
                    if let nextURL:String = result["next"] as? String {
                        self.nextURL = nextURL
                    }
                    break
                }
            }
        }
    }
}

class APIManager {
    
    static let networking = Networking()
    
    class func request(dataSource: APIDataSouce, completion: ((response: APIResponseData) -> Void)) {
        
        print("REQUEST: ", dataSource.identifier)
        
        let method: APIMethod = dataSource.method
        switch method {
        case .POST:
            APIManager.networking.POST(dataSource.apiURL, parameters: dataSource.parameters) { (responseObject) in
                switch responseObject {
                case .Success(let response):
                    print("POST SUCCESS:", dataSource.identifier)
                    completion(response: APIResponseData(response, method: .POST, identifier: dataSource.identifier))
                    break
                default:
                    print("POST FAILD:", dataSource.identifier)
                    completion(response: APIResponseData(nil, method: .POST, identifier: dataSource.identifier))
                    break
                }
            }
            break
        case .GET:
            APIManager.networking.GET(dataSource.apiURL, parameters: dataSource.parameters) { (responseObject) in
                switch responseObject {
                case .Success(let response):
                    print("GET SUCCESS:", dataSource.identifier)
                    completion(response: APIResponseData(response, method: .GET, identifier: dataSource.identifier))
                    break
                default:
                    print("GET FAILD:", dataSource.identifier)
                    completion(response: APIResponseData(nil, method: .GET, identifier: dataSource.identifier))
                    break
                }
            }
            break
        }
    }
    
}
