//
//  HomeViewController.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var sounds = [SpotifastSound]()
    private var top50TableView = UITableView()
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = true
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemGreen]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
//        logoffButton.
        self.navigationItem.rightBarButtonItem = logoffButton
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        setGradientBackground()
        fetchTop50()

    }
    
    private func configureTop50TableView(){
        self.view.addSubview(top50TableView)
        top50TableView.translatesAutoresizingMaskIntoConstraints = false
        top50TableView.dataSource = self
        top50TableView.delegate = self
        top50TableView.frame = self.view.bounds
        top50TableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        top50TableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        top50TableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    private func fetchTop50(){
        let top50 = "37i9dQZEVXbMDoHDwVN2tF"
        let token = UserDefaults.standard.string(forKey: "token")
        apiClient.call(request: .getArtistPlaylist(token: token!, playlistId: top50, completions: { (playlist) in
            switch playlist {
            case .failure(let error):
                print(error)
            case .success(let playlist):
                for track in playlist.tracks.items {
                    let newTrack = SpotifastSound(artist: track.track.artists.first?.name,
                                               id: track.track.id,
                                               title: track.track.name,
                                               previewURL: track.track.previewUrl,
                                               images: track.track.album!.images)
                    self.sounds.append(newTrack)
                }
                
                DispatchQueue.main.async {
                    self.configureTop50TableView()
                }
            }
        }))
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sounds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.selectionStyle = .none
        cell.records = sounds[indexPath.row]
        cell.setSong(song: sounds[indexPath.row], starButtonHidden: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return CGFloat(20)
        }
    
    

    
    
    
    
}
