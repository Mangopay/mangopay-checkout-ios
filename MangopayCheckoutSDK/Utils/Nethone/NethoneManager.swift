//
//  File.swift
//  
//
//  Created by Elikem Savie on 06/02/2024.
//

import Foundation
import NethoneSDK

final class NethoneManager {
    
    enum MGPNethoneState {
        case unitiated
        case initiated
    }

    enum MGPNethoneResult {
        case success
        case timeout
        case error
    }

    static let shared = NethoneManager()
    private var state: MGPNethoneState = .unitiated
    private var nethoneResult: MGPNethoneResult?

    private let TIMEOUT_THRESHOLD: TimeInterval = 7

    private init() {}

    func initialize(with merchantNumber: String) {
        guard state != .initiated else {
            print("Nethone already initialized")
            return
        }
        NTHNethone.setMerchantNumber(merchantNumber)
        self.state = .initiated
    }

    private func finalizeAttempt(onComplete: ((Error?) -> Void)? = nil) {
        do {
            try NTHNethone.finalizeAttempt { res in
                onComplete?(res)
            }
        } catch {
            onComplete?(error)
        }
    }

    func performFinalizeAttempt(onReturnResult: ((MGPNethoneResult) -> ())? = nil) {
        let timerScheduled = Timer.scheduledTimer(withTimeInterval: TIMEOUT_THRESHOLD, repeats: false) { timer in
            timer.invalidate()
            if self.nethoneResult != .success {
                self.nethoneResult = .timeout
                onReturnResult?(self.nethoneResult ?? .timeout)
            }
            self.nethoneResult = .timeout
        }
        
        finalizeAttempt { hasComplete in
            timerScheduled.invalidate()
            guard self.nethoneResult != .timeout else { return }
            self.nethoneResult = .success
            onReturnResult?(self.nethoneResult ?? .success)
        }
    }
    
    func cancelNethoneAttemptIfAny() {
        do {
            try NethoneSDK.NTHNethone.cancelAttempt()
            print("CancelAttempt success")
        } catch {
            print("Nethone cancelAttempt Error", error.localizedDescription)
        }
    }

}


