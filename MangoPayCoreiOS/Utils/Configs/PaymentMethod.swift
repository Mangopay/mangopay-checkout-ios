//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation
import MangoPaySdkAPI

public enum PaymentMethod {
    case card(MGPCardInfo?)
    case applePay(MangoPayApplePay?)
}
