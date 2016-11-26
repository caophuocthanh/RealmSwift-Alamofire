//
//  ArtistModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/3/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

class SongModel: BaseModel {
    dynamic var genre: String?
    dynamic var isFavorited: Bool = false
    dynamic var karaoke_number: String?
    dynamic var lyric: FileModel?
    dynamic var lyric_full: String?
    dynamic var lyric_id: Int = 0
    dynamic var lyric_preview: String?
    dynamic var record_count: Int = 0
    dynamic var record_count_timestamp: String = ""
    dynamic var singer: SingerModel?
    dynamic var singer_id: Int = 0
    dynamic var song_id: Int = 0
    dynamic var title: String! = ""

}
