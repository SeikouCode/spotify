//
//  BaseTargetType.swift
//  Spotify
//
//  Created by Aneli  on 27.02.2024.
//

import Moya

protocol BaseTargetType: TargetType {
    var baseHeaders: [String: String] { get }
}

extension BaseTargetType {
    var baseURL: URL {
        return GlobalConstants.baseURL
    }
    
    var headers: [String : String]? {
        return baseHeaders
    }
}
