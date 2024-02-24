//
//  AuthManager.swift
//  Spotify
//
//  Created by Aneli  on 17.02.2024.
//

import Foundation
import Moya
import KeychainSwift

final class AuthManager {
    static let shared = AuthManager()
    
    private let provider = MoyaProvider<AuthTarget>()
    private let keychain = KeychainSwift()
    
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
        get {
            return keychain.get("accessToken")
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: "accessToken")
            } else {
                keychain.delete("accessToken")
            }
        }
    }
    
    private var refreshToken: String? {
        get {
            return keychain.get("refreshToken")
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: "refreshToken")
            } else {
                keychain.delete("refreshToken")
            }
        }
    }
    
    private var tokenExpirationDate: Date? {
        get {
            if let dateString = keychain.get("expirationDate"), let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            }
            return nil
        }
        set {
            if let newValue = newValue {
                keychain.set(ISO8601DateFormatter().string(from: newValue), forKey: "expirationDate")
            } else {
                keychain.delete("expirationDate")
            }
        }
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else { return false }
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
        if shouldRefreshToken {
            guard let refreshToken = refreshToken else { return }
            
            let baseURL = "https://accounts.spotify.com/api/token"
            let parameters: [String: Any] = [
                "grant_type": "refresh_token",
                "refresh_token": refreshToken,
                "client_id": Constants.clientId
            ]
            
            provider.request(.refreshToken(parameters: parameters)) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let result = try? response.map(AuthResponse.self) else {
                        // Handle error
                        return
                    }
                    self?.cacheToken(result: result)
                    
                case .failure(let error):
                    print("Token refresh failed: \(error)")
                }
            }
        }
    }

    
    private func cacheToken(result: AuthResponse) {
        accessToken = result.accessToken
        
        if let refreshToken = result.refreshToken {
            self.refreshToken = refreshToken
        }
        
        tokenExpirationDate = Date().addingTimeInterval(TimeInterval(result.expiresIn))
    }
}
