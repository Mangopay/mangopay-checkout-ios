// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct PaymentBankAccountInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      number: GraphQLNullable<String> = nil,
      accountHolderName: GraphQLNullable<String> = nil,
      bankName: GraphQLNullable<String> = nil,
      cardType: GraphQLNullable<GraphQLEnum<PaymentMethodCardType>> = nil,
      product: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "number": number,
        "accountHolderName": accountHolderName,
        "bankName": bankName,
        "cardType": cardType,
        "product": product
      ])
    }

    public var number: GraphQLNullable<String> {
      get { __data["number"] }
      set { __data["number"] = newValue }
    }

    public var accountHolderName: GraphQLNullable<String> {
      get { __data["accountHolderName"] }
      set { __data["accountHolderName"] = newValue }
    }

    public var bankName: GraphQLNullable<String> {
      get { __data["bankName"] }
      set { __data["bankName"] = newValue }
    }

    public var cardType: GraphQLNullable<GraphQLEnum<PaymentMethodCardType>> {
      get { __data["cardType"] }
      set { __data["cardType"] = newValue }
    }

    public var product: GraphQLNullable<String> {
      get { __data["product"] }
      set { __data["product"] = newValue }
    }
  }

}
