//
//  SongCollectionViewCell.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/26/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class SongCollectionViewCell: BaseCollectionViewCell {
    
    
    var subscription: RealmStoreNotificationToken?

    private var _titleLabel = UILabel()
    private var _favoricButton = UIButton()
    
    
    var song: SongModel? {
        didSet {
            if let _song = self.song {
                self._titleLabel.text = _song.title + " \nID: \(_song.id)"
                if _song.isFavorited == false {
                    self._favoricButton.setTitle("LIKE", forState: .Normal)
                } else {
                    self._favoricButton.setTitle("UNLIKE", forState: .Normal)
                }
                self.registerEventChangeObjectInCell(_song)
            }
        }
    }
    
    func registerEventChangeObjectInCell(song: SongModel) {
        self.subscription = song.changed(SongModel.self, block: { (object, changed) in
            switch changed {
            case .Update:
                if song.isFavorited == false {
                    self._favoricButton.setTitle("LIKE", forState: .Normal)
                } else {
                    self._favoricButton.setTitle("UNLIKE", forState: .Normal)
                }
                
                self._titleLabel.text = song.title + " \nID: \(song.id)"
                
                break
            case .Initial:
                break
            case .Delete:
                break
            case .Error(_):
                break
            }
        })
    }
    
    override func initComponents() {
        super.initComponents()
        
        self.contentView.backgroundColor = UIColor.lightGrayColor()
        
        
        self.contentView.addSubview(self._titleLabel)
        self._titleLabel.backgroundColor = UIColor.cyanColor()
        self._titleLabel.textAlignment = .Center
        self._titleLabel.numberOfLines = 0
        
        
        self.contentView.addSubview(self._favoricButton)
        self._favoricButton.backgroundColor = UIColor.darkGrayColor()
        
    }
    
    override func setupContraints() {
        super.setupContraints()
        
        self._favoricButton.translatesAutoresizingMaskIntoConstraints = false
        self._titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["_favoricButton": self._favoricButton,
                     "_titleLabel": self._titleLabel]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-40-[_favoricButton]-40-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[_titleLabel]-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[_titleLabel]-10-[_favoricButton(30)]-10-|",
            options: [],
            metrics: nil,
            views: views))
    }
    
    
    override class func getCellSize(model: BaseModel) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 220)
    }
    
    
    deinit {
        self.subscription?.stop()
    }
    
    
}
