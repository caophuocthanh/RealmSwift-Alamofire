//
//  BaseCollectionView.swift
//  Yosing
//
//  Created by Thanh on 7/12/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class Utility {
    class func className(obj: Any) -> String {
        return String(obj.dynamicType).componentsSeparatedByString("__").last!
    }
}

@objc protocol BaseCollectionViewDelegate {
    optional func handlePullToRefresh()
}

class BaseCollectionView: UICollectionView {
    
    var viewDelegate: BaseCollectionViewDelegate!
    
    let layout = BaseWaterfallCollectionViewLayout()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: CGRectZero, collectionViewLayout: self.layout)
        
        self.backgroundColor = UIColor.whiteColor()
        self.alwaysBounceVertical = true
        
        self.initComponents()
        self.setupContraints()
    }
    
    internal func initComponents() {
        
    }
    
    internal func setupContraints() {
        
    }
    
    internal func didChangeLanguage() {
        
    }
    
    internal func scrollToTop() {
        (self as UIScrollView).setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    internal func registerCell(cellClass: AnyClass) {
        let identifier = Utility.className(cellClass)
        self.registerClass(cellClass.self, forCellWithReuseIdentifier: identifier)
    }
    
    internal func registerHeaderFooter(cellClass: AnyClass) {
        let identifier = Utility.className(cellClass)
        self.registerClass(cellClass.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
