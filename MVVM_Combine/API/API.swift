//
//  API.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 16/5/24.
//

import Foundation
import Combine

enum APIError: Error {
    case error(String)
    case errorURL
    case invalidResponse
    case errorParsing
    case unknown
    
    var localizedDescription: String {
        switch self {
        case . error(let message):
            return message
        case .errorURL:
            return "URL String Error"
        case .invalidResponse:
            return "invalidResponse"
        case .errorParsing:
            return "Failed parsing respose from sever"
        case .unknown:
            return "unknown Error"
        }
    }
}

struct API {
    struct Configure {
        static let  baseURL = "https://rss.applemarketingtools.com/"
    }
    
    struct Download {
        
    }
    
    struct Music {
        
    }
}
