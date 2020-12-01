//
//  ViewController.swift
//  Spotifast
//
//  Created by Mohammed Drame on 11/12/20.
//

import UIKit
import AuthenticationServices

// todo
/// Log in and out

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    // Protocol
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationControllerStuff(title: "New Release")
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(Constants.clientID)&response_typecode&redirect_url=\(Constants.redirectURI)")!
        let scheme = "auth"
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme)
        {   callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let requestToken = queryItems?.first(where: { $0.name == "code" })?.value else { return }
            print("Code \(requestToken)")
            self.startSession(code: requestToken)
        }
        session.presentationContextProvider =  self
        session.start()
    }
    
    func navigationControllerStuff(title: String) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = title
    }
    
    func startSession(code: String) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI.absoluteString),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "client_secret", value: Constants.client_secret)
        ]
        
        request.httpBody = urlComponents.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "unknow error")
                return
            }
            
            
            guard (200 ... 299 ) ~= response.statusCode else {
                print("Status code: \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(jsonResult)
                let token = jsonResult?["access_token"] as! String
                print(token)
                self.getUser(accessToken: token)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    func getUser(accessToken: String) {
        let url = URL(string: "https://api.spotify.com/v1/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "unknown error")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(jsonResult)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
        task.resume()
        
    }
    
    
    
}




