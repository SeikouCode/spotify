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

    func didLoad(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        loadAlbums {
            group.leave()
        }
        
        group.enter()
        loadPlaylists {
            group.leave()
        }
        
        group.enter()
        loadRecommended {_ in
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }

    func loadAlbums(completion: @escaping () -> Void) {
        var albums: [AlbumsData] = []
        
        AlbumsManager.shared.getNewReleases { [weak self] result in
            switch result {
            case .success(let response):
                response.forEach {
                    albums.append(.init(title: $0.name, image: $0.images.first?.url))
                }
                if let index = self?.sections.firstIndex(where: {
                    if case .newReleasedAlbums = $0 {
                        return true
                    } else {
                        return false
                    }
                }) {
                    self?.sections[index] = .newReleasedAlbums(title: "New_released_albums".localized, datamodel: albums)
                }
                completion()
            case .failure(let error):
                break
            }
        }
    }
    
    func loadPlaylists(completion: @escaping () -> Void) {
        var playlists: [AlbumsData] = []

        PlaylistManager.shared.getFeaturedPlaylists { result in
            switch result {
            case .success(let response):
                response.playlists.forEach { playlist in
                    playlists.append(.init(title: playlist.name, image: playlist.images.first?.url))
                }

                if let index = self.sections.firstIndex(where: {
                    if case .featuredPlaylists = $0 {
                        return true
                    } else {
                        return false
                    }
                }) {
                    self.sections[index] = .featuredPlaylists(title: "Featured_playlists".localized, datamodel: playlists)
                }
                completion()
            case .failure(let error):
                break
            }
        }
    }

    func loadRecommended(completion: @escaping ([RecommendedMusicData]) -> ()) {
        AlbumsManager.shared.getRecommendedGenres { [weak self] response in
            switch response {
            case .success(let genres):
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                let seedsGenres = seeds.joined(separator: ",")
                AlbumsManager.shared.getRecommendations(genres: seedsGenres) { [weak self] response in
                    
                    switch response {
                    case .success(let result):
                        print("Received recommended tracks:", result)
                        let recommendedMusicData = result.map { track in
                            return RecommendedMusicData(title: track.name, subtitle: track.artists.first?.name ?? "", image: track.album.images.first?.url ?? "")
                        }
                        if let index = self?.sections.firstIndex(where: {
                            if case .recommended = $0 {
                                return true
                            } else {
                                return false
                            }
                        }) {
                            self?.sections[index] = .recommended(title: "Recommended".localized, datamodel: recommendedMusicData)
                            completion(recommendedMusicData)
                        }
                    case .failure(let error):
                        print("Failed to load recommended tracks:", error.localizedDescription)
                        completion([])
                    }
                }
            case .failure(let error):
                print("Failed to load recommended genres:", error.localizedDescription)
                completion([])
            }
        }
    }
}
