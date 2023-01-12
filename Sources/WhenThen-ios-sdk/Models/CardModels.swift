//
//  File.swift
//  
//
//  Created by Elikem Savie on 02/11/2022.
//

import Foundation
import ApolloAPI
import Apollo

struct FormData {
    let number: String?
    let name: String?
    let expMonth: Int?
    let expYear: Int?
    let cvc: String?
    let savePayment: Bool
    let bilingInfo: BillingInfo?

    func toPaymentCardInput() -> CheckoutSchema.PaymentCardInput {
        
        let billing = bilingInfo == nil ? GraphQLNullable<CheckoutSchema.BillingAddressInput>(bilingInfo!.toBillingAddressInput()) : nil

        let card = CheckoutSchema.PaymentCardInput(
            number: number ?? "",
            expMonth: expMonth ?? 0,
            expYear: expYear ?? 0,
            cvc: (cvc ?? "").toGraphQLNullable(),
            name: (name ?? "").toGraphQLNullable(),
            billingAddress: billing,
            isDefault: true
        )
       
        return card
    }

    func toCardDtoInput() -> CheckoutSchema.CardDtoInput {
        let _cvc = self.cvc ?? ""
        let billing = bilingInfo != nil ? GraphQLNullable<CheckoutSchema.AddressDtoInput>(bilingInfo!.toAddressDtoInput()) : nil

        let card = CheckoutSchema.CardDtoInput(
            number: number ?? "",
            expMonth: expMonth ?? 0,
            expYear: expYear ?? 0,
            cvc: (cvc ?? "").toGraphQLNullable(),
            name: (name ?? "").toGraphQLNullable(),
            address: billing
        )
        
        return card
    }
}


struct BillingInfo {
//        var __data: ApolloAPI.InputDict
    
    let line1: String?
    let line2: String?
    let city: String?
    let postalCode: String?
    let state: String?
    let country: String?
    
    func toBillingAddressInput() -> CheckoutSchema.BillingAddressInput {
        return CheckoutSchema.BillingAddressInput(
            line1: line1?.toGraphQLNullable() ?? nil,
            line2: line2?.toGraphQLNullable() ?? nil,
            city: city?.toGraphQLNullable() ?? nil,
            postalCode: postalCode?.toGraphQLNullable() ?? nil,
            state: state?.toGraphQLNullable() ?? nil,
            country: country?.toGraphQLNullable() ?? nil
        )
    }

    func toAddressDtoInput() -> CheckoutSchema.AddressDtoInput {
        return CheckoutSchema.AddressDtoInput(
            line1: line1?.toGraphQLNullable() ?? nil,
            line2: line2?.toGraphQLNullable() ?? nil,
            city: city?.toGraphQLNullable() ?? nil,
            postalCode: postalCode?.toGraphQLNullable() ?? nil,
            state: state?.toGraphQLNullable() ?? nil,
            country: country?.toGraphQLNullable() ?? nil
        )
    }
}

struct PaymentDtoInput {
    var type: CheckoutSchema.PaymentMethodEnum
    var token: String?
    var walletToken: String?
    var card: FormData?
    var googlePayId: String?

    func toPaymentDtoInput() -> CheckoutSchema.PaymentMethodDtoInput {
        let card = card != nil ? GraphQLNullable<CheckoutSchema.CardDtoInput>(card!.toCardDtoInput()) : nil
        let googlePay = googlePayId != nil ? GraphQLNullable<CheckoutSchema.GooglePayInput>(CheckoutSchema.GooglePayInput(transactionId: googlePayId!)) : nil

        return CheckoutSchema.PaymentMethodDtoInput(
            type: type.rawValue,
            token: token?.toGraphQLNullable() ?? nil,
            walletToken: walletToken?.toGraphQLNullable() ?? nil,
            card: card,
            googlePay: googlePay
        )
    }
}

public struct AuthorisedPayment {
    var orderId: String?
    var flowId: String?
    var _3DSRedirect: String?
    var amount: String?
    var currencyCode: String?
    var paymentMethod: PaymentDtoInput
    var description: String?
    var headlessMode: Bool = false
    var perform3DSecure: _3DSecure?
    
