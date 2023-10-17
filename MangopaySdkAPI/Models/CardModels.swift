////
////  File.swift
////  
////
////  Created by Elikem Savie on 02/11/2022.
////
//
//import Foundation
//import Apollo
//#if !COCOAPODS
//import ApolloAPI
//#endif
//
//public struct CardData: Cardable {
//    let number: String?
//    let name: String?
//    let expMonth: Int?
//    let expYear: Int?
//    public let cvc: String?
//    let savePayment: Bool
//    let bilingInfo: BillingInfo?
//
//    public var cardNumber: String? {
//        return number
//    }
//
//    public var cardExpirationDate: String? {
//        guard let _month = expMonth, let _year = expYear else { return nil }
//        var monthStr = String(_month)
//        monthStr = _month < 10 ? "0" + monthStr : monthStr
//        let yearStr = String(_year)
//        return [monthStr, yearStr].joined(separator: "")
//    }
//    
//    public init(number: String?, name: String?, expMonth: Int?, expYear: Int?, cvc: String?, savePayment: Bool, bilingInfo: BillingInfo?) {
//        self.number = number
//        self.name = name
//        self.expMonth = expMonth
//        self.expYear = expYear
//        self.cvc = cvc
//        self.savePayment = savePayment
//        self.bilingInfo = bilingInfo
//    }
//    
//    public func toPaymentCardInput() -> CheckoutSchema.PaymentCardInput {
//        
//        let billing = bilingInfo != nil ? GraphQLNullable<CheckoutSchema.BillingAddressInput>(bilingInfo!.toBillingAddressInput()) : nil
//        
//        let card = CheckoutSchema.PaymentCardInput(
//            number: number ?? "",
//            expMonth: expMonth ?? 0,
//            expYear: expYear ?? 0,
//            cvc: (cvc ?? "").toGraphQLNullable(),
//            name: (name ?? "").toGraphQLNullable(),
//            billingAddress: billing,
//            isDefault: true
//        )
//        
//        return card
//    }
//
//    public func toPaymentCardInfo() -> MGPCardInfo {
//        
//        let monStr = (expMonth ?? 0) < 10 ? ("0" + String(expMonth ?? 0)) : String(expMonth ?? 0)
//        let expStr = monStr + String(expYear ?? 0).suffix(2)
//        
//        return MGPCardInfo(
//            cardNumber: number,
//            cardExpirationDate: expStr,
//            cardCvx: cvc,
//            cardType: "CB_VISA_MASTERCARD"
//        )
//        
//    }
//    
//    func toCardDtoInput() -> CheckoutSchema.CardDtoInput {
//        let _cvc = self.cvc ?? ""
//        let billing = bilingInfo != nil ? GraphQLNullable<CheckoutSchema.AddressDtoInput>(bilingInfo!.toAddressDtoInput()) : nil
//        
//        let card = CheckoutSchema.CardDtoInput(
//            number: number ?? "",
//            expMonth: expMonth ?? 0,
//            expYear: expYear ?? 0,
//            cvc: (cvc ?? "").toGraphQLNullable(),
//            name: (name ?? "").toGraphQLNullable(),
//            address: billing
//        )
//        
//        return card
//    }
//}
//
//
//public struct BillingInfo {
//    //        var __data: ApolloAPI.InputDict
//    
//    let line1: String?
//    let line2: String?
//    let city: String?
//    let postalCode: String?
//    let state: String?
//    let country: String?
//    
//    public init(line1: String?, line2: String?, city: String?, postalCode: String?, state: String?, country: String?) {
//        self.line1 = line1
//        self.line2 = line2
//        self.city = city
//        self.postalCode = postalCode
//        self.state = state
//        self.country = country
//    }
//    
//    func toBillingAddressInput() -> CheckoutSchema.BillingAddressInput {
//        return CheckoutSchema.BillingAddressInput(
//            line1: line1?.toGraphQLNullable() ?? nil,
//            line2: line2?.toGraphQLNullable() ?? nil,
//            city: city?.toGraphQLNullable() ?? nil,
//            postalCode: postalCode?.toGraphQLNullable() ?? nil,
//            state: state?.toGraphQLNullable() ?? nil,
//            country: country?.toGraphQLNullable() ?? nil
//        )
//    }
//    
//    func toAddressDtoInput() -> CheckoutSchema.AddressDtoInput {
//        return CheckoutSchema.AddressDtoInput(
//            line1: line1?.toGraphQLNullable() ?? nil,
//            line2: line2?.toGraphQLNullable() ?? nil,
//            city: city?.toGraphQLNullable() ?? nil,
//            postalCode: postalCode?.toGraphQLNullable() ?? nil,
//            state: state?.toGraphQLNullable() ?? nil,
//            country: country?.toGraphQLNullable() ?? nil
//        )
//    }
//}
//
//public struct PaymentDtoInput {
//    var type: CheckoutSchema.PaymentMethodEnum
//    var token: String?
//    var walletToken: String?
//    var card: CardData?
//    var googlePayId: String?
//    
//    public init(type: CheckoutSchema.PaymentMethodEnum, token: String? = nil, walletToken: String? = nil, card: CardData? = nil, googlePayId: String? = nil) {
//        self.type = type
//        self.token = token
//        self.walletToken = walletToken
//        self.card = card
//        self.googlePayId = googlePayId
//    }
//    
//    func toPaymentDtoInput() -> CheckoutSchema.PaymentMethodDtoInput {
//        let card = card != nil ? GraphQLNullable<CheckoutSchema.CardDtoInput>(card!.toCardDtoInput()) : nil
//        let googlePay = googlePayId != nil ? GraphQLNullable<CheckoutSchema.GooglePayInput>(CheckoutSchema.GooglePayInput(transactionId: googlePayId!)) : nil
//        
//        return CheckoutSchema.PaymentMethodDtoInput(
//            type: type.rawValue,
//            token: token?.toGraphQLNullable() ?? nil,
//            walletToken: walletToken?.toGraphQLNullable() ?? nil,
//            card: card,
//            googlePay: googlePay
//        )
//    }
//}
//
//public struct AuthorisedPayment {
//    var orderId: String?
//    var flowId: String?
//    var intentId: String?
//    var _3DSRedirect: String?
//    var amount: String?
//    var currencyCode: String?
//    var paymentMethod: PaymentDtoInput
//    var description: String?
//    var headlessMode: Bool = false
//    var perform3DSecure: _3DSecure?
//    
//    public struct _3DSecure {
//        var redirectUrl: String?
//        
//        public init(redirectUrl: String? = nil) {
//            self.redirectUrl = redirectUrl
//        }
//        
//        var toThreeDSecureDtoInput: CheckoutSchema.ThreeDSecureDtoInput {
//            return CheckoutSchema.ThreeDSecureDtoInput(redirectUrl: (redirectUrl ?? "").toGraphQLNullable())
//        }
//    }
//    
//    public init(orderId: String? = nil, flowId: String? = nil, intentId: String? = nil, _3DSRedirect: String? = nil, amount: String? = nil, currencyCode: String? = nil, paymentMethod: PaymentDtoInput, description: String? = nil, headlessMode: Bool = false, perform3DSecure: _3DSecure? = nil) {
//        self.orderId = orderId
//        self.flowId = flowId
//        self.intentId = intentId
//        self._3DSRedirect = _3DSRedirect
//        self.amount = amount
//        self.currencyCode = currencyCode
//        self.paymentMethod = paymentMethod
//        self.description = description
//        self.headlessMode = headlessMode
//        self.perform3DSecure = perform3DSecure
//    }
//    
//    
//    //    struct PaymentMethod {
//    //        var type: String?
//    //        var token: String?
//    //        var walletToken: String?
//    //        var card: PaymentCardInput?
//    //        var googlePay: GooglePayInput?
//    //    }
//    
//    func toAuthorisedPaymentInput() -> CheckoutSchema.AuthorisedPaymentInput {
//        
//        let paymentMethod = paymentMethod.toPaymentDtoInput()
//        let headlessMode = GraphQLNullable<Bool>(booleanLiteral: headlessMode)
//        let threeDS = perform3DSecure != nil ? GraphQLNullable<CheckoutSchema.ThreeDSecureDtoInput>(perform3DSecure!.toThreeDSecureDtoInput) : nil
//        
//        let input = CheckoutSchema.AuthorisedPaymentInput(
//            orderId: (orderId ?? "").toGraphQLNullable(),
//            flowId: (flowId ?? "").toGraphQLNullable(),
//            intentId: (intentId ?? "").toGraphQLNullable(),
//            currencyCode: (currencyCode ?? "").toGraphQLNullable(),
//            amount: (amount ?? "").toGraphQLNullable(),
//            paymentMethod: paymentMethod,
//            description: (description ?? "").toGraphQLNullable(),
//            perform3DSecure: threeDS,
//            headlessMode: headlessMode
//        )
//        
//        return input
//    }
//}
//
//public struct ShippingAddress {
//    var address: BillingInfo?
//    var name: String?
//    var phone: String?
//    
//    var asDTO: CheckoutSchema.ShippingAddressInput {
//        let billing = address != nil ? GraphQLNullable<CheckoutSchema.BillingAddressInput>(address!.toBillingAddressInput()) : nil
//        
//        return CheckoutSchema.ShippingAddressInput(
//            address: billing,
//            name: name?.toGraphQLNullable() ?? nil,
//            phone: phone?.toGraphQLNullable() ?? nil
//        )
//    }
//    
//    public init(address: BillingInfo? = nil, name: String? = nil, phone: String? = nil) {
//        self.address = address
//        self.name = name
//        self.phone = phone
//    }
//}
//
//public struct Company {
//    var name: String?
//    var number: String?
//    var taxId: String?
//    var vatId: String?
//    
//    public init(name: String? = nil, number: String? = nil, taxId: String? = nil, vatId: String? = nil) {
//        self.name = name
//        self.number = number
//        self.taxId = taxId
//        self.vatId = vatId
//    }
//    
//    func toCompanyInput() -> CheckoutSchema.CompanyInput {
//        return CheckoutSchema.CompanyInput(
//            name: name?.toGraphQLNullable() ?? nil,
//            number: number?.toGraphQLNullable() ?? nil,
//            taxId: taxId?.toGraphQLNullable() ?? nil,
//            vatId: vatId?.toGraphQLNullable() ?? nil
//        )
//    }
//}
//
//public struct CustomerInputData {
//    var card: CardData?
//    var customer: Customer
//    
//    var toDTO: CheckoutSchema.CustomerInput {
//        let card = card != nil ? GraphQLNullable<CheckoutSchema.PaymentCardInput>(card!.toPaymentCardInput()) : nil
//        
//        return CheckoutSchema.CustomerInput(
//            card: card,
//            customer: customer.toDTO
//        )
//    }
//    
//    public init(card: CardData? = nil, customer: Customer) {
//        self.card = card
//        self.customer = customer
//    }
//}
//
//public struct Customer {
//    var id: String?
//    var billingAddress: BillingInfo?
//    var description: String?
//    var email: String?
//    var name: String?
//    var phone: String?
//    var shippingAddress: ShippingAddress?
//    var company: Company?
//    
//    var toDTO: CheckoutSchema.VaultCustomerInput {
//        let billing = billingAddress != nil ? GraphQLNullable<CheckoutSchema.BillingAddressInput>(billingAddress!.toBillingAddressInput()) : nil
//        
//        let company = company != nil ? GraphQLNullable<CheckoutSchema.CompanyInput>(company!.toCompanyInput()) : nil
//        
//        let shippingAddress = shippingAddress != nil ? GraphQLNullable<CheckoutSchema.ShippingAddressInput>(shippingAddress!.asDTO) : nil
//        
//        return CheckoutSchema.VaultCustomerInput(
//            id: id?.toGraphQLNullable() ?? nil,
//            billingAddress: billing,
//            description: description?.toGraphQLNullable() ?? nil,
//            email: email?.toGraphQLNullable() ?? nil,
//            name: name?.toGraphQLNullable() ?? nil,
//            phone: phone?.toGraphQLNullable() ?? nil,
//            shippingAddress: shippingAddress,
//            company: company
//        )
//    }
//    
//    public init(id: String? = nil, billingAddress: BillingInfo? = nil, description: String? = nil, email: String? = nil, name: String? = nil, phone: String? = nil, shippingAddress: ShippingAddress? = nil, company: Company? = nil) {
//        self.id = id
//        self.billingAddress = billingAddress
//        self.description = description
//        self.email = email
//        self.name = name
//        self.phone = phone
//        self.shippingAddress = shippingAddress
//        self.company = company
//    }
//    
//}
//
//
//public struct MGPCustomerIntentInput {
//    var id: String?
//    var email: String?
//    var name: String?
//    var isGuest: Bool?
//    
//    public var toDTO: CheckoutSchema.IntentCustomerInput {
//        return CheckoutSchema.IntentCustomerInput(
//            id: id?.toGraphQLNullable() ?? nil,
//            email: email?.toGraphQLNullable() ?? nil,
//            name: name?.toGraphQLNullable() ?? nil,
//            isGuest: GraphQLNullable<Bool>(booleanLiteral: (isGuest ?? false)!)
//        )
//    }
//    
//    public init(id: String? = nil, email: String? = nil, name: String? = nil, isGuest: Bool? = nil) {
//        self.id = id
//        self.email = email
//        self.name = name
//        self.isGuest = isGuest
//    }
//}
//
//public struct MGPIntentAmountInput {
//    var amount: Int?
//    var currency: String?
//    
//    public var toDTO: IntentAmountInput {
//        let _amount = amount != nil ? GraphQLNullable<Int>(integerLiteral: amount!) : nil
//        
//        return IntentAmountInput(
//            amount: _amount,
//            currency: currency?.toGraphQLNullable() ?? .none
//        )
//    }
//    
//    public init(amount: Int? = nil, currency: String? = nil) {
//        self.amount = amount
//        self.currency = currency
//    }
//}
//
//public struct MGPIntentLocationInput {
//    var country: String?
//    
//    public var toDTO: IntentLocationInput {
//        return IntentLocationInput(country: country?.toGraphQLNullable() ?? nil)
//    }
//    
//    public init(country: String? = nil) {
//        self.country = country
//    }
//}
//
//public struct MGPIntentCartInput {
//    var id: String?
//    var weight: Int?
//    var itemCount: Int?
//    var items: [MGPIntentCartItem]?
//    
//    var dto: IntentCartInput {
//        var __items: [CheckoutSchema.IntentCartItem]?
//        if let _items = items?.map({$0.toDTO}) {
//            __items = _items
//        } else {
//            __items = .none
//        }
//        
//        return IntentCartInput(
//            id: id?.toGraphQLNullable() ?? nil,
//            weight: weight?.toGraphQLNullable() ?? nil,
//            itemCount: itemCount?.toGraphQLNullable() ?? nil,
//            items: __items == .none ? .none : .some(__items!)
//        )
//    }
//    
//    init(id: String? = nil, weight: Int? = nil, itemCount: Int? = nil, items: [MGPIntentCartItem]? = nil) {
//        self.id = id
//        self.weight = weight
//        self.itemCount = itemCount
//        self.items = items
//    }
//}
//
//public struct MGPIntentCartItem {
//    
//    var id: String?
//    var quantity: Int?
//    var title: String?
//    var variantTitle: String?
//    var weight: Int?
//    var taxable: Bool?
//    var requiresShipping: Bool?
//    var price: String?
//    var sku: String
//    var lineTotal: String?
//    var image: String?
//    var discountedPrice: String?
//    var totalDiscount: String?
//    
//    init(id: String? = nil, quantity: Int? = nil, title: String? = nil, variantTitle: String? = nil, weight: Int? = nil, taxable: Bool? = nil, requiresShipping: Bool? = nil, price: String? = nil, sku: String, lineTotal: String? = nil, image: String? = nil, discountedPrice: String? = nil, totalDiscount: String? = nil) {
//        self.id = id
//        self.quantity = quantity
//        self.title = title
//        self.variantTitle = variantTitle
//        self.weight = weight
//        self.taxable = taxable
//        self.requiresShipping = requiresShipping
//        self.price = price
//        self.sku = sku
//        self.lineTotal = lineTotal
//        self.image = image
//        self.discountedPrice = discountedPrice
//        self.totalDiscount = totalDiscount
//    }
//    
//    var toDTO: CheckoutSchema.IntentCartItem {
//        let items =  CheckoutSchema.IntentCartItem(
//            id: id?.toGraphQLNullable() ?? nil,
//            quantity: quantity?.toGraphQLNullable() ?? nil,
//            title: title?.toGraphQLNullable() ?? nil,
//            variantTitle: variantTitle?.toGraphQLNullable() ?? nil,
//            weight: weight?.toGraphQLNullable() ?? nil,
//            taxable: taxable?.toGraphQLNullable() ?? nil,
//            requiresShipping: requiresShipping?.toGraphQLNullable() ?? nil,
//            price: price?.toGraphQLNullable() ?? nil,
//            sku: sku,
//            lineTotal: lineTotal?.toGraphQLNullable() ?? nil,
//            image: image?.toGraphQLNullable() ?? nil,
//            discountedPrice: discountedPrice?.toGraphQLNullable() ?? nil,
//            totalDiscount: totalDiscount?.toGraphQLNullable() ?? nil
//        )
//        return items
//    }
//}
//
//public struct MGPShippingDeliveryInput {
//    var status: CheckoutSchema.FormStepStatus?
//    
//    public init(status: CheckoutSchema.FormStepStatus? = nil) {
//        self.status = status
//    }
//    
//    public var toShippingDTO: IntentShippingInput {
//        return IntentShippingInput(status: status == nil ? .none : .some(.case(status!)))
//    }
//    
//    public var toDeliveryDTO: IntentDeliveryInput {
//        return IntentDeliveryInput(status: status == nil ? .none : .some(.case(status!)))
//    }
//}
