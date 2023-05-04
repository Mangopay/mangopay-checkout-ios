// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct PaymentMethodDtoInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      type: String,
      token: GraphQLNullable<String> = nil,
      walletToken: GraphQLNullable<String> = nil,
      card: GraphQLNullable<CardDtoInput> = nil,
      googlePay: GraphQLNullable<GooglePayInput> = nil,
      ideal: GraphQLNullable<IdealInput> = nil,
      mbway: GraphQLNullable<MbwayInput> = nil
    ) {
      __data = InputDict([
        "type": type,
        "token": token,
        "walletToken": walletToken,
        "card": card,
        "googlePay": googlePay,
        "ideal": ideal,
        "mbway": mbway
      ])
    }

    public var type: String {
      get { __data["type"] }
      set { __data["type"] = newValue }
    }

    public var token: GraphQLNullable<String> {
      get { __data["token"] }
      set { __data["token"] = newValue }
    }

    public var walletToken: GraphQLNullable<String> {
      get { __data["walletToken"] }
      set { __data["walletToken"] = newValue }
    }

    public var card: GraphQLNullable<CardDtoInput> {
      get { __data["card"] }
      set { __data["card"] = newValue }
    }

    public var googlePay: GraphQLNullable<GooglePayInput> {
      get { __data["googlePay"] }
      set { __data["googlePay"] = newValue }
    }

    public var ideal: GraphQLNullable<IdealInput> {
      get { __data["ideal"] }
      set { __data["ideal"] = newValue }
    }

    public var mbway: GraphQLNullable<MbwayInput> {
      get { __data["mbway"] }
      set { __data["mbway"] = newValue }
    }
  }

}
