//
//  AlbumTableViewCell.swift
//  Spotifast
//
//  Created by Mohammed Drame on 12/5/20.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    static let cellIdentifier = "homeCell"
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(songTittleLabel)
        self.contentView.addSubview(artistNameLabel)
        self.contentView.addSubview(playSongButton)
        self.contentView.addSubview(favButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    lazy var songTittleLabel: UILabel = {
        let songTittleLabel = UILabel(frame: CGRect(x: 30, y: 2, width: 200, height: 75))
        songTittleLabel.text = "Life is too short"
        songTittleLabel.translatesAutoresizingMaskIntoConstraints = false
    return songTittleLabel
    }()
    
    lazy var artistNameLabel: UILabel = {
        let artistNameLabel = UILabel(frame: CGRect(x: 30, y: 28, width: 200, height: 75))
        artistNameLabel.text = "Sweete"
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return artistNameLabel
    }()
    
    lazy var playSongButton: UIButton = {
        let playSongButton = UIButton(frame: CGRect(x: 290, y: 40, width: 20, height: 20))
        playSongButton.translatesAutoresizingMaskIntoConstraints = false
        playSongButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        playSongButton.layer.cornerRadius = 10
    return playSongButton
    }()
    
    lazy var favButton: UIButton = {
        let favButton = UIButton(frame: CGRect(x: 330, y: 40, width: 20, height: 20))
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        favButton.layer.cornerRadius = 10
    return favButton
    }()
    
    
    
    
    

}
