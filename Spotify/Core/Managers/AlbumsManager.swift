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
    
    private let provider = MoyaProvider<AlbumsTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getNewReleases(completion: @escaping () -> Void) {
        provider.request(.getNewReleases) { result in
            switch result {
            case .success(let response):
                    guard let json = try? JSONDecoder().decode(NewReleasesResponse.self, from: response.data) else {
                        return
                    }
                    print("SUCCSESS: \(json)")
                    completion()
            case .failure(let error):
                    break
            }
        }
    }
    
    func getRecommendations(genres: String, completion: @escaping () -> ()) {
        provider.request(.getRecommendations(genres: genres)) { result in
            switch result {
            case .success(let resonse):
                break
            case .failure(let error):
                break
            }
        }
    }
    
    func getRecommendedGenres(completion: @escaping ([String]) -> ()) {
        provider.request(.getRecommendedGenres) { result in
            switch result {
            case .success(let resonse):
                guard let genres = try? JSONDecoder().decode(RecommendedGenresResponse.self, from: resonse.data) else {
                    return
                }
                completion(genres.genres)
            case .failure(let error):
                break
            }
        }
    }
}
