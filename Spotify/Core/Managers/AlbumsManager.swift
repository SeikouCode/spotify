//
//  AlbumsManager.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation
import Moya

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

final class AlbumsManager {
    static let shared = AlbumsManager()
    
    private let provider = MoyaProvider<HomeTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getNewReleases(completion: @escaping (APIResult<[Playlist]>) -> ()) {
        provider.request(.getNewReleases) { result in
            switch result {
            case .success(let response):
                guard let dataModel = try? JSONDecoder().decode(NewReleasesResponse.self, from: response.data) else { return }
                completion(.success(dataModel.albums.items))
            case .failure(let error):
                break
            }
        }
    }
    
    func getRecommendations(genres: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        provider.request(.getRecommendations(genres: genres)) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(RecommendedGenresResponse.self, from: response.data)
                    completion(.success(dataModel.tracks))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRecommendedGenres(completion: @escaping ([String]) -> ()) {
        provider.request(.getRecommendedGenres) { result in
            switch result {
            case .success(let response):
                guard let genres = try? JSONDecoder().decode(RecommendedDataModel.self, from: response.data) else {
                    return
                }
                completion(genres.genres)
            case .failure(let error):
                break
            }
        }
    }
}

