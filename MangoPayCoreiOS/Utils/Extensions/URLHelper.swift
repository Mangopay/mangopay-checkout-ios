//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/11/2022.
//

import Foundation


protocol URLHelping {

    func urlsMatch(redirectUrl: URL, matchingUrl: URL) -> Bool
    func extractToken(from url: URL) -> (String?, String?)
    func extractPreAuth(from url: URL) -> String?
}

final class URLHelper: URLHelping {

    func extractToken(from url: URL) -> (String?, String?) {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return (nil, nil) }

        return (
            components.queryItems?.first { $0.name == "id" }?.value,
            components.queryItems?.first { $0.name == "3ds_status" }?.value
        )
    }

    func extractPreAuth(from url: URL) -> String? {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }

        return components.queryItems?.first { $0.name == "preAuthorizationId" }?.value
    }

    func urlsMatch(redirectUrl: URL, matchingUrl: URL) -> Bool {

        guard let redirectURLComponents = URLComponents(url: redirectUrl, resolvingAgainstBaseURL: false),
              let matchingURLComponents = URLComponents(url: matchingUrl, resolvingAgainstBaseURL: false) else {
            return false
        }

        if let matchingQueryItems = matchingURLComponents.queryItems {
            for matchingItem in matchingQueryItems {

                let queryItemIsPresent = redirectURLComponents.queryItems?.contains(where: {
                    matchingItem.name == $0.name && matchingItem.value == $0.value
                }) ?? false

                guard queryItemIsPresent else {
                    return false
                }
            }
        }

        return redirectURLComponents.scheme == matchingURLComponents.scheme
            && redirectURLComponents.host == matchingURLComponents.host
            && redirectURLComponents.path == matchingURLComponents.path
            && redirectURLComponents.fragment == matchingURLComponents.fragment
    }
}
