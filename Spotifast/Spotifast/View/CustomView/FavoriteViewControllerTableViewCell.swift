//
//  FavoriteViewControllerTableViewCell.swift
//  Spotifast
//
//  Created by Mohammed Drame on 12/5/20.
//

import UIKit

class FavoriteViewControllerTableViewCell: UITableViewCell {

    static let cellIdentifier = "homeCell"
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(favImage)
        self.contentView.addSubview(favSongtittle)
        self.contentView.addSubview(favArtistLabel)
        self.contentView.addSubview(playSongButton)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var favImage: UIImageView = {
       let favImage = UIImageView(frame: CGRect(x: 20, y: 7, width: 75, height: 75))
        favImage.image = UIImage(named: "clock.png")
        favImage.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        favImage.layer.cornerRadius = 10
        favImage.translatesAutoresizingMaskIntoConstraints = false
        return favImage
    }()
    
    lazy var favSongtittle: UILabel = {
        let favSongtittle = UILabel(frame: CGRect(x: favImage.frame.size.width + 40, y: favImage.frame.size.height / 2, width: 150, height:    30))
        favSongtittle.text = "All my life"
        favSongtittle.translatesAutoresizingMaskIntoConstraints = false
    return favSongtittle
    }()
    
    lazy var favArtistLabel: UILabel = {
        let favArtistLabel = UILabel(frame: CGRect(x: favImage.frame.size.width + 40, y: favImage.frame.size.height / 2 + 20, width: 150, height:    30))
        favArtistLabel.text = "Lil bread"
        favArtistLabel.translatesAutoresizingMaskIntoConstraints = false
    return favArtistLabel
    }()
    
    lazy var playSongButton: UIButton = {
        let playSongButton = UIButton(frame: CGRect(x: 290, y: 40, width: 20, height: 20))
        playSongButton.translatesAutoresizingMaskIntoConstraints = false
        playSongButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        playSongButton.layer.cornerRadius = 10
    return playSongButton
    }()

}
