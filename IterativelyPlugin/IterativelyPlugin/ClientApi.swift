//
//  ClientApi.swift
//  ItlyIterativelyPlugin
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation
import ItlySdk

protocol ClientApi {
    func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void,ClientApiError>) -> Void))
}

enum ClientApiError {
    case serverError(_ code: Int)
    case networkError(_ error: Error)
    case internalError(_ error: Error)
}

extension ClientApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverError(let code):
            return "Server error: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .internalError(let error):
            return "Internal error: \(error.localizedDescription)"
        }
    }
}

class DefaultClientApi: ClientApi {
    private let baseUrl: URL
    private let apiKey: String
    private let urlSession: URLSession
    private let logger: Logger?

    func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void,ClientApiError>) -> Void)) {
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            struct Body {
                var objects: [TrackModel]
                var asDict: [String:Any] {
                    return [
                        "objects": objects.map{ $0.asDict }
                    ]
                }
            }
            request.httpBody = try JSONSerialization.data(withJSONObject: Body(objects: batch).asDict, options: .prettyPrinted)
        } catch {
            completion(.failure(.internalError(error)))
            return
        }

        logger?.debug("DefaultClientApi: Request:\r\nURL: \(request.url?.absoluteString ?? "")\r\nMethod: \(request.httpMethod ?? "unnkown")\r\nHeaders:\(request.allHTTPHeaderFields ?? [:])\r\nBody: \(request.httpBody.map{ String(data: $0, encoding: .utf8) ?? "" } ?? "")")

        urlSession.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, error == nil else {
                completion(.failure(.networkError(error!)))
                return
            }

            let successRange = 200..<300
            if successRange.contains(response.statusCode) {
                completion(.success(()))
                return
            }

            completion(.failure(.serverError(response.statusCode)))
        }.resume()
    }

    init(baseUrl: URL,
         apiKey: String,
         urlSession: URLSession = .shared,
         logger: Logger? = nil) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
        self.urlSession = urlSession
        self.logger = logger
    }
}
