// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct GooglePayInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      transactionId: String
    ) {
      __data = InputDict([
        "transactionId": transactionId
      ])
    }

    public var transactionId: String {
      get { __data["transactionId"] }
      set { __data["transactionId"] = newValue }
    }
  }

}
