//
//  File.swift
//  
//
//  Created by Elikem Savie on 24/02/2023.
//

import Foundation

//public enum Environment {
//    enum Keys {
//        enum Plist {
//            static let serverBaseUrl = "SERVER_BASE_URL"
//        }
//    }
//
//    enum Types: String {
//        case dev
//        case staging
//        case prod
//        case beta
//    }
//
//    private static let infoDictionary: [String: Any] = {
//        guard let dict = Bundle.main.infoDictionary else {
//            fatalError("Plist file not found")
//        }
//        return dict
//    }()
//
//    static let baseUrl: URL = {
//        guard let serverBaseURLstring = Environment.infoDictionary[Keys.Plist.serverBaseUrl] as? String else {
//            fatalError("SERVER_BASE_URL not set in plist for this environment")
//        }
//        guard let url = URL(string: serverBaseURLstring) else {
//            fatalError("SERVER_BASE_URL is invalid")
//        }
//        return url
//    }()
//
//
//}
