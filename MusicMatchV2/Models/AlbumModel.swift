//
//  AlbumModel.swift
//  MusicMatchV2
//
//  Created by Chakane Shegog on 4/3/22.
//

import Foundation

struct Start: Codable {
    let message: ArtistAlbums
}

struct ArtistAlbums: Codable {
    let body: Albums
}

struct Albums: Codable {
    let album_list: [AlbumDetails]
}

struct AlbumDetails: Codable {
    let album: Album
}

struct Album: Codable {
    let album_id: Int
    let album_name: String
    let album_rating: Int
    let album_release_date: String
    let artist_name: String
}
