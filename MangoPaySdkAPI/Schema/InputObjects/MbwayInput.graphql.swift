// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct MbwayInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      phoneNumber: String
    ) {
      __data = InputDict([
        "phoneNumber": phoneNumber
      ])
    }

    public var phoneNumber: String {
      get { __data["phoneNumber"] }
      set { __data["phoneNumber"] = newValue }
    }
  }

}
