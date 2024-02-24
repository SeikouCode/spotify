//
//  AuthTarget.swift
//  Spotify
//
//  Created by Aneli  on 24.02.2024.
//

import Foundation
import Moya

enum AuthTarget {
    case getAccessToken(code: String)
}

extension AuthTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://accounts.spotify.com/api")!
    }
    
    var path: String {
        return "/token"
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
                    "redirect_uri": "https://open.spotify.com/"
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        var headers = [String : String]()
        let authString = "\("773dcf457e944a6599986eb21c7b4f7a"):\("e87b3070700f4557a82a9962afa2eb7b")"
        guard let authData = authString.data(using: .utf8) else {
            print("Failure to get base64")
            return nil
        }
        let base64AuthString = authData.base64EncodedString()
        
        headers["Authorization"] = "Basic \(base64AuthString)"
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        return headers
    }
}
