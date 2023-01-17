// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol CheckoutSchema_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == CheckoutSchema.SchemaMetadata {}

public protocol CheckoutSchema_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == CheckoutSchema.SchemaMetadata {}

public protocol CheckoutSchema_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == CheckoutSchema.SchemaMetadata {}

public protocol CheckoutSchema_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == CheckoutSchema.SchemaMetadata {}

public extension CheckoutSchema {
  typealias ID = String

  typealias SelectionSet = CheckoutSchema_SelectionSet

  typealias InlineFragment = CheckoutSchema_InlineFragment

  typealias MutableSelectionSet = CheckoutSchema_MutableSelectionSet

  typealias MutableInlineFragment = CheckoutSchema_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "Mutation": return CheckoutSchema.Objects.Mutation
      case "CardToken": return CheckoutSchema.Objects.CardToken
      case "Customer": return CheckoutSchema.Objects.Customer
      case "BillingAddressApi": return CheckoutSchema.Objects.BillingAddressApi
      case "ShippingAddressApi": return CheckoutSchema.Objects.ShippingAddressApi
      case "Query": return CheckoutSchema.Objects.Query
      case "PaymentMethod": return CheckoutSchema.Objects.PaymentMethod
      case "Payment": return CheckoutSchema.Objects.Payment
      case "PaymentInternal": return CheckoutSchema.Objects.PaymentInternal
      case "Amount": return CheckoutSchema.Objects.Amount
      case "PaymentGateway": return CheckoutSchema.Objects.PaymentGateway
      case "PaymentCore": return CheckoutSchema.Objects.PaymentCore
      case "PaymentOutcome": return CheckoutSchema.Objects.PaymentOutcome
      case "PaymentDetails": return CheckoutSchema.Objects.PaymentDetails
      case "PaymentTimeline": return CheckoutSchema.Objects.PaymentTimeline
      case "PaymentTimelineEvent": return CheckoutSchema.Objects.PaymentTimelineEvent
      case "FlowSummary": return CheckoutSchema.Objects.FlowSummary
      case "PaymentCustomer": return CheckoutSchema.Objects.PaymentCustomer
      case "PaymentMethodDetails": return CheckoutSchema.Objects.PaymentMethodDetails
      case "Attachment": return CheckoutSchema.Objects.Attachment
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}