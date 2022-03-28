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
    
}
