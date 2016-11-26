//
//  ABViewComtrollerViewController.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/26/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class ABViewComtrollerViewController: UIViewController {

    let _collectionView = SongCollectionView()
    let _textField = UITextField()
    let _buttonLike = UIButton()
    let _button = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_collectionView)
        self._textField.backgroundColor = UIColor.orangeColor()
        self._textField.placeholder = "id song"
        self._textField.textAlignment = .Center
        self.view.addSubview(_textField)
        
        
        self._buttonLike.backgroundColor = UIColor.redColor()
        self._buttonLike.setTitle("SUBMIT LIKE", forState: .Normal)
        self.view.addSubview(_buttonLike)
        
        self._buttonLike.addTarget(self, action: #selector(self.didTouchLikeButton), forControlEvents: .TouchUpInside)
        
        self._button.backgroundColor = UIColor.redColor()
        self._button.setTitle("DISSMIS", forState: .Normal)
        self.view.addSubview(_button)
        
        self._button.addTarget(self, action: #selector(self.didTouchPushButton), forControlEvents: .TouchUpInside)
        
        
        self._collectionView.translatesAutoresizingMaskIntoConstraints = false
        self._textField.translatesAutoresizingMaskIntoConstraints = false
        self._buttonLike.translatesAutoresizingMaskIntoConstraints = false
        self._button.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["v1": self._collectionView,
                     "v2": self._textField,
                     "v3": self._buttonLike,
                     "v4": self._button]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[v1]-0-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[v2]-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[v3]-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[v4]-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[v1]-[v2(40)]-10-[v3(40)]-10-[v4]-20-|",
            options: [],
            metrics: nil,
            views: views))
        

        self.getSongs()
    }

    
    func getSongs() {
        Service.Songs.findByArtistId(561, store: { (store) in
            self._collectionView.songs = store
        }) { (songs) in
            if songs.count > 0 {
                self._collectionView.songs = songs
            }
        }
    }
    
    func didTouchPushButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTouchLikeButton() {
        if let id = self._textField.text {
            let a = RealmStore.models(SongModel.self).filter("id == \(id)")
            
            if let c: SongModel = a.first {
                try! RealmStore.write({
                    c.isFavorited = !c.isFavorited
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }

}
