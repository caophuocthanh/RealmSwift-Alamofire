//
//  ViewController.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/15/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let _collectionView = SongCollectionView()
    let _textField = UITextField()
    let _buttonLike = UIButton()
    let _button = UIButton()
    
    let _textFieldNew = UITextField()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self._collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self._button.setTitle("PUSH", forState: .Normal)
        self.view.addSubview(_button)
        
        self._button.addTarget(self, action: #selector(self.didTouchPushButton), forControlEvents: .TouchUpInside)
        
        
        
        self._textFieldNew.backgroundColor = UIColor.orangeColor()
        self._textFieldNew.placeholder = "name song change"
        self._textFieldNew.textAlignment = .Center
        self.view.addSubview(_textFieldNew)
        self._textFieldNew.delegate = self
        
        self._textFieldNew.translatesAutoresizingMaskIntoConstraints = false
        self._collectionView.translatesAutoresizingMaskIntoConstraints = false
        self._textField.translatesAutoresizingMaskIntoConstraints = false
        self._buttonLike.translatesAutoresizingMaskIntoConstraints = false
        self._button.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["v1": self._collectionView,
                     "v2": self._textField,
                     "v3": self._buttonLike,
                     "v4": self._button,
                     "v5": self._textFieldNew]
        
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
            "H:|-[v5]-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[v1]-[v2(40)]-10-[v3(40)]-10-[v4]-10-[v5(40)]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        
        // LOGIN
        self.login()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if let id = self._textField.text {
            let a = RealmStore.models(SongModel.self).filter("id == \(id)")
            
            if let c: SongModel = a.first {
                try! RealmStore.write({
                    c.title = self._textFieldNew.text ?? "" + string
                })
                
            } else {
                print("NUL NUL")
            }
        }
        
        return true
    }
    
    func login() {
        Service.authenticate("1620640691594201") { (user) in
            print("User:", user)
            if user.count > 0 {
                self.getSongs()
            }
        }
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
        let vc = ABViewComtrollerViewController()
        self.showViewController(vc, sender: self)
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

