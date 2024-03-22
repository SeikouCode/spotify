//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation

struct FeaturedPlaylistsResponse: Decodable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Decodable {
    let items: [FeaturedPlaylists]
}

struct FeaturedPlaylists: Decodable {
    let name: String?
    let description: String?
    let id: String?
    let externalUrls: [String: String]?
    let images: [ImageDataModel]?
    let owner: User?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case id
        case externalUrls = "external_urls"
        case images
        case owner
    }
}

struct User: Decodable {
    let id: String?
    let displayName: String?
    let externalUrls: [String: String]?
    
    enum CodingKeys: String,CodingKey {
        case id
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}
