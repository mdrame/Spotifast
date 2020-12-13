//
//  SpotifyK.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation

struct Key {
    static let SPOTIFY_API_CLIENT_ID = "a7b7fd4e502f49ed86da9c02a6e058d1"
    static let SPOTIFY_API_CLIENT_SECRET = "6ad2556119954207aeee795da31fb63e"
    static let REDIRECT_URI = "Spotifast://"
    static let USER_SCOPES = ["user-read-email", "user-top-read"]
    static let RESPONSE_TYPE = "code"
}

enum SpotifyURL: String {
    case authBaseURL = "https://accounts.spotify.com/api/"
    case APICallBase = "https://api.spotify.com/v1/"
}
