//
//  MusixMatchAPIClient.swift
//  MusicMatchV2
//
//  Created by Chakane Shegog on 3/28/22.
//

import Foundation

struct MusixMatchAPIClient {
    static func fetchArtist(for artistName: String, completion: @escaping (Result<[Artist], NetworkError>) -> ()) {
        // create a URLRequest object from our endpoint
        let artistName = artistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "nil"
        let endpointURLString = "http://api.musixmatch.com/ws/1.1/artist.search?q_artist=\(artistName)&page_size=15&apikey=\(Secrets.apiKey)"
        guard let url = URL(string: endpointURLString) else {
            completion(.failure(.badURL(endpointURLString)))
            return
        }
        let request = URLRequest(url: url)
        
        // perform our data task
        NetworkRequest.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let networkError):
                completion(.failure(.networkClientError(networkError)))
            case .success(let data):
                do {
                    let artists = try JSONDecoder().decode(Artists.self, from: data)
                    completion(.success(artists.message.body.artist_list))
                } catch {
                    
                }
            }
        }
    }
    
    static func fetchArtistAlbums(for artistID: Int, completion: @escaping (Result<Album, NetworkError>) -> ()) {
        let endpointURLString = "http://api.musixmatch.com/ws/1.1/artist.albums.get?artist_id=\(artistID)&s_release_date=desc&apikey=\(Secrets.apiKey)d&page=2"
        guard let url = URL(string: endpointURLString) else {
            completion(.failure(.badURL(endpointURLString)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkRequest.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let networkError):
                completion(.failure(.networkClientError(networkError)))
            case .success(let data):
                do {
                    let albums = try JSONDecoder().decode(AlbumDetails.self, from: data)
                    completion(.success(albums.album))
                } catch {
                    
                }
                
            }
        }
    }
}
