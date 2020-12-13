//
//  SpotifastSound.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation

struct SpotifastSound {
    let id: String
    let title: String
    let artist: String?
    let previewUrl: URL?
    let images: [ArtistImage]
    
    init(artist: String?, id: String, title: String, previewURL: URL?, images: [ArtistImage]) {
        self.artist = artist
        self.id = id
        self.title = title
        self.images = images
        self.previewUrl = previewURL
    }
}


