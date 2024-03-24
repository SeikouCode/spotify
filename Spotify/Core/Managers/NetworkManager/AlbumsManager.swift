//
//  AlbumsManager.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation
import Moya

final class AlbumsManager {
    static let shared = AlbumsManager()
    
    private let provider = MoyaProvider<HomeTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getNewReleases(completion: @escaping (APIResult<[Album]>) -> Void) {
        provider.request(.getNewReleases) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(NewReleasesResponse.self, from: response.data)
                    completion(.success(dataModel.albums.items))
                } catch {
                    print("Error decoding new releases response:", error)
                    completion(.failure(.incorrectJSON))
                }
            case .failure(let error):
                completion(.failure(.networkFail))
            }
        }
    }
    
    func getFeaturedPlaylists(completion: @escaping (APIResult<[FeaturedPlaylists]>) -> Void) {
        provider.request(.getFeaturedPlaylists) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: response.data)
                    completion(.success(dataModel.playlists.items))
                } catch {
                    print("Error decoding featured playlists response:", error)
                    completion(.failure(.incorrectJSON))
                }
            case .failure(let error):
                completion(.failure(.networkFail))
            }
        }
    }
    
    func getRecommendations(genres: String, completion: @escaping (APIResult<[Track]>) -> Void) {
        provider.request(.getRecommendations(genres: genres)) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(RecommendedGenresResponse.self, from: response.data)
                    completion(.success(dataModel.tracks))
                } catch {
                    print("Error decoding recommendations response:", error)
                    completion(.failure(.incorrectJSON))
                }
            case .failure(let error):
                print("Failed to get recommendations:", error)
                completion(.failure(.networkFail))
            }
        }
    }
    
    func getRecommendedGenres(completion: @escaping (Result<[String], Error>) -> Void) {
        provider.request(.getRecommendedGenres) { result in
            switch result {
            case .success(let response):
                do {
                    let genres = try JSONDecoder().decode(RecommendedDataModel.self, from: response.data)
                    completion(.success(genres.genres))
                } catch {
                    print("Error decoding recommended genres response:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed to get recommended genres:", error)
                completion(.failure(error))
            }
        }
    }
}
