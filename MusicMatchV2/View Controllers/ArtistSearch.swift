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
    var artistData = [Artists]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
}

extension ArtistSearch: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}

extension ArtistSearch: UITableViewDelegate {
    
}

extension ArtistSearch: UISearchBarDelegate {
    
}
