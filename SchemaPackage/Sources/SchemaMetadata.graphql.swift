// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == SchemaPackage.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == SchemaPackage.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == SchemaPackage.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == SchemaPackage.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Query": return SchemaPackage.Objects.Query
    case "Mutation": return SchemaPackage.Objects.Mutation
    case "CardToken": return SchemaPackage.Objects.CardToken
    case "Customer": return SchemaPackage.Objects.Customer
    case "BillingAddressApi": return SchemaPackage.Objects.BillingAddressApi
    case "ShippingAddressApi": return SchemaPackage.Objects.ShippingAddressApi
    case "PaymentMethod": return SchemaPackage.Objects.PaymentMethod
    case "Payment": return SchemaPackage.Objects.Payment
    case "PaymentInternal": return SchemaPackage.Objects.PaymentInternal
    case "Amount": return SchemaPackage.Objects.Amount
    case "PaymentGateway": return SchemaPackage.Objects.PaymentGateway
    case "PaymentCore": return SchemaPackage.Objects.PaymentCore
    case "PaymentOutcome": return SchemaPackage.Objects.PaymentOutcome
    case "PaymentDetails": return SchemaPackage.Objects.PaymentDetails
    case "PaymentTimeline": return SchemaPackage.Objects.PaymentTimeline
    case "PaymentTimelineEvent": return SchemaPackage.Objects.PaymentTimelineEvent
    case "FlowSummary": return SchemaPackage.Objects.FlowSummary
    case "PaymentCustomer": return SchemaPackage.Objects.PaymentCustomer
    case "PaymentMethodDetails": return SchemaPackage.Objects.PaymentMethodDetails
    case "Attachment": return SchemaPackage.Objects.Attachment
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
