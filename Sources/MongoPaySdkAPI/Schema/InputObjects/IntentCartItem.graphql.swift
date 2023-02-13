// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct IntentCartItem: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      id: GraphQLNullable<String> = nil,
      quantity: GraphQLNullable<Int> = nil,
      title: GraphQLNullable<String> = nil,
      variantTitle: GraphQLNullable<String> = nil,
      weight: GraphQLNullable<Int> = nil,
      taxable: GraphQLNullable<Bool> = nil,
      requiresShipping: GraphQLNullable<Bool> = nil,
      price: GraphQLNullable<Long> = nil,
      sku: String,
      lineTotal: GraphQLNullable<Long> = nil,
      image: GraphQLNullable<String> = nil,
      discountedPrice: GraphQLNullable<Long> = nil,
      totalDiscount: GraphQLNullable<Long> = nil
    ) {
      __data = InputDict([
        "id": id,
        "quantity": quantity,
        "title": title,
        "variantTitle": variantTitle,
        "weight": weight,
        "taxable": taxable,
        "requiresShipping": requiresShipping,
        "price": price,
        "sku": sku,
        "lineTotal": lineTotal,
        "image": image,
        "discountedPrice": discountedPrice,
        "totalDiscount": totalDiscount
      ])
    }

    public var id: GraphQLNullable<String> {
      get { __data["id"] }
      set { __data["id"] = newValue }
    }

    public var quantity: GraphQLNullable<Int> {
      get { __data["quantity"] }
      set { __data["quantity"] = newValue }
    }

    public var title: GraphQLNullable<String> {
      get { __data["title"] }
      set { __data["title"] = newValue }
    }

    public var variantTitle: GraphQLNullable<String> {
      get { __data["variantTitle"] }
      set { __data["variantTitle"] = newValue }
    }

    public var weight: GraphQLNullable<Int> {
      get { __data["weight"] }
      set { __data["weight"] = newValue }
    }

    public var taxable: GraphQLNullable<Bool> {
      get { __data["taxable"] }
      set { __data["taxable"] = newValue }
    }

    public var requiresShipping: GraphQLNullable<Bool> {
      get { __data["requiresShipping"] }
      set { __data["requiresShipping"] = newValue }
    }

    public var price: GraphQLNullable<Long> {
      get { __data["price"] }
      set { __data["price"] = newValue }
    }

    public var sku: String {
      get { __data["sku"] }
      set { __data["sku"] = newValue }
    }

    public var lineTotal: GraphQLNullable<Long> {
      get { __data["lineTotal"] }
      set { __data["lineTotal"] = newValue }
    }

    public var image: GraphQLNullable<String> {
      get { __data["image"] }
      set { __data["image"] = newValue }
    }

    public var discountedPrice: GraphQLNullable<Long> {
      get { __data["discountedPrice"] }
      set { __data["discountedPrice"] = newValue }
    }

    public var totalDiscount: GraphQLNullable<Long> {
      get { __data["totalDiscount"] }
      set { __data["totalDiscount"] = newValue }
    }
  }

}