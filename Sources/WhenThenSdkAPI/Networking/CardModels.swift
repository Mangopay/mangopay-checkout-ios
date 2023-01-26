//
//  File.swift
//  
//
//  Created by Elikem Savie on 02/11/2022.
//

import Foundation
import ApolloAPI
import Apollo

public struct FormData {
    let number: String?
    let name: String?
    let expMonth: Int?
    let expYear: Int?
    let cvc: String?
    let savePayment: Bool
    let bilingInfo: BillingInfo?

    public init(number: String?, name: String?, expMonth: Int?, expYear: Int?, cvc: String?, savePayment: Bool, bilingInfo: BillingInfo?) {
        self.number = number
        self.name = name
        self.expMonth = expMonth
        self.expYear = expYear
        self.cvc = cvc
        self.savePayment = savePayment
        self.bilingInfo = bilingInfo
    }

    public func toPaymentCardInput() -> CheckoutSchema.PaymentCardInput {
        
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


public struct BillingInfo {
//        var __data: ApolloAPI.InputDict
    
    let line1: String?
    let line2: String?
    let city: String?
    let postalCode: String?
    let state: String?
    let country: String?

    public init(line1: String?, line2: String?, city: String?, postalCode: String?, state: String?, country: String?) {
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.postalCode = postalCode
        self.state = state
        self.country = country
    }
    
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

public struct PaymentDtoInput {
    var type: CheckoutSchema.PaymentMethodEnum
    var token: String?
    var walletToken: String?
    var card: FormData?
    var googlePayId: String?

    public init(type: CheckoutSchema.PaymentMethodEnum, token: String? = nil, walletToken: String? = nil, card: FormData? = nil, googlePayId: String? = nil) {
        self.type = type
        self.token = token
        self.walletToken = walletToken
        self.card = card
        self.googlePayId = googlePayId
    }

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
    
    public struct _3DSecure {
        var redirectUrl: String?
        
        public init(redirectUrl: String? = nil) {
            self.redirectUrl = redirectUrl
        }
        
        var toThreeDSecureDtoInput: CheckoutSchema.ThreeDSecureDtoInput {
            return CheckoutSchema.ThreeDSecureDtoInput(redirectUrl: (redirectUrl ?? "").toGraphQLNullable())
        }
    }

    public init(orderId: String? = nil, flowId: String? = nil, _3DSRedirect: String? = nil, amount: String? = nil, currencyCode: String? = nil, paymentMethod: PaymentDtoInput, description: String? = nil, headlessMode: Bool = false, perform3DSecure: _3DSecure? = nil) {
        self.orderId = orderId
        self.flowId = flowId
        self._3DSRedirect = _3DSRedirect
        self.amount = amount
        self.currencyCode = currencyCode
        self.paymentMethod = paymentMethod
        self.description = description
        self.headlessMode = headlessMode
        self.perform3DSecure = perform3DSecure
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

public struct ShippingAddress {
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

    public init(address: BillingInfo? = nil, name: String? = nil, phone: String? = nil) {
        self.address = address
        self.name = name
        self.phone = phone
    }
}

public struct Company {
    var name: String?
    var number: String?
    var taxId: String?
    var vatId: String?
    
    public init(name: String? = nil, number: String? = nil, taxId: String? = nil, vatId: String? = nil) {
        self.name = name
        self.number = number
        self.taxId = taxId
        self.vatId = vatId
    }

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

    public init(card: FormData? = nil, customer: Customer) {
        self.card = card
        self.customer = customer
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

    public init(id: String? = nil, billingAddress: BillingInfo? = nil, description: String? = nil, email: String? = nil, name: String? = nil, phone: String? = nil, shippingAddress: ShippingAddress? = nil, company: Company? = nil) {
        self.id = id
        self.billingAddress = billingAddress
        self.description = description
        self.email = email
        self.name = name
        self.phone = phone
        self.shippingAddress = shippingAddress
        self.company = company
    }
}
