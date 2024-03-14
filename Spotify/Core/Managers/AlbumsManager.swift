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
    
    func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        provider.request(.getNewReleases) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try response.map(NewReleasesResponse.self)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRecommendations(genres: String, completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        provider.request(.getRecommendations(genres: genres)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try response.map(RecommendedGenresResponse.self)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        provider.request(.getRecommendedGenres) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try response.map(RecommendedGenresResponse.self)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

