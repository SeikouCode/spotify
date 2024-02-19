//
//  AuthManager.swift
//  Spotify
//
//  Created by Aneli  on 17.02.2024.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientId = "773dcf457e944a6599986eb21c7b4f7a"
        static let clientSecret = "e87b3070700f4557a82a9962afa2eb7b"
    }
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectUri = "https://open.spotify.com/"
        let string = "\(baseURL)?response_type=code&client_id=\(Constants.clientId)&scope=\(scopes)&redirect_uri=\(redirectUri)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private init() {}
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    private func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        //get token
    }
    
    private func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
}
