//
//  AuthManager.swift
//  Spotify
//
//  Created by Aneli  on 17.02.2024.
//

import Foundation
import Moya

final class AuthManager {
    static let shared = AuthManager()
    
    private let provider = MoyaProvider<AuthTarget>()
    
    struct Constants {
        static let clientId = "773dcf457e944a6599986eb21c7b4f7a"
        static let clientSecret = "e87b3070700f4557a82a9962afa2eb7b"
        static let scopes = "user-read-private"
        static let redirectUri = "https://open.spotify.com/"
    }
    
    public var signInURL: URL? {
        
        let baseURL = "https://accounts.spotify.com/authorize"
        
        var components = URLComponents(string: baseURL)
        
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.clientId),
            URLQueryItem(name: "scope", value: Constants.scopes),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "show_dialog", value: "TRUE"),
        ]
        
        return components?.url
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private init() {}
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= tokenExpirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        provider.request(.getAccessToken(code: code)) { [weak self] result in
            switch result {
            case .success(let response):
                guard let result = try? response.map(AuthResponse.self) else {
                    completion(false)
                    return
                }
                self?.cacheToken(result: result)
                completion(true)
                
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    private func refreshIfNeeded() {
        
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.accessToken, forKey: "accessToken")
        
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refreshToken")
        }
        
        UserDefaults.standard.setValue(
            Date().addingTimeInterval(TimeInterval(result.expiresIn)),
            forKey: "expirationDate"
        )
    }
}
