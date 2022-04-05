//
//  AlbumSearch.swift
//  MusicMatchV2
//
//  Created by Chakane Shegog on 4/3/22.
//

import UIKit

class AlbumSearch: UIViewController {
    var artistID: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(for: artistID!)
        
    }
    
    func loadData(for artistID: Int) {
        MusixMatchAPIClient.fetchArtistAlbums(for: artistID) { (result) in
            switch result {
            case .failure(let networkError):
                print("something went wrong")
            case .success(let data):
                dump(data)
            }
            
        }
    }
    



}
