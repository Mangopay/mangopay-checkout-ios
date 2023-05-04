// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct CompanyInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      name: GraphQLNullable<String> = nil,
      number: GraphQLNullable<String> = nil,
      taxId: GraphQLNullable<String> = nil,
      vatId: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "name": name,
        "number": number,
        "taxId": taxId,
        "vatId": vatId
      ])
    }

    public var name: GraphQLNullable<String> {
      get { __data["name"] }
      set { __data["name"] = newValue }
    }

    public var number: GraphQLNullable<String> {
      get { __data["number"] }
      set { __data["number"] = newValue }
    }

    public var taxId: GraphQLNullable<String> {
      get { __data["taxId"] }
      set { __data["taxId"] = newValue }
    }

    public var vatId: GraphQLNullable<String> {
      get { __data["vatId"] }
      set { __data["vatId"] = newValue }
    }
  }

}
