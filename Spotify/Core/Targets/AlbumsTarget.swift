//
//  AlbumsTarget.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation
import Moya

enum AlbumsTarget {
    case getNewReleases
    case getRecommendations(genres: String)
    case getRecommendedGenres
}

extension AlbumsTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalConstants.apiBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getNewReleases:
            return "/v1/browse/new-releases"
        case .getRecommendations:
            return "/v1/recommendations"
        case .getRecommendedGenres:
            return "/v1/recommendations/available-genre-seeds"
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .getNewReleases:
            return .requestParameters(parameters: ["limit": 30,"offset": 0],
                encoding: URLEncoding.default
            )
        case .getRecommendations(let genres):
            return .requestParameters(parameters: ["seed_genres": genres],
                encoding: URLEncoding.default
            )
        case .getRecommendedGenres:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var header = [String : String]()
        AuthManager.shared.withValidToken { token in
            header["Authorization"] = "Bearer \(token)"
        }
        return header
    }
}
