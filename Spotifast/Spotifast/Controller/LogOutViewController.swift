//
//  LogOutViewController.swift
//  Spotifast
//
//  Created by Mohammed Drame on 12/1/20.
//

import UIKit

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(currenntUserSting)
        view.addSubview(logOutButton)
        // Do any additional setup after loading the view.
    }
    
    
    lazy var currenntUserSting: UILabel = {
        let currenntUserSting = UILabel(frame: CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2, width: 300, height: 10))
        currenntUserSting.text = "Hi, "
        currenntUserSting.translatesAutoresizingMaskIntoConstraints = false
    return currenntUserSting
    }()
    
    lazy var logOutButton: UIButton = {
        let logOutButton = UIButton(frame: CGRect(x: 90, y: self.view.frame.size.height / 2 + 20, width: 250, height: 100))
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        logOutButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        logOutButton.setTitle("LOGOUT", for: .normal)
        logOutButton.layer.cornerRadius = 10
    return logOutButton
    }()
    
    
    

   
}
