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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
