// @generated
// This file was automatically generated and can be edited to
// provide custom configuration for a generated GraphQL schema.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

enum SchemaConfiguration: ApolloAPI.SchemaConfiguration {
  static func cacheKeyInfo(for type: Object, object: JSONObject) -> CacheKeyInfo? {
    // Implement this function to configure cache key resolution for your schema types.
    return nil
  }
}
