//
//  LoginViewController.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation
import UIKit
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    let logoLabelView = UILabel()
    let logoImageView = UIImageView()
    let loginButton = UIButton()
    let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
//        logoLabelViewPlacement()
        logoPlacement()
        loginButtonConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func logoLabelViewPlacement(){
        view.addSubview(logoLabelView)
        logoLabelView.text = " Spotifast ⚡️"
        logoLabelView.font = UIFont(name: "Arial", size: 60)
        logoLabelView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
//        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        logoLabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func logoPlacement(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "spotifast")
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    }
    
    func loginButtonConfiguration(){
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 15
        loginButton.setTitle("Log In | Spotifast ⚡️", for: .normal)
        loginButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        loginButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 25).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    
    @objc func buttonPressed(){
        verifyUserAuthentication()
//        self.view.window!.rootViewController = TabBarController()
    }
    
    func verifyUserAuthentication(){
            let urlRequest = apiClient.getSpotifyAccessCodeURL()
            print(urlRequest)
            let scheme = "auth"
            let session = ASWebAuthenticationSession(url: urlRequest, callbackURLScheme: scheme) { (callbackURL, error) in
                guard error == nil, let callbackURL = callbackURL else { return }
                
                let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
                guard let requestAccessCode = queryItems?.first(where: { $0.name == "code" })?.value else { return }
                print(" Code \(requestAccessCode)")
                self.apiClient.call(request: .verifyAccessToken(code: requestAccessCode, completion: { (token) in
                    switch token {
                    case .failure(let error):
                        print(error)
                    case .success(let token):
                        UserDefaults.standard.set(token.accessToken, forKey: "token")
                        UserDefaults.standard.set(token.refreshToken, forKey: "refresh_token")
                        print(token)
//                        self.navigationController?.pushViewController(FavoritesViewController(), animated: true)
                        self.view.window!.rootViewController = TabBarController()
                    }
                }))
            }
            session.presentationContextProvider = self
            session.start()
        }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
