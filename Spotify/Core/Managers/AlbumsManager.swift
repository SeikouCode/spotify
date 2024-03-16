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
    
    func getNewReleases(completion: @escaping (Result<[Playlist], Error>) -> ()) {
        provider.request(.getNewReleases) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(NewReleasesResponse.self, from: response.data)
                    completion(.success(dataModel.albums.items))
                } catch {
                    print("Error decoding response data:", error)
                    print("Response data:", String(data: response.data, encoding: .utf8) ?? "Unable to decode data")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
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
                    print("Error decoding response data:", error)
                    print("Response data:", String(data: response.data, encoding: .utf8) ?? "Unable to decode data")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRecommendedGenres(completion: @escaping (Result<[String], Error>) -> ()) {
        provider.request(.getRecommendedGenres) { result in
            switch result {
            case .success(let response):
                do {
                    let genres = try JSONDecoder().decode(RecommendedDataModel.self, from: response.data)
                    completion(.success(genres.genres))
                } catch {
                    print("Error decoding response data:", error)
                    print("Response data:", String(data: response.data, encoding: .utf8) ?? "Unable to decode data")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
