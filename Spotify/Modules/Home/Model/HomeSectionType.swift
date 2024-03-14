//
//  HomeSectionType.swift
//  Spotify
//
//  Created by Aneli  on 06.03.2024.
//

import Foundation

enum HomeSectionType {
    case newReleasedAlbums(title: String, datamodel: [AlbumsData])
    case featuredPlaylists(title: String, datamodel: [AlbumsData])
    case recommended(title: String, datamodel: [RecommendedMusicData])
}
