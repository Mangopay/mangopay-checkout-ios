//
//  NetworkUtil.swift
//  OZE
//
//  Created by Elikem Savie on 24/04/2023.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum ResponseStatus: String, Codable {
    case success = "SUCCESS"
    case failure = "FAILURE"
}

struct NetworkTestData {
    var session: URLSession!
    var request: URLRequest!
}

protocol NetworkUtil {
    var apiVersion: String { get }
}

struct Response<T: Codable, H: Codable> {
    var body: T
    var header: H
}

extension NetworkUtil {

    var headers: [String: String] {
        var _headers = [String: String]()
        _headers["Accept"] = "*/*"
        _headers["X-SDK-Version"] = "0.0.45-beta"
        _headers["User-Agent"] = userAgent
        return _headers
    }

    var apiVersion: String {
        return "v2.01"
    }

    var sdkVersion: String {
        return "1.0.0"
    }

    var deviceType: String {
        UIDevice.current.name
    }
    
    var deviceOS: String {
        return UIDevice.current.systemVersion
    }

    var userAgent: String {
        "MangoPayiOSSDK App; \(sdkVersion); \(deviceType), \(deviceOS)"
    }

    func request<T: Codable>(
           url: URL,
           method: HTTPMethod,
           additionalHeaders: [String: String]? = nil,
           bodyParam: [String: Any]? = nil,
           queryParam: [String: Any]? = nil,
           expecting responseType: T.Type,
           authenticate: Bool = true,
           basicAuthDict: [String: String]? = nil,
           apiKey: String? = nil,
           verbose: Bool = false,
           useXXForm: Bool = false,
           decodeAsString: Bool = false
     ) async throws -> T {
         var request: URLRequest

         if let _queryParam = queryParam {
             var components = URLComponents(string: url.absoluteString)!
             components.queryItems = _queryParam.map({ (arg) -> URLQueryItem in
                 let (key, value) = arg
                 return URLQueryItem(name: key, value: "\(value)")
             })
             components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(
                of: "+", with: "%2B"
             )
             request = URLRequest(url: components.url!)
         } else {
             request = URLRequest(url: url)

             if let _bodyParam = bodyParam {
                 if !useXXForm {
                     
                     let jsonData = try JSONSerialization.data(
                        withJSONObject: _bodyParam,
                        options: .prettyPrinted
                     )
                     request.httpBody = jsonData
                     
                 } else {
                     var components = URLComponents(string: url.absoluteString)!
                     components.queryItems = _bodyParam.map({ (arg) -> URLQueryItem in
                         let (key, value) = arg
                         return URLQueryItem(name: key, value: "\(value)")
                     })
                     request.httpBody = components.query?.data(using: .utf8)
                 }
                 }
             }
 
 
         request.httpMethod = method.rawValue

         headers.forEach {(request.addValue($0.value, forHTTPHeaderField: $0.key))}
         additionalHeaders?.forEach {(request.addValue($0.value, forHTTPHeaderField: $0.key))}
         
         
//         if let basicAuthData = basicAuthDict {
//             if let username = basicAuthData["Username"], let password = basicAuthData["Password"] {
//    
//                 let authDataStr = String(format: "%@:%@", username, password)
//                 let authData = authDataStr.data(using: String.Encoding.utf8)!
//                 let base64LoginString = authData.base64EncodedString()
//                 
//                 request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
//             }
//
//         }
         
         if let apiKey = apiKey {
             request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
         }


         let (data, response) = try await URLSession.shared.asyncData(for: request)
         let result = try self.processResponse(
            responseData: data,
            response: response,
            responseType: responseType,
            verbose: verbose,
            decodeAsString: decodeAsString
         )
         return result
     }


}

private extension NetworkUtil {

    func processResponse<T: Codable>(
          responseData: Data?,
          response: URLResponse?,
          responseType: T.Type,
          verbose: Bool = false,
          decodeAsString: Bool = false
      ) throws -> T {

        guard var data = responseData else {
            throw NetworkError.noDataReturned
        }

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
    
        let statusCode = response.statusCode
    
//        if verbose {
//            if let payload = try? jsonSerializeOrError(data) {
//                print("RESPONSE [\(statusCode)] -", payload)
//            } else {
//                print("RESPONSE [\(statusCode)] -", String(data: data, encoding: .utf8))
//            }
//        }

        do {
            switch statusCode {
            case 200..<300:
                if decodeAsString {
                    data = try decodeAsDataString(data)
                }
                return try decode(data)

            case 300..<400:
                throw NetworkError.redirectError
            case 400..<500:
                let payload = try jsonSerializeOrError(data)
                throw NetworkError.clientError(additionalInfo: payload, headerInfo: response.allHeaderFields)
            case 500...:
                let payload = try jsonSerializeOrError(data)
                throw NetworkError.serverError(additionalInfo: payload)
            default:
                throw NetworkError.unknownError
            }
        } catch let error {
            guard statusCode == 204 else { throw error }

            let noContent = try JSONSerialization.data(
                withJSONObject: ["status": 204],
                options: .prettyPrinted
            )
        
            return try decode(noContent)

        }

    }

    func jsonSerializeOrError(_ data: Data) throws -> [String: Any] {
        guard let json = try JSONSerialization.jsonObject(
            with: data, options: []
        ) as? [String: Any] else { throw NetworkError.unknownError }

        return json
    }

    func decode<T: Codable, H: Codable>(
        _ data: Data,
        headerData: Data,
        dataResponse: T.Type = T.self,
        headerResponse: H.Type? = H.self
    ) throws -> Response<T, H> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970

        let body = try decoder.decode(T.self, from: data)

        let header = try decoder.decode(
            H.self,
            from: headerData
        )

        let response = Response(body: body, header: header)
        return response
    }

    func decode<T: Codable> (_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970

        return try decoder.decode(T.self, from: data)
    }

//    func decodeAsString(_ data: Data) -> String {
//        let str = String(decoding: data, as: UTF8.self)
//        let data = [
//            "key": str
//        ]
//        return str
//    }

    func decodeAsDataString(_ data: Data) throws -> Data {
        let str = String(decoding: data, as: UTF8.self)
        let dataDict = [
            "RegistrationData": str
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            return jsonData
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func generic<T>(parameter: AnyObject, type: T.Type) -> Bool {
        if parameter is T {
            return true
        } else {
            return false
        }
    }


}

