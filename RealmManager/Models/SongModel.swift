//
//  ArtistModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/3/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

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
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        genre <- map["genre"]
        isFavorited <- map["isFavorited"]
        karaoke_number <- map["karaoke_number"]
        lyric <- map["lyric"]
        lyric_full <- map["lyric_full"]
        lyric_id <- map["lyric_id"]
        lyric_preview <- map["lyric_preview"]
        record_count <- map["record_count"]
        record_count_timestamp <- map["record_count_timestamp"]
        singer <- map["singer"]
        singer_id <- map["singer_id"]
        song_id <- map["song_id"]
        title <- map["title"]
    }

}
