//
//  ArtistModel.swift
//  MusicMatchV2
//
//  Created by Chakane Shegog on 3/28/22.
//

import Foundation

struct Artists: Codable {
    let message: ArtistMessageBody
}

struct ArtistMessageBody: Codable {
    let body: ArtistList
}

struct ArtistList: Codable {
    let artist_list: [Artist]
}

struct Artist: Codable {
    let artist: ArtistInfo
}

struct ArtistInfo: Codable {
    let artist_id: Int
    let artist_name: String
    let artist_country: String
    let artist_rating: Int
}


