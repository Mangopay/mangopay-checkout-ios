// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct PaymentMethodCustomerDtoInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      id: GraphQLNullable<String> = nil,
      email: GraphQLNullable<String> = nil,
      name: GraphQLNullable<String> = nil,
      description: GraphQLNullable<String> = nil,
      phone: GraphQLNullable<String> = nil,
      billingAddress: GraphQLNullable<BillingAddressInput> = nil,
      shippingAddress: GraphQLNullable<ShippingAddressInput> = nil,
      company: GraphQLNullable<CompanyInput> = nil
    ) {
      __data = InputDict([
        "id": id,
        "email": email,
        "name": name,
        "description": description,
        "phone": phone,
        "billingAddress": billingAddress,
        "shippingAddress": shippingAddress,
        "company": company
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

    public var description: GraphQLNullable<String> {
      get { __data["description"] }
      set { __data["description"] = newValue }
    }

    public var phone: GraphQLNullable<String> {
      get { __data["phone"] }
      set { __data["phone"] = newValue }
    }

    public var billingAddress: GraphQLNullable<BillingAddressInput> {
      get { __data["billingAddress"] }
      set { __data["billingAddress"] = newValue }
    }

    public var shippingAddress: GraphQLNullable<ShippingAddressInput> {
      get { __data["shippingAddress"] }
      set { __data["shippingAddress"] = newValue }
    }

    public var company: GraphQLNullable<CompanyInput> {
      get { __data["company"] }
      set { __data["company"] = newValue }
    }
  }

}
