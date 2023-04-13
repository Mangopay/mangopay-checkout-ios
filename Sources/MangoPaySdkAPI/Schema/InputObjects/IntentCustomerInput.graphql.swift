// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct IntentCustomerInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      id: GraphQLNullable<String> = nil,
      email: GraphQLNullable<String> = nil,
      name: GraphQLNullable<String> = nil,
      isGuest: GraphQLNullable<Bool> = nil
    ) {
      __data = InputDict([
        "id": id,
        "email": email,
        "name": name,
        "isGuest": isGuest
      ])
    }

    public var id: GraphQLNullable<String> {
      get { __data["id"] }
      set { __data["id"] = newValue }
    }

    public var email: GraphQLNullable<String> {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }

    public var name: GraphQLNullable<String> {
      get { __data["name"] }
      set { __data["name"] = newValue }
    }

    public var isGuest: GraphQLNullable<Bool> {
      get { __data["isGuest"] }
      set { __data["isGuest"] = newValue }
    }
  }

}