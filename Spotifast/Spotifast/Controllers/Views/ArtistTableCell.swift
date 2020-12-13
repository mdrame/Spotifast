//
//  ArtistTableCell.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation
import UIKit
import Kingfisher

class ArtistTableCell: UITableViewCell {
    
    static var identifier = "ArtistTableCell"
    
    let artistImage = UIImageView()
    let artistLabel = UILabel()
    let songLabel = UILabel()
    var records: SpotifastSound!
    
    let playButtonImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let play = UIImage(systemName: "play.fill")
        let playSelected = play?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
        image.image = playSelected
        return image
    }()
    
    lazy var playButtonHidden: UIButton = {
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.addTarget(self, action: #selector(hiddenPlayButtonTapped), for: .touchUpInside)
        return button1
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteSelected), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9612496495, green: 0.9555351138, blue: 0.9656421542, alpha: 1)
        self.contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    @objc func favoriteSelected(){
        guard var favoriteSongsID = UserDefaults.standard.stringArray(forKey: "favoriteSongs") else {
            var favoriteSongsID = [String]()
            favoriteSongsID.append(records.id)
            UserDefaults.standard.set(favoriteSongsID, forKey: "favoriteSongs")
            let star = UIImage(systemName: "star.fill")
            let blueStar = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            favoriteButton.setImage(blueStar, for: .normal)
            return
        }
        
        if !favoriteSongsID.contains(records.id) {
            let star = UIImage(systemName: "star.fill")
            let blueStar = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            favoriteButton.setImage(blueStar, for: .normal)
            favoriteSongsID.append(records.id)
        } else {
            favoriteSongsID = favoriteSongsID.filter(){$0 != records.id}
            let star = UIImage(systemName: "star")
            let blueStar = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            favoriteButton.setImage(blueStar, for: .normal)
            
        }
        
        UserDefaults.standard.set(favoriteSongsID, forKey: "favoriteSongs")
    }
    
    @objc func hiddenPlayButtonTapped(){
        var currentPlayingId = UserDefaults.standard.string(forKey: "current_playing_id")
        
        guard let player = SpotifastPlayer.shared.player else {
            if let previewURL = records.previewUrl {
                SpotifastPlayer.shared.downloadFileFromURL(url: previewURL)
            }
            currentPlayingId = records.id
            UserDefaults.standard.set(currentPlayingId, forKey: "current_playing_id")
            
            DispatchQueue.main.async {
                let play = UIImage(systemName: "pause.fill")
                let playSelected = play?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
                self.playButtonImage.image = playSelected
            }
            return
        }
        
        if currentPlayingId == records.id && player.isPlaying{
            player.pause()
            
            let play = UIImage(systemName: "play.fill")
            let playSelected = play?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            playButtonImage.image = playSelected
            
        }else if currentPlayingId == records.id && !player.isPlaying {
            player.play()
            let play = UIImage(systemName: "pause.fill")
            let playSelected = play?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            playButtonImage.image = playSelected
            
        }else {
            if let previewURL = records.previewUrl {
                SpotifastPlayer.shared.downloadFileFromURL(url: previewURL)
            }
            currentPlayingId = records.id
            UserDefaults.standard.set(currentPlayingId, forKey: "current_playing_id")
            
            DispatchQueue.main.async {
                let play = UIImage(systemName: "pause.fill")
                let playSelected = play?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
                self.playButtonImage.image = playSelected
            }
        }
    }
    
    fileprivate func configureCell(starButtonHidden: Bool?, hidePlayButton: Bool?){
        
        self.contentView.addSubview(favoriteButton)
        self.contentView.addSubview(songLabel)
        self.contentView.addSubview(artistLabel)
        self.contentView.addSubview(artistImage)
        self.contentView.addSubview(playButtonHidden)
        self.contentView.addSubview(playButtonImage)
        
        if starButtonHidden! && !hidePlayButton! {
            favoriteButton.isHidden = true
            artistImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
            playButtonHidden.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        } else if starButtonHidden! && hidePlayButton!{
            artistLabel.isHidden = true
            playButtonImage.isHidden = true
            playButtonHidden.isHidden = true
            favoriteButton.isHidden = true
            artistImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true
        } else {
            artistImage.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: -3).isActive = true
            playButtonHidden.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor).isActive = true
        }
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive =  true
        favoriteButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive =  true
        favoriteButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        
        artistImage.translatesAutoresizingMaskIntoConstraints = false
        artistImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:3).isActive =  true
        artistImage.leadingAnchor.constraint(equalTo: self.favoriteButton.trailingAnchor, constant: 2).isActive =  true
        artistImage.widthAnchor.constraint(equalToConstant: 85).isActive = true
        artistImage.heightAnchor.constraint(equalToConstant: 85).isActive = true
        artistImage.contentMode = .scaleAspectFill
        
            
              // Make Image Corners Rounded
        artistImage.layer.cornerRadius = 40
        artistImage.clipsToBounds = true
        artistImage.layer.borderWidth = 1
        artistImage.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0)
        
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        songLabel.font = UIFont(name: "Arial-Bold", size: 12)
        songLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        songLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 8).isActive = true
        songLabel.trailingAnchor.constraint(equalTo: self.playButtonImage.leadingAnchor, constant: 10).isActive = true
        
        playButtonHidden.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        playButtonHidden.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        
        artistLabel.font = UIFont.systemFont(ofSize: 12)
        artistLabel.textColor = .systemGray
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 10).isActive = true
        artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        
        playButtonImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        playButtonImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 160).isActive = true
        playButtonImage.leadingAnchor.constraint(equalTo: songLabel.trailingAnchor).isActive = true
        playButtonImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButtonImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    internal func setArtist(artist: ArtistItem) {
        configureCell(starButtonHidden: true, hidePlayButton: true)
        
        artistImage.kf.setImage(with: artist.images.first?.url, options: [], completionHandler:  { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.songLabel.text = artist.name
                    self.artistImage.image = value.image
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    internal func setSong(song: SpotifastSound, starButtonHidden: Bool) {
        configureCell(starButtonHidden: starButtonHidden, hidePlayButton: false)
        
        if song.previewUrl == nil {
            playButtonHidden.isHidden = true
            playButtonImage.isHidden = true
        } else {
            playButtonHidden.isHidden = false
            playButtonImage.isHidden = false
        }
        
        var favoriteSongsId = [String]()
        favoriteSongsId = UserDefaults.standard.stringArray(forKey: "favoriteSongs") ?? [String]()
        
        if !starButtonHidden {
            if !favoriteSongsId.isEmpty {
                if favoriteSongsId.contains(song.id) {
                    let star = UIImage(systemName: "star.fill")
                    let starSelected = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
                    favoriteButton.setImage(starSelected, for: .normal)
                }else {
                    let star = UIImage(systemName: "star")
                    let starSelected = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
                    favoriteButton.setImage(starSelected, for: .normal)
                }
            } else {
                let star = UIImage(systemName: "star")
                let starSelected = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
                favoriteButton.setImage(starSelected, for: .normal)
            }
        }
        
        let currentPlayingId = UserDefaults.standard.string(forKey: "current_playing_id")
        
        // update appropriate play/pause icon
        if let player = SpotifastPlayer.shared.player {
            if player.isPlaying {
                if currentPlayingId == song.id {
                    let play = UIImage(systemName: "pause.fill")
                    let playSelected = play?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
                    playButtonImage.image = playSelected
                } else {
                    let play = UIImage(systemName: "play.fill")
                    let playSelected = play?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
                    playButtonImage.image = playSelected
                }
                
            }
        }
        
        for image in song.images {
            if image.height == 300 {
                artistImage.kf.setImage(with: image.url, completionHandler:  { result in
                    switch result {
                    case .success(let value):
                        
                        DispatchQueue.main.async {
                            self.artistImage.image = value.image
                            self.songLabel.text = song.title
                            self.artistLabel.text = song.artist
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                })
            }
        }
    }
    
}
