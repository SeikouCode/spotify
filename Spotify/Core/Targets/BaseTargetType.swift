//
//  BaseTargetType.swift
//  Spotify
//
//  Created by Aneli  on 27.02.2024.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType {
    var baseAPIURL: URL { get }
    var baseHeaders: [String: String] { get }
}

extension BaseTargetType {
    var baseURL: URL {
        return baseAPIURL
    }
    
    var headers: [String : String]? {
        return baseHeaders
    }
}
