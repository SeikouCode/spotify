//
//  String+Extension.swift
//  Spotify
//
//  Created by Aneli  on 13.03.2024.
//

import Foundation

extension String {
    var localized: String {
        guard let localizedBundle = Bundle.localizedBundle() else { return "" }
        return NSLocalizedString(
            self,
            bundle: localizedBundle,
            comment: "\(self) could not be found in Localizable.strings"
        )
    }
}
