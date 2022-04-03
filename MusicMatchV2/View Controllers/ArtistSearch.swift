//
//  ArtistSearch.swift
//  MusicMatchV2
//
//  Created by Chakane Shegog on 4/2/22.
//

import UIKit

class ArtistSearch: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // setup data based off our model
    var artistData = [Artist]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    // makes the network request based of users search text
    func loadData(for searchText: String) {
        MusixMatchAPIClient.fetchArtist(for: searchText) { (result) in
            switch result {
            case .failure(let err):
                print("error: \(err)")
                
            case .success(let data):
                dump(data)
                self.artistData = data
            }
        }
    }
    
    // send artist ID over to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let albumSearch = segue.destination as? AlbumSearch, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("could not get an instance of AlbumSearch, verify class name in identity inspector")
        }
        let artistID = artistData[indexPath.row]
        albumSearch.artistID = artistID.artist.artist_id
        
    }
}

extension ArtistSearch: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath)
        let artistName = artistData[indexPath.row]
        cell.textLabel?.text = artistName.artist.artist_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistData.count
    }
    
}

extension ArtistSearch: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // this dismisses the keyboard
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else {
            print("missing search text")
            return
        }
        
        // whenever the user enters in something in the searchbar
        // we hit this function for new artist data
        loadData(for: searchText)
    }
}
