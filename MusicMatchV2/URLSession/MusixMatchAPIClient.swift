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
}
