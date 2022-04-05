//
//  MusicMatchV2Tests.swift
//  MusicMatchV2Tests
//
//  Created by Chakane Shegog on 3/28/22.
//

import XCTest
@testable import MusicMatchV2

class MusicMatchV2Tests: XCTestCase {
    
    func testGetArtistByName() {
        // arrange
        let json = """
    {
        "message": {
            "header": {
                "status_code": 200,
                "execute_time": 0.030539035797119,
                "available": 6475
            },
            "body": {
                "artist_list": [
                    {
                        "artist": {
                            "artist_id": 403580,
                            "artist_name": "Pete Drake",
                            "artist_name_translation_list": [],
                            "artist_comment": "",
                            "artist_country": "US",
                            "artist_alias_list": [
                                {
                                    "artist_alias": "ピートドレイク"
                                },
                                {
                                    "artist_alias": "Pete F. Drake"
                                }
                            ],
                            "artist_rating": 17,
                            "artist_twitter_url": "",
                            "artist_credits": {
                                "artist_list": []
                            },
                            "restricted": 0,
                            "updated_time": "2018-07-22T20:15:06Z",
                            "begin_date_year": "1932",
                            "begin_date": "1932-10-08",
                            "end_date_year": "1988",
                            "end_date": "1988-07-29"
                        }
                    }
                ]
            }
        }
    }
    """.data(using: .utf8)!
        
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
        
        // act
        let artistName = "Pete Drake"
        do {
            let decodedArtist = try JSONDecoder().decode(Artists.self, from: json)
            
            // assert
            let a_name = decodedArtist.message.body.artist_list.first?.artist.artist_name ?? ""
            XCTAssertEqual(artistName, a_name)
        } catch {
            XCTFail("decoding error: \(error)")
        }
    }
    
    func testGetAlbumByArtistID() {
        // arrange
        let json = """
{
    "message": {
        "header": {
            "status_code": 200,
            "execute_time": 0.017961978912354,
            "available": 71
        },
        "body": {
            "album_list": [
                {
                    "album": {
                        "album_id": 37484781,
                        "album_mbid": "",
                        "album_name": "Toosie Slide - Single",
                        "album_rating": 100,
                        "album_release_date": "2020-04-03",
                        "artist_id": 33491453,
                        "artist_name": "Drake",
                        "primary_genres": {
                            "music_genre_list": [
                                {
                                    "music_genre": {
                                        "music_genre_id": 34,
                                        "music_genre_parent_id": 0,
                                        "music_genre_name": "Music",
                                        "music_genre_name_extended": "Music",
                                        "music_genre_vanity": "Music"
                                    }
                                }
                            ]
                        },
                        "album_pline": "℗ 2020 OVO, under exclusive license to Republic Records, a division of UMG Recordings, Inc.",
                        "album_copyright": "℗ 2020 OVO, under exclusive license to Republic Records, a division of UMG Recordings, Inc.",
                        "album_label": "OVO",
                        "restricted": 0,
                        "updated_time": "2020-04-17T09:57:04Z",
                        "external_ids": {
                            "spotify": [
                                "4VQUnP3QFjxWLCR86NlV8p"
                            ],
                            "itunes": [
                                "1505950451"
                            ],
                            "amazon_music": []
                        }
                    }
                }
            ]
        }
    }
}
""".data(using: .utf8)!
        
        
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
     
        
        let assertedGenreID = 34
        let artistName = "Drake"
        do {
            let decodedGenreID = try JSONDecoder().decode(Start.self, from: json)
            let genreID = decodedGenreID.message.body.album_list.first?.album.artist_name ?? ""
            print(genreID)
            XCTAssertEqual(artistName, genreID)
            
        } catch {
            XCTFail("decoding error: \(error)")
        }
    }
}
