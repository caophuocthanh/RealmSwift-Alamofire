//
//  ZNetworking.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/1/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import Alamofire

/**
 Result for request response
 
 - Success:  Success
 - Failure:  Failure
 - Cancel:   Cancel
 - NotFound: NotFound
 */
public enum Result<T: AnyObject> {
    case Success(T?)
    case Failure(Int)
    case Cancel(T?)
    case NotFound(T?)
}

class ZNetworking {
    
    var request: Alamofire.Request?
    
    var headers: [String: String]? {
        set{}
        get{
            return nil
        }
    }
    
    class func handleStatusCode(status: Int) {
        switch status {
        case 401:
            print("Handle StatusCode 401: Not Authenticate (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        case 417:
            print("Handle StatusCode 417: Expectation Failed (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        case 404:
            print("Handle StatusCode: 404 Not Found (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        default:
            break
        }
    }
    
    func POST(url: String, parameters: [String: AnyObject]? , completion: ((responseObject: Result<AnyObject>) -> Void)) -> NSURLSessionTask? {
        self.request = Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: self.headers).responseJSON { response in
            if response.result.isSuccess {
                completion(responseObject: Result.Success(response.result.value))
            } else {
                if let response = response.response {
                    completion(responseObject: Result.Failure(response.statusCode))
                } else {
                    completion(responseObject: Result.Failure(-1))
                }
            }
        }
        return self.request?.task
    }
    
    
    func GET(url: String, parameters: [String: AnyObject]? , completion: ((responseObject: Result<AnyObject>) -> Void)) -> NSURLSessionTask? {
        self.request = Alamofire.request(.GET, url, parameters: parameters, encoding: .JSON, headers: self.headers).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                completion(responseObject: Result.Success(response.result.value))
            } else {
                print("GET Faild Request: ", self.request?.request?.URLString)
                if let response = response.response {
                    completion(responseObject: Result.Failure(response.statusCode))
                } else {
                    completion(responseObject: Result.Failure(-1))
                }
            }
        })
        return self.request?.task
    }
    
    //
    //    func delete(sourceService: APIDataSouce, completion: (error: NSError?, data: [String: AnyObject]?) -> ()) {
    //
    //    }
    //
    //    func update(sourceService: APIDataSouce, completion: (error: NSError?, data: [String: AnyObject]?) -> ()) {
    //
    //    }
    //
    //    func upload(sourceService: APIDataSouce, completion: (error: NSError?, data: [String: AnyObject]?) -> ()) {
    //
    //    }
    //
    //    func dowload(sourceService: APIDataSouce, completion: (error: NSError?, data: [String: AnyObject]?) -> ()) {
    //
    //    }
    //
        func cancelTask(task: NSURLSessionDataTask) {
            task.cancel()
        }
    
}
