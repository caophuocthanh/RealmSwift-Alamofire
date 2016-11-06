//
//  ViewController.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/15/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    weak var subscription: NotificationToken?
    weak var subscription1: NotificationToken?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pendingPhotos = RealmStore.models(UserModel.self).filter("facebook_id == '1620640691594201'")
        
        let artists = RealmStore.models(SongModel.self)
        
        print("pendingPhotos", pendingPhotos)
        
        print("artists", artists)
        
        self.subscription = pendingPhotos.addNotificationBlock { changes in
            switch changes {
            case .Initial( _):
                print("====>>>>>> Initial:")
                break
            case .Update( _, let deletions, let insertions, let modifications):
                print("==>>>>>>>> Update: ", deletions, insertions, modifications)
                break
            case .Error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
        
        APIManager.login("1620640691594201") { (data) in
            print("LOGIN !!!: ", data)
            //RealmStore.add(data)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            
            let p = RealmStore.models(UserModel.self)
            print("pendingPhotos", pendingPhotos)
            try! RealmStore.write({
                p.first?.email = "S<HGJHFGSKJHFGJSHGFLJSKHFGKJSHG"
            })
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            APIManager.getSongsByArtistId(516, completion: { (responseData) in
                print(responseData.identifier)
//                if let data = responseData.data as? NSArray {
//                    for item in data {
//                        print("getArtistById:", item)
//                    }
//                }
            })
        }
        //
        //        let a = UserModel()
        //        a.id = 1
        //        a.created_at = "sdfsdf"
        //
        //        let b = UserModel()
        //        b.id = 2
        //        b.created_at = "sdfsdfsdf"
        //
        //        let c = UserModel()
        //        c.id = 3
        //        c.created_at = "sdfsdfsdf"
        //
        //        RealmStore.add(a)
        //        RealmStore.add(b)
        //        RealmStore.add(c)
        
        //        let pendingPhotos = RealmStore.models(UserModel.self)
        //
        //        print("pendingPhotos", pendingPhotos)
        //
        //        subscription = pendingPhotos.addNotificationBlock { changes in
        //            switch changes {
        //            case .Initial( _):
        //                print("====>>>>>> Initial:")
        //                break
        //            case .Update( _, let deletions, let insertions, let modifications):
        //                print("==>>>>>>>> Update: ", deletions, insertions, modifications)
        //                break
        //            case .Error(let err):
        //                // An error occurred while opening the Realm file on the background worker thread
        //                fatalError("\(err)")
        //                break
        //            }
        //        }
        //
        //        print("\n\n////////////////   addNotificationBlock   ////////////////\n\n")
        //
        //        print("\n\n////////////////////////////////\n\n")
        //
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        //
        //            print("///////////////////////////////// after 10s ////////////////////////////////////////")
        //
        //            let myPuppy = RealmStore.models(UserModel.self).filter("id == 1")
        //
        //            self.subscription1 = myPuppy.addNotificationBlock { changes in
        //
        //                switch changes {
        //                case .Initial(_):
        //                    print("====>>>>>> Initial:")
        //                    break
        //                case .Update(_, let deletions, let insertions, let modifications):
        //                    print("==>>>>>>>> Update: ", deletions, insertions, modifications)
        //                    break
        //                case .Error(let err):
        //                    // An error occurred while opening the Realm file on the background worker thread
        //                    fatalError("\(err)")
        //                    break
        //                }
        //            }
        //
        //            if let bd: UserModel = myPuppy.first {
        //                try! RealmStore.write({
        //                    bd.slug = "HDJSKAJHGFHGASF"
        //                })
        //            }
        //        }
    }
    
    deinit {
        subscription?.stop()
        subscription1?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

