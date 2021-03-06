//
//  FavoriteArtistsViewController.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation
import UIKit

class FavoriteArtistsViewController: UIViewController {
    
    private let favoriteArtistsTableView = UITableView()
    private var artists = [ArtistItem]()
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTableViewData()
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    private func fetchTableViewData(){

        let token = (UserDefaults.standard.string(forKey: "token"))
        print(token!)
        apiClient.call(request: .getFavoriteUserArtists(token: token!, completions: { (result) in
            switch result {
            case .success(let results):
                self.artists = results.items
                DispatchQueue.main.async {
                    self.buildArtistTableView()
                }
            case .failure(let error):
                print(error)
                print("got back completion; error")
            }
        }))
        
    }
    
    private func buildArtistTableView(){
        self.view.addSubview(favoriteArtistsTableView)
        favoriteArtistsTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteArtistsTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        favoriteArtistsTableView.frame = self.view.bounds
        favoriteArtistsTableView.dataSource = self
        favoriteArtistsTableView.delegate = self
        favoriteArtistsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
}

extension FavoriteArtistsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.accessoryType = .disclosureIndicator
        let artist = artists[indexPath.row]
        cell.setArtist(artist: artist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        
        let destinationVC = TopArtistSongsViewController()
        destinationVC.artist = artist
        favoriteArtistsTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
}
