//
//  FavoritesViewController.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    private let artistTableView = UITableView()
    private var artists = [ArtistItem]()
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var vibezSoundz = [SpotifastSound]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        displayNavigation()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteSongs()
    }
    
    func displayNavigation(){
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    private func buildTableView() {
        self.view.addSubview(artistTableView)
        artistTableView.translatesAutoresizingMaskIntoConstraints = true
        artistTableView.frame = self.view.bounds
        artistTableView.dataSource = self
        artistTableView.delegate = self
        artistTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        artistTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    private func fetchFavoriteSongs(){
        let token = UserDefaults.standard.string(forKey: "token")
        var tracks: [String]?
        tracks = UserDefaults.standard.stringArray(forKey: "favoriteSongs")
         
        if tracks != nil && !tracks!.isEmpty {
            apiClient.call(request: .getFavoriteUserSongs(ids: tracks!, token: token!, completions: { (playlist) in
                    switch playlist {
                    case .failure(let error):
                        print(error)
                    case .success(let playlist):
                        self.vibezSoundz = [SpotifastSound]()
                        
                        for track in playlist.tracks {
                            let newTrack = SpotifastSound(artist: track.album.artists.first?.name,
                                                       id: track.id,
                                                       title: track.name,
                                                       previewURL: track.previewUrl,
                                                       images: track.album.images!)
                            self.vibezSoundz.append(newTrack)
                        }
                        
                        DispatchQueue.main.async {
                            self.buildTableView()
                            self.artistTableView.reloadData()
                        }
                    }
                }))
        } else {
            artistTableView.removeFromSuperview()
        }
    }
}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vibezSoundz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        //cell.accessoryType = .disclosureIndicator
        
//        let artist = artists[indexPath.row]
//        cell.setArtist(artist: artist)
        cell.records = vibezSoundz[indexPath.row]
        cell.setSong(song: vibezSoundz[indexPath.row], starButtonHidden: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
}
