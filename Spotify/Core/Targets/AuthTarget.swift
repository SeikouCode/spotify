//
//  AuthTarget.swift
//  Spotify
//
//  Created by Aneli  on 24.02.2024.
//

import Foundation
import Moya

enum AuthTarget: BaseTargetType {
    var baseAPIURL: URL {
        
        return URL(string: GlobalConstants.baseURL + "/api")!
    }
    
    var baseHeaders: [String : String] {
        
        var headers = [String : String]()
        let authString = "\(GlobalConstants.AuthAPI.clientId):\(GlobalConstants.AuthAPI.clientSecret)"
        guard let authData = authString.data(using: .utf8) else {
            print("Failure to get base64")
            return [:]
        }
        let base64AuthString = authData.base64EncodedString()
        
        headers["Authorization"] = "Basic \(base64AuthString)"
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        return headers
    }
    
    case getAccessToken(code: String)
    case refreshToken(parameters: [String: Any])
    
    var path: String {
        switch self {
            case .getAccessToken:
                return "/token"
            case .refreshToken:
                return "/token"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
            case .getAccessToken(let code):
                return .requestParameters(
                    parameters: [
                        "grant_type": "authorization_code",
                        "code": code,
                        "redirect_uri": GlobalConstants.AuthAPI.redirectUri
                    ],
                    encoding: URLEncoding.default
                )
            case .refreshToken(let parameters):
                return .requestParameters(
                    parameters: parameters,
                    encoding: URLEncoding.default
            )
        }
    }
}
