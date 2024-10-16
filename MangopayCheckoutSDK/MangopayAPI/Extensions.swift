//
//  File.swift
//  
//
//  Created by Elikem Savie on 17/01/2023.
//

import Foundation

extension UUID {

    var version1UUID: String {
        var uuid: uuid_t = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
        withUnsafeMutablePointer(to: &uuid) {
            $0.withMemoryRebound(to: UInt8.self, capacity: 16) {
                uuid_generate_time($0)
            }
        }

        let finalUUID = UUID(uuid: uuid)
        return finalUUID.uuidString
    }

}


extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func asyncData(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }

    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func asyncUploadData(for request: URLRequest, data: Data) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.uploadTask(with: request, from: data) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }

}

extension Encodable {
    func toDict() -> [String: Any]? {
        return (try? JSONSerialization.jsonObject(
            with: JSONEncoder().encode(self),
            options: .fragmentsAllowed)
        ) as? [String: Any]
    }
}
