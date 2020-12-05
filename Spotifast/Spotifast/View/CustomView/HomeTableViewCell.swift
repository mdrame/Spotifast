//
//  HomeTableViewCell.swift
//  Spotifast
//
//  Created by Mohammed Drame on 12/1/20.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static let cellIdentifier = "homeCell"
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(newReleaseImage)
        self.contentView.addSubview(newReleaseLabelTitle)
//        newReleaseImage(view: newReleaseImage)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var newReleaseImage: UIImageView = {
       let newReleaseImages = UIImageView(frame: CGRect(x: 20, y: 7, width: 75, height: 75))
        newReleaseImages.image = UIImage(named: "clock.png")
        newReleaseImages.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        newReleaseImages.translatesAutoresizingMaskIntoConstraints = false
        newReleaseImages.layer.cornerRadius = 10
        return newReleaseImages
    }()
    
    lazy var newReleaseLabelTitle: UILabel = {
        let newReleaseLabelTitle = UILabel(frame: CGRect(x: newReleaseImage.frame.size.width + 40, y: newReleaseImage.frame.size.height / 2, width: 150, height:    30))
        newReleaseLabelTitle.text = "SPD Industry"
        newReleaseLabelTitle.translatesAutoresizingMaskIntoConstraints = false
    return newReleaseLabelTitle
    }()
    
//    func newReleaseImage(view: UIImageView) {
//            NSLayoutConstraint.activate([
//                view.topAnchor.constraint(equalTo: view.topAnchor),
//                view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//                view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//            ])
//
//    }
    
    
    

}

