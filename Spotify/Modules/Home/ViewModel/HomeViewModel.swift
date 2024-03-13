//
//  HomeViewModel.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit
 
class HomeViewModel {
    private var sections = [HomeSectionType]()
    
    var numberOfSections: Int {
        return sections.count
    }
    
    func getSectionViewModel(at section: Int) -> HomeSectionType {
        return sections[section]
    }
    
    func didLoad() {
        sections.append(.newRelesedAlbums(title: "New_released_albums".localized, datamodel: []))
        sections.append(.featuredPlaylists(title: "Featured_playlists".localized, datamodel: []))
        sections.append(.recommended(title: "Recommended".localized, datamodel: []))
    }
    
    func loadRecomendedMusics(comletion: () -> ()) {
        let musics: [RecommendedMusicData] = [
            .init(
                title: "Cozy Coffeehouse",
                subtitle: nil,
                image: UIImage(named: "music1") ?? UIImage()
            ),
            .init(
                title: "Cozy",
                subtitle: "Profile",
                image: UIImage(named: "music2") ?? UIImage()
            ),
            .init(
                title: "cozy clouds",
                subtitle: nil,
                image: UIImage(named: "music3") ?? UIImage()
            )
        ]
        
        AlbumsManager.shared.getRecommendedGenres { genres in
            var seeds = Set<String>()
            while seeds.count < 5 {
                if let random = genres.randomElement() {
                    seeds.insert(random)
                }
            }
            let seedsGenres = seeds.joined(separator: ",")
            AlbumsManager.shared.getRecommendations(genres: seedsGenres) {
    
            }
        }
        
        let index = sections.firstIndex(where: {
            if case .recommended = $0 {
                return true
            } else {
                return false
            }
        })
        if let index {
            sections[index] = .recommended(title: "Recommended".localized, datamodel: musics)
        }
        comletion()
    }
    
    func loadAlbums(comletion: () -> ()) {
        let albums: [AlbumsData] = [
            .init(
                title: "Kanye West: Vultures 1", image: UIImage(named: "album2") ?? UIImage()
            ),
            .init(
                title: "Playboi Carti: I am Music", image: UIImage(named: "album2") ?? UIImage()
            ),
            .init(
                title: "Travis Scott: Utopia", image: UIImage(named: "album2") ?? UIImage()
            )
        ]
        
        AlbumsManager.shared.getNewReleases {
            
        }
        
        if let index = sections.firstIndex(where: {
            if case .newRelesedAlbums = $0 {
                return true
            } else {
                return false
            }
        }) {
            sections[index] = .newRelesedAlbums(title: "New_released_albums".localized, datamodel: albums)
        }
        comletion()
    }
    
    func loadPlaylists(comletion: () -> ()) {
        let playlists: [AlbumsData] = [
            .init(
                title: "Indie India", image: UIImage(named: "album1") ?? UIImage()
            ),
            .init(
                title: "RADAR India", image: UIImage(named: "album1") ?? UIImage()
            ),
            .init(
                title: "RADAR India", image: UIImage(named: "album1") ?? UIImage()
            )
        ]
        
        if let index = sections.firstIndex(where: {
            if case .featuredPlaylists = $0 {
                return true
            } else {
                return false
            }
        }) {
            sections[index] = .featuredPlaylists(title: "Featured_playlists".localized, datamodel: playlists)
        }
        comletion()
    }
}
