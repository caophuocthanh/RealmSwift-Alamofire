//
//  BaseModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/15/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift


class APIUtilities {
    
    /** Convert MySQL TIMESTAMP format to iOS NSDate object */
    static func datetimeStringToNSDate(datetime: String) -> NSDate? {
        let dateFormatter           = NSDateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        if let dateCreated  = dateFormatter.dateFromString(datetime) {
            return dateCreated
        }
        return nil
    }
}

/// BaseModel
class BaseModel: Object {
    
    dynamic var id = 0
    dynamic var created_at  : String?
    dynamic var updated_at  : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /**
     Parse model to Dictionary
     
     - returns: A Dictionary
     */
    func dictionary() -> [String: AnyObject] {
        let mirrored_object = Mirror(reflecting: self)
        var dictionary = [String: AnyObject]()
        for (_, attr) in mirrored_object.children.enumerate() {
            if let propertyName = attr.label as String! {
                dictionary[propertyName] = attr.value as? AnyObject
            }
        }
        
        // This is for subclass 'deep' to parse all object in model
        if let parent = mirrored_object.superclassMirror() {
            for (_, attr) in parent.children.enumerate() {
                if let propertyName = attr.label as String!{
                    if dictionary[propertyName] == nil{
                        dictionary[propertyName] = attr.value as? AnyObject
                    }
                }
            }
        }
        return dictionary
    }
    
}
