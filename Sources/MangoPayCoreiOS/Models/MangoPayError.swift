//
//  File.swift
//  
//
//  Created by Elikem Savie on 18/11/2022.
//

import Foundation

public enum MangoPayError: Error {
    case onTokenGenerationFailed(reason: String?)
    case onAuthorizePaymentFailed(reason: String?)
}
