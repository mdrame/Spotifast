//
//  FavViewController.swift
//  Spotifast
//
//  Created by Mohammed Drame on 12/1/20.
//

import UIKit

class FavViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerStuff(title: "")
        // Do any additional setup after loading the view.
    }
    
    func navigationControllerStuff(title: String) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = title
    }
    

   

}