    struct _3DSecure {
        var redirectUrl: String?
        
        var toThreeDSecureDtoInput: CheckoutSchema.ThreeDSecureDtoInput {
            return CheckoutSchema.ThreeDSecureDtoInput(redirectUrl: (redirectUrl ?? "").toGraphQLNullable())
        }
    }
    
    
//    struct PaymentMethod {
//        var type: String?
//        var token: String?
//        var walletToken: String?
//        var card: PaymentCardInput?
//        var googlePay: GooglePayInput?
//    }

    func toAuthorisedPaymentInput() -> CheckoutSchema.AuthorisedPaymentInput {

        let paymentMethod = paymentMethod.toPaymentDtoInput()
        let headlessMode = GraphQLNullable<Bool>(booleanLiteral: headlessMode)
        let threeDS = perform3DSecure != nil ? GraphQLNullable<CheckoutSchema.ThreeDSecureDtoInput>(perform3DSecure!.toThreeDSecureDtoInput) : nil

        let input = CheckoutSchema.AuthorisedPaymentInput(
            orderId: (orderId ?? "").toGraphQLNullable(),
            flowId: (flowId ?? "").toGraphQLNullable() ,
            currencyCode: (currencyCode ?? "").toGraphQLNullable(),
            amount: (amount ?? "").toGraphQLNullable(),
            paymentMethod: paymentMethod,
            description: (description ?? "").toGraphQLNullable(),
            perform3DSecure: threeDS,
            headlessMode: headlessMode
        )

        return input
    }
}

struct ShippingAddress {
    var address: BillingInfo?
    var name: String?
    var phone: String?
    
    var asDTO: CheckoutSchema.ShippingAddressInput {
        let billing = address != nil ? GraphQLNullable<CheckoutSchema.BillingAddressInput>(address!.toBillingAddressInput()) : nil
        
        return CheckoutSchema.ShippingAddressInput(
            address: billing,
            name: name?.toGraphQLNullable() ?? nil,
            phone: phone?.toGraphQLNullable() ?? nil
        )
    }
}

struct Company {
    var name: String?
    var number: String?
    var taxId: String?
    var vatId: String?
    
    func toCompanyInput() -> CheckoutSchema.CompanyInput {
        return CheckoutSchema.CompanyInput(
            name: name?.toGraphQLNullable() ?? nil,
            number: number?.toGraphQLNullable() ?? nil,
            taxId: taxId?.toGraphQLNullable() ?? nil,
            vatId: vatId?.toGraphQLNullable() ?? nil
        )
    }
}

public struct CustomerInputData {
    var card: FormData?
    var customer: Customer
    
    var toDTO: CheckoutSchema.CustomerInput {
        let card = card != nil ? GraphQLNullable<CheckoutSchema.PaymentCardInput>(card!.toPaymentCardInput()) : nil

        return CheckoutSchema.CustomerInput(
            card: card,
            customer: customer.toDTO
        )
    }
}

public struct Customer {
    var id: String?
    var billingAddress: BillingInfo?
    var description: String?
    var email: String?
    var name: String?
    var phone: String?
    var shippingAddress: ShippingAddress?
    var company: Company?

    var toDTO: CheckoutSchema.VaultCustomerInput {
        let billing = billingAddress != nil ? GraphQLNullable<CheckoutSchema.BillingAddressInput>(billingAddress!.toBillingAddressInput()) : nil

        let company = company != nil ? GraphQLNullable<CheckoutSchema.CompanyInput>(company!.toCompanyInput()) : nil
        
        let shippingAddress = shippingAddress != nil ? GraphQLNullable<CheckoutSchema.ShippingAddressInput>(shippingAddress!.asDTO) : nil

        return CheckoutSchema.VaultCustomerInput(
            id: id?.toGraphQLNullable() ?? nil,
            billingAddress: billing,
            description: description?.toGraphQLNullable() ?? nil,
            email: email?.toGraphQLNullable() ?? nil,
            name: name?.toGraphQLNullable() ?? nil,
            phone: phone?.toGraphQLNullable() ?? nil,
            shippingAddress: shippingAddress,
            company: company
        )
    }
}
