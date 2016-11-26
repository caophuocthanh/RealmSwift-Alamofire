//
//  APIUtilities.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/26/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

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