//
//  File.swift
//  
//
//  Created by Elikem Savie on 03/07/2023.
//

import Foundation
import MangoPaySdkAPI

public struct MangopayClient {
    let clientId: String?
    let clientToken: String?
    let apiKey: String?
    let environment: MGPEnvironment

    public init(clientId: String?, clientToken: String? = nil, apiKey: String?, environment: MGPEnvironment) {
        self.clientId = clientId
        self.environment = environment
        self.clientToken = clientToken
        self.apiKey = apiKey
    }
}
