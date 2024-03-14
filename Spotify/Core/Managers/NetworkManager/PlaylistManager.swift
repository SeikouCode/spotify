//
//  PlaylistManager.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation
import Moya

final class PlaylistManager {
    static let shared = PlaylistManager()
    
    private let provider = MoyaProvider<HomeTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        provider.request(.getFeaturedPlaylists) { result in
            switch result {
                case .success(let response):
                    do {
                        let json = try response.map(FeaturedPlaylistsResponse.self)
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
