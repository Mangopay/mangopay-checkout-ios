// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct IntentDeliveryInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      status: GraphQLNullable<GraphQLEnum<FormStepStatus>> = nil
    ) {
      __data = InputDict([
        "status": status
      ])
    }

    public var status: GraphQLNullable<GraphQLEnum<FormStepStatus>> {
      get { __data["status"] }
      set { __data["status"] = newValue }
    }
  }

}