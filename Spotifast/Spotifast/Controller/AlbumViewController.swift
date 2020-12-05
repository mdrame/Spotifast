//
//  AlbumViewController.swift
//  Spotifast
//
//  Created by Mohammed Drame on 12/5/20.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        albumtableViewConstraint()
      
    }
    
    // UIKit Stuff
    
    lazy var albumTableVIew: UITableView = {
        let albumTableVIew = UITableView(frame: .zero)
        albumTableVIew.translatesAutoresizingMaskIntoConstraints = false
        albumTableVIew.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.cellIdentifier)
        albumTableVIew.rowHeight = 100
        return albumTableVIew
    }()
    
    func albumtableViewConstraint() {
        albumTableVIew.delegate = self
        albumTableVIew.dataSource = self
        view.addSubview(albumTableVIew)
        NSLayoutConstraint.activate([
            albumTableVIew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumTableVIew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumTableVIew.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            albumTableVIew.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    
    // Tableview delegeate and datasourse
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.cellIdentifier, for: indexPath) as! AlbumTableViewCell
        return cell
    }
    
    
    

}
