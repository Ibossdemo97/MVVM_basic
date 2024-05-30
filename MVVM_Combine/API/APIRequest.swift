//
//  APIRequest.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 16/5/24.
//

import Foundation
import Combine

extension API {
    static func request(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return data
            }.eraseToAnyPublisher()
    }
}
