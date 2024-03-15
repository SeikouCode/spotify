//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation

struct FeaturedPlaylistsResponse: Decodable {
    let message: String
    let playlists: [PlaylistItem] // Теперь playlists является массивом объектов PlaylistItem
}

struct PlaylistItem: Decodable {
    let collaborative: Bool
    let description: String
    let externalUrls: [String: String]
    let href: String
    let id: String
    let images: [ImageData]
    let name: String
    let owner: Owner
    let isPublic: Bool
    let snapshotId: String
    let tracks: TracksInfo
    let type: String
    let uri: String
    let primaryColor: String?

    enum CodingKeys: String, CodingKey {
        case collaborative, description, externalUrls = "external_urls", href, id, images, name, owner, isPublic = "public", snapshotId = "snapshot_id", tracks, type, uri, primaryColor = "primary_color"
    }
}

struct Owner: Decodable {
    let externalUrls: [String: String]
    let href: String
    let id: String
    let type: String
    let uri: String
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls", href, id, type, uri, displayName = "display_name"
    }
}

struct TracksInfo: Decodable {
    let href: String
    let total: Int
}

struct ImageData: Decodable {
    let url: String
}
