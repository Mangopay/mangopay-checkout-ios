// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct VaultCustomerInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<String> = nil,
    billingAddress: GraphQLNullable<SchemaPackage.BillingAddressInput> = nil,
    description: GraphQLNullable<String> = nil,
    email: GraphQLNullable<String> = nil,
    name: GraphQLNullable<String> = nil,
    phone: GraphQLNullable<String> = nil,
    shippingAddress: GraphQLNullable<SchemaPackage.ShippingAddressInput> = nil,
    company: GraphQLNullable<SchemaPackage.CompanyInput> = nil
  ) {
    __data = InputDict([
      "id": id,
      "billingAddress": billingAddress,
      "description": description,
      "email": email,
      "name": name,
      "phone": phone,
      "shippingAddress": shippingAddress,
      "company": company
    ])
  }

  public var id: GraphQLNullable<String> {
    get { __data.id }
    set { __data.id = newValue }
  }

  public var billingAddress: GraphQLNullable<SchemaPackage.BillingAddressInput> {
    get { __data.billingAddress }
    set { __data.billingAddress = newValue }
  }

  public var description: GraphQLNullable<String> {
    get { __data.description }
    set { __data.description = newValue }
  }

  public var email: GraphQLNullable<String> {
    get { __data.email }
    set { __data.email = newValue }
  }

  public var name: GraphQLNullable<String> {
    get { __data.name }
    set { __data.name = newValue }
  }

  public var phone: GraphQLNullable<String> {
    get { __data.phone }
    set { __data.phone = newValue }
  }

  public var shippingAddress: GraphQLNullable<SchemaPackage.ShippingAddressInput> {
    get { __data.shippingAddress }
    set { __data.shippingAddress = newValue }
  }

  public var company: GraphQLNullable<SchemaPackage.CompanyInput> {
    get { __data.company }
    set { __data.company = newValue }
  }
}
