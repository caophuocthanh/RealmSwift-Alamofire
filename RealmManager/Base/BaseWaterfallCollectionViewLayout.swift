//
//  BaseWaterfallCollectionViewLayout.swift
//  BaseWaterfallCollectionViewLayout
//
//  Created by Cao Phuoc Thanh on 7/23/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import UIKit

@objc public protocol BaseWaterfallCollectionViewLayoutDelegate:UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    
    optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, heightForHeaderInSection section: Int) -> Float
    
    optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, heightForFooterInSection section: Int) -> Float
    
    optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSection section: Int) -> UIEdgeInsets
    
    optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForHeaderInSection section: Int) -> UIEdgeInsets
    
    optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForFooterInSection section: Int) -> UIEdgeInsets
    
    optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSection section: Int) -> Float
    
    optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, numberOfColumnForSection section: Int) -> Float
    
}

public class BaseWaterfallCollectionViewLayout: UICollectionViewLayout {
    
    //MARK: Private constants
    /// How many items to be union into a single rectangle
    private let unionSize = 20;
    
    //MARK: Public Properties
    //    public var columnCount:Int = 1 {
    //        didSet {
    //            invalidateIfNotEqual(oldValue, newValue: columnCount)
    //        }
    //    }
    public var minimumColumnSpacing:Float = 10.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: minimumColumnSpacing)
        }
    }
    public var minimumInteritemSpacing:Float = 10.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: minimumInteritemSpacing)
        }
    }
    public var headerHeight:Float = 0.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: headerHeight)
        }
    }
    public var footerHeight:Float = 0.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: footerHeight)
        }
    }
    public var headerInset:UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            invalidateIfNotEqual(NSValue(UIEdgeInsets: oldValue), newValue: NSValue(UIEdgeInsets: headerInset))
        }
    }
    public var footerInset:UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            invalidateIfNotEqual(NSValue(UIEdgeInsets: oldValue), newValue: NSValue(UIEdgeInsets: footerInset))
        }
    }
    public var sectionInset:UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            invalidateIfNotEqual(NSValue(UIEdgeInsets: oldValue), newValue: NSValue(UIEdgeInsets: sectionInset))
        }
    }
    
    //MARK: Private Properties
    private weak var delegate: BaseWaterfallCollectionViewLayoutDelegate?  {
        get {
            return collectionView?.delegate as? BaseWaterfallCollectionViewLayoutDelegate
        }
    }
    private var columnHeights = [Float]()
    private var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    private var allItemAttributes = [UICollectionViewLayoutAttributes]()
    private var headersAttribute = [Int: UICollectionViewLayoutAttributes]()
    private var footersAttribute = [Int: UICollectionViewLayoutAttributes]()
    private var unionRects = [CGRect]()
    
    
    //MARK: UICollectionViewLayout Methods
    override public func prepareLayout() {
        super.prepareLayout()
        
        let numberOfSections = collectionView?.numberOfSections()
        
        if numberOfSections == 0 {
            return;
        }
        
        // Initialize variables
        headersAttribute.removeAll(keepCapacity: false)
        footersAttribute.removeAll(keepCapacity: false)
        unionRects.removeAll(keepCapacity: false)
        columnHeights.removeAll(keepCapacity: false)
        allItemAttributes.removeAll(keepCapacity: false)
        sectionItemAttributes.removeAll(keepCapacity: false)
        
        // Create attributes
        var top:Float = 0
        var attributes: UICollectionViewLayoutAttributes
        
        for section in 0..<numberOfSections! {
            /*
             * 1. Get section-specific metrics (minimumInteritemSpacing)
             */
            var minimumInteritemSpacing: Float
            if let height = delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSection: section) {
                minimumInteritemSpacing = height
            }
            else {
                minimumInteritemSpacing = self.minimumInteritemSpacing
            }
            
            
            /*
             * 2. Get section-specific metrics (sectionInset)
             */
            var sectionInset: UIEdgeInsets
            if let inset = delegate?.collectionView?(collectionView!, layout: self, insetForSection: section) {
                sectionInset = inset
            }
            else {
                sectionInset = self.sectionInset
            }
            
            var headerInset: UIEdgeInsets
            if let inset = delegate?.collectionView?(collectionView!, layout: self, insetForHeaderInSection: section) {
                headerInset = inset
            }
            else {
                headerInset = self.headerInset
            }
            
            
            var footerInset: UIEdgeInsets
            if let inset = delegate?.collectionView?(collectionView!, layout: self, insetForFooterInSection: section) {
                footerInset = inset
            }
            else {
                footerInset = self.footerInset
            }
            
            
            let width = Float(self.collectionView!.frame.size.width - sectionInset.left - sectionInset.right)
            
            var columnCount: Float = 1
            if let count: Float = self.delegate?.collectionView?(self.collectionView!,
                                                                 layout: self,
                                                                 numberOfColumnForSection: section) {
                columnCount = count
            }
            
            self.columnHeights.removeAll()
            for _ in 0..<Int(columnCount) {
                columnHeights.append(0)
            }
            
            
            let itemWidth = floorf((width - Float(columnCount - 1) * Float(minimumColumnSpacing)) / Float(columnCount))
            
            /*
             * 2. Section header
             */
            var headerHeight: Float
            if let height = delegate?.collectionView?(collectionView!, layout: self, heightForHeaderInSection: section) {
                headerHeight = height
            }
            else {
                headerHeight = self.headerHeight
            }
            
            top += Float(headerInset.top)
            
            if headerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: NSIndexPath(forItem: 0, inSection: section))
                attributes.frame = CGRect(x: headerInset.left, y: CGFloat(top), width: collectionView!.frame.size.width - (headerInset.left + headerInset.right), height: CGFloat(headerHeight))
                
                headersAttribute[section] = attributes
                allItemAttributes.append(attributes)
                
                top = Float(CGRectGetMaxY(attributes.frame)) + minimumInteritemSpacing
            }
            
            
            top += Float(sectionInset.top + headerInset.bottom)
            
            
            for idx in 0..<Int(columnCount) {
                columnHeights[idx] = top
            }
            
            
            /*
             * 3. Section items
             */
            let itemCount = collectionView!.numberOfItemsInSection(section)
            var itemAttributes = [UICollectionViewLayoutAttributes]()
            
            // Item will be put into shortest column.
            for idx in 0..<itemCount {
                let indexPath = NSIndexPath(forItem: idx, inSection: section)
                let columnIndex = shortestColumnIndex()
                
                let xOffset = Float(sectionInset.left) + Float(itemWidth + minimumColumnSpacing) * Float(columnIndex)
                let yOffset = columnHeights[columnIndex]
                let itemSize = delegate?.collectionView(collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
                var itemHeight: Float = 0.0
                if itemSize?.height > 0 && itemSize?.width > 0 {
                    itemHeight = Float(itemSize!.height) * itemWidth / Float(itemSize!.width)
                }
                
                attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRect(x: CGFloat(xOffset), y: CGFloat(yOffset), width: CGFloat(itemWidth), height: CGFloat(itemHeight))
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[columnIndex] = Float(CGRectGetMaxY(attributes.frame)) + minimumInteritemSpacing
            }
            
            sectionItemAttributes.append(itemAttributes)
            
            /*
             * 4. Section footer
             */
            var footerHeight: Float
            let columnIndex = longestColumnIndex()
            top = columnHeights[columnIndex] - minimumInteritemSpacing + Float(sectionInset.bottom)
            
            if let height = delegate?.collectionView?(collectionView!, layout: self, heightForFooterInSection: section) {
                footerHeight = height
            }
            else {
                footerHeight = self.footerHeight
            }
            
            top += Float(footerInset.top)
            
            if footerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: NSIndexPath(forItem: 0, inSection: section))
                attributes.frame = CGRect(x: footerInset.left, y: CGFloat(top), width: collectionView!.frame.size.width - (footerInset.left + footerInset.right), height: CGFloat(footerHeight))
                
                footersAttribute[section] = attributes
                allItemAttributes.append(attributes)
                
                top = Float(CGRectGetMaxY(attributes.frame))
            }
            
            top += Float(sectionInset.bottom + footerInset.bottom)
            
            for idx in 0..<Int(columnCount) {
                columnHeights[idx] = top
            }
        }
        
        // Build union rects
        var idx = 0
        let itemCounts = allItemAttributes.count
        
        while idx < itemCounts {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + unionSize, itemCounts) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(CGRectUnion(rect1, rect2))
            idx += 1
        }
    }
    
    override public func collectionViewContentSize() -> CGSize {
        let numberOfSections = collectionView?.numberOfSections()
        if numberOfSections == 0 {
            return CGSizeZero
        }
        
        var contentSize = collectionView?.bounds.size
        contentSize?.height = CGFloat(columnHeights[0])
        
        return contentSize!
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        
        if indexPath.item >= sectionItemAttributes[indexPath.section].count {
            return nil
        }
        
        return sectionItemAttributes[indexPath.section][indexPath.item]
    }
    
    override public func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute: UICollectionViewLayoutAttributes?
        
        if elementKind == UICollectionElementKindSectionHeader {
            attribute = headersAttribute[indexPath.section]
        }
        else if elementKind == UICollectionElementKindSectionFooter {
            attribute = footersAttribute[indexPath.section]
        }
        
        return attribute
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin:Int = 0
        var end: Int = unionRects.count
        var attrs = [UICollectionViewLayoutAttributes]()
        
        for i in 0..<unionRects.count {
            if CGRectIntersectsRect(rect, unionRects[i]) {
                begin = i * unionSize
                break
            }
        }
        for i in (0..<unionRects.count).reverse() {
            if CGRectIntersectsRect(rect, unionRects[i]) {
                end = min((i+1) * unionSize, allItemAttributes.count)
                break
            }
        }
        for i in begin ..< end {
            let attr = allItemAttributes[i]
            if CGRectIntersectsRect(rect, attr.frame) {
                attrs.append(attr)
            }
        }
        
        return Array(attrs)
    }
    
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds
        if CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds!) {
            return true
        }
        
        return false
    }
    
    //MARK: Private Methods
    private func shortestColumnIndex() -> Int {
        var index: Int = 0
        var shortestHeight = MAXFLOAT
        
        for (idx, height) in columnHeights.enumerate() {
            if height < shortestHeight {
                shortestHeight = height
                index = idx
            }
        }
        
        return index
    }
    
    private func longestColumnIndex() -> Int {
        var index: Int = 0
        var longestHeight:Float = 0
        
        for (idx, height) in columnHeights.enumerate() {
            if height > longestHeight {
                longestHeight = height
                index = idx
            }
        }
        
        return index
    }
    
    private func invalidateIfNotEqual(oldValue: AnyObject, newValue: AnyObject) {
        if !oldValue.isEqual(newValue) {
            invalidateLayout()
        }
    }
}
