//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation

extension Date {

    public init?(_ string: String, format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }

    func string(format: String = "d MMMM yyyy", shouldUseSuffix: Bool = false, timeZone: TimeZone? = nil) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        if let tz = timeZone {
            dateFormatter.timeZone = tz
        }
        return dateFormatter.string(from: self)
    }
    
}
