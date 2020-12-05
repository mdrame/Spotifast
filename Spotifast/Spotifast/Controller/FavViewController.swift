//
//  FavViewController.swift
//  Spotifast
//
//  Created by Mohammed Drame on 12/1/20.
//

import UIKit

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerStuff(title: "Favs")
        favTableViewConstrain()
        // Do any additional setup after loading the view.
    }
    
    func navigationControllerStuff(title: String) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = title
    }
    
    lazy var favoriteSongsTableView: UITableView = {
        let favoriteSongsTableView = UITableView(frame: .zero)
        favoriteSongsTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteSongsTableView.register(FavoriteViewControllerTableViewCell.self, forCellReuseIdentifier: FavoriteViewControllerTableViewCell.cellIdentifier)
        favoriteSongsTableView.rowHeight = 100
        return favoriteSongsTableView
    }()
    
    func favTableViewConstrain() {
        favoriteSongsTableView.delegate = self
        favoriteSongsTableView.dataSource = self
        view.addSubview(favoriteSongsTableView)
        NSLayoutConstraint.activate([
            favoriteSongsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteSongsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteSongsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteSongsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    // Tableview delegeate and datasourse
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewControllerTableViewCell.cellIdentifier, for: indexPath) as! FavoriteViewControllerTableViewCell
//        configureCell(cell: cell, for: indexPath
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    

   

}
