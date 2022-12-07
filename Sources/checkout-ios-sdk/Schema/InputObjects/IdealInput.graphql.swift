// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct IdealInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      bank: String
    ) {
      __data = InputDict([
        "bank": bank
      ])
    }

    public var bank: String {
      get { __data["bank"] }
      set { __data["bank"] = newValue }
    }
  }

}