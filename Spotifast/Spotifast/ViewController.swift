//
//  ViewController.swift
//  Spotifast
//
//  Created by Mohammed Drame on 11/12/20.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    // Protocol
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    func startSession(code: String) {
        print("Session started")
    }
    


}

