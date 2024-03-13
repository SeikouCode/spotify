//
//  String+Extension.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "\(self) could not be found is Localizable.strings")
    }
}
