//
//  SongCollectionViewCell.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/26/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class SongCollectionViewCell: BaseCollectionViewCell {
    
    var subscription: ZRealmStoreNotificationToken?
    
    private var _titleLabel = UILabel()
    private var _favoricButton = UIButton()
    private var _lyriclabel = UILabel()
    
    
    var song: SongModel? {
        didSet {
            if let _song = self.song {
                self.setData(_song)
                self.registerEventChangeObjectInCell(_song)
            }
        }
    }
    
    func setData(song: SongModel) {
        if song.isFavorited == false {
            self._favoricButton.setTitle(" Like", forState: .Normal)
            self._favoricButton.setImage(UIImage(named: "ButtonUnLoved"), forState: .Normal)
        } else {
            self._favoricButton.setTitle(" Unlike", forState: .Normal)
            self._favoricButton.setImage(UIImage(named: "ButtonLoved"), forState: .Normal)
        }
        self._titleLabel.text = song.title + " \n#\(song.id)"
        self._lyriclabel.text = song.lyric_preview
    }
    
    func registerEventChangeObjectInCell(song: SongModel) {
        self.subscription = song.changed(SongModel.self, block: { (object, changed) in
            switch changed {
            case .Update:
                self.setData(song)
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
        
        self.contentView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.4)
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(self._titleLabel)
        self._titleLabel.font = UIFont.boldSystemFontOfSize(18)
        self._titleLabel.textAlignment = .Center
        self._titleLabel.numberOfLines = 0
        
        self.contentView.addSubview(self._lyriclabel)
        self._lyriclabel.font = UIFont.systemFontOfSize(16)
        self._lyriclabel.numberOfLines = 0
        
        self.self._favoricButton.backgroundColor = UIColor.orangeColor()
        //self._favoricButton.layer.cornerRadius = 15
        self.contentView.addSubview(self._favoricButton)
        
        self._favoricButton.addTarget(self, action: #selector(self.didTouchLikeButton), forControlEvents: .TouchUpInside)
        
        
    }
    
    func didTouchLikeButton() {
        if let song = self.song {
            let a = ZRealmStore.models(SongModel.self).filter("id == \(song.id)")
            if let c: SongModel = a.first {
                try! ZRealmStore.write({
                    c.isFavorited = !c.isFavorited
                })
            }
        }
    }
    
    override func setupContraints() {
        super.setupContraints()
        
        self._favoricButton.translatesAutoresizingMaskIntoConstraints = false
        self._titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self._lyriclabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["_favoricButton": self._favoricButton,
                     "_titleLabel": self._titleLabel,
                     "_lyriclabel": self._lyriclabel]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[_favoricButton]-0-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[_titleLabel]-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[_lyriclabel]-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[_titleLabel]-4-[_lyriclabel]-4-[_favoricButton(30)]-0-|",
            options: [],
            metrics: nil,
            views: views))
    }
    
    
    override class func getCellSize(model: ZModel) -> CGSize {
        let height = (model as? SongModel)?.lyric_preview?.heightForWithFont(UIFont.systemFontOfSize(16), width: UIScreen.mainScreen().bounds.width/2 - 32, insets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)) ?? 0
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 30 + 4 + 4 + height + 200)
    }
    
    
    deinit {
        self.subscription?.stop()
    }
    
    
}

extension String {
    
    func heightForWithFont(font: UIFont, width: CGFloat, insets: UIEdgeInsets) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width + insets.left + insets.right, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height + insets.top + insets.bottom
    }
}

