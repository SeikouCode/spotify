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
        loadRecommendedMusics {
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
                print("Failed to load playlists: \(error.localizedDescription)")
                break
            }
        }
    }

    func loadRecommendedMusics(completion: @escaping () -> Void) {
        var musics: [RecommendedMusicData] = []

        AlbumsManager.shared.getRecommendedGenres { genres in  //выходит ошибка Type of expression is ambiguous without a type annotation
            var seeds = Set<String>()
            while seeds.count < 5 {
                if let random = genres.randomElement() {
                    seeds.insert(random)
                }
            }
            let seedsGenres = seeds.joined(separator: ",")
            AlbumsManager.shared.getRecommendations(genres: seedsGenres) { result in
                switch result {
                case .success(let response):
                    musics = response.tracks.map { track in
                        return RecommendedMusicData(title: track.name, image: track.album.images.first?.url)
                    }
                    let index: Int? = self.sections.firstIndex { section in
                        if case .recommended = section {
                            return true
                        } else {
                            return false
                        }
                    }
                if let index = index {
                    self.sections[index] = .recommended(title: "Recommended".localized, datamodel: musics)
                }
                completion()
            case .failure(let error):
                print("Failed to load recommended musics: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
}

