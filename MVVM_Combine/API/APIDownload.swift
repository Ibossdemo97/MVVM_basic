//
//  APIDownload.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 16/5/24.
//

import Foundation
import UIKit
import Combine

extension API {
    static func image(urlString: String) -> AnyPublisher<UIImage?, APIError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
        }
        return API.request(url: url)
            .map { UIImage(data: $0) }
            .mapError { $0 as? APIError ?? .unknown }
            .eraseToAnyPublisher()
    }
}
