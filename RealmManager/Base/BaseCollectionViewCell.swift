//
//  BaseCollectionViewCell.swift
//  Yosing
//
//  Created by Thanh on 7/14/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

// MARK: - BaseCollectionViewCellProtocol

@objc protocol BaseCollectionViewCellDelegate {
    
}

// MARK: - BaseCollectionViewCell

class BaseCollectionViewCell: UICollectionViewCell {
    
    var viewDelegate: BaseCollectionViewCellDelegate?
    
    var model: ZModel? {
        didSet {
            self.layer.shouldRasterize      = true
            self.layer.rasterizationScale   = UIScreen.mainScreen().scale
            self.updateView()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initComponents()
        self.setupContraints()
    }
    
    internal func updateView() {
        
    }
    
    internal func initComponents() {
        
    }
    
    internal func setupContraints() {
        
    }
    
    internal func didChangeLanguage() {
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - BaseCollectionViewCell Utils

extension BaseCollectionViewCell {
    
    class func reuseIdentifier() -> String {
        return Utility.className(self)
    }
    
    class func getCellSize(model: ZModel) -> CGSize {
        return CGSizeZero
    }
}
