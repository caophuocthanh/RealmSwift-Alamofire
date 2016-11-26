//
//  SongCollectionView.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/26/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class SongCollectionView: BaseCollectionView {
    
    
    var songs = [SongModel]() {
        didSet{
            self.reloadData()
        }
    }
    
    override func initComponents() {
        super.initComponents()
        
        self.delegate = self
        self.dataSource = self
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.registerCell(SongCollectionViewCell)
        
        self.layout.minimumColumnSpacing = 8
        self.layout.minimumInteritemSpacing = 8
        
    }
    
    override func setupContraints() {
        super.setupContraints()
    }
    
}

extension SongCollectionView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : SongCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(SongCollectionViewCell.reuseIdentifier(), forIndexPath: indexPath) as! SongCollectionViewCell
        cell.song = self.songs[indexPath.row]
        self.layer.shouldRasterize      = true
        self.layer.rasterizationScale   = UIScreen.mainScreen().scale
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.songs.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension SongCollectionView: UICollectionViewDelegate {
    
}

extension SongCollectionView: BaseWaterfallCollectionViewLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

            return SongCollectionViewCell.getCellSize(self.songs[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, numberOfColumnForSection section: Int) -> Float {
        return 2
    }
    
}

