//
//  ClientApi.swift
//  ItlyIterativelyPlugin
//
//  Created by Konstantin Dorogan on 18.09.2020.
//

import Foundation

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
    
    func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void,ClientApiError>) -> Void)) {
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(batch)
        } catch {
            completion(.failure(.internalError(error)))
            return
        }
        
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
         urlSession: URLSession = .shared) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
        self.urlSession = urlSession
    }
}
