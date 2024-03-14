//
//  HomeViewModel.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import Foundation
import Moya

class HomeViewModel {
    private let provider = MoyaProvider<HomeTarget>()
    private var sections = [HomeSectionType]()

    func fetchData(completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()

        group.enter()
        fetchNewReleases { result in
            defer { group.leave() }
            switch result {
            case .success(let data):
                self.sections.append(.newReleasedAlbums(title: "New Releases", datamodel: data.albums.items.map { AlbumsData(title: $0.name ?? "", image: UIImage()) }))
            case .failure(let error):
                print("Error fetching new releases: \(error)")
                completion(.failure(error))
                return
            }
        }

        group.enter()
        fetchFeaturedPlaylists { result in
            defer { group.leave() }
            switch result {
            case .success(let data):
                self.sections.append(.featuredPlaylists(title: "Featured Playlists", datamodel: data.playlists.items.map { AlbumsData(title: $0.name, image: UIImage()) }))
            case .failure(let error):
                print("Error fetching featured playlists: \(error)")
                completion(.failure(error))
                return
            }
        }

        group.enter()
        fetchRecommendedGenres { result in
            defer { group.leave() }
            switch result {
            case .success(let genres):
                let recommendedData = genres.map { RecommendedMusicData(title: $0, subtitle: nil, image: UIImage()) }
                self.sections.append(.recommended(title: "Recommended", datamodel: recommendedData))
            case .failure(let error):
                print("Error fetching recommended genres: \(error)")
                completion(.failure(error))
                return
            }
        }

        group.notify(queue: .main) {
            completion(.success(()))
        }
    }

    private func fetchNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        provider.request(.getNewReleases) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(NewReleasesResponse.self)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func fetchFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        provider.request(.getFeaturedPlaylists) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(FeaturedPlaylistsResponse.self)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func fetchRecommendedGenres(completion: @escaping (Result<[String], Error>) -> Void) {
        provider.request(.getRecommendedGenres) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(RecommendedGenresResponse.self)
                    completion(.success(decodedResponse.genres))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    func getSectionViewModel(at index: Int) -> HomeSectionType? {
        guard index >= 0 && index < sections.count else {
            return nil
        }
        return sections[index]
    }
}
