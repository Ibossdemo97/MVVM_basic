//
//  APIMusic.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 16/5/24.
//

import Foundation
import Combine

extension API.Music {
    
    enum EndPoint {
        
        case newMusics(limit: Int)
        
        var url: URL? {
            switch self {
            case .newMusics(let limit):
                let urlString = API.Configure.baseURL + "api/v2/us/music/most-played/\(limit)/albums.json"
//                let urlString = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/100/albums.json"
                        return URL(string: urlString)
            }
        }
    }
    
    struct MusicResponse: Decodable {
        var feed: MusicResults
        
        enum CodingKeys: String, CodingKey {
            case feed
        }
    }
    
    struct MusicResults: Decodable {
        var results: [Music]
        var updated: String
        
        enum CodingKeys: String, CodingKey {
            case results
            case updated
        }
    }
    
    static func getNewMusic(limit: Int = 20) -> AnyPublisher<MusicResponse, APIError> {
        guard let url = EndPoint.newMusics(limit: limit).url else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
        }
        return API.request(url: url)
            .decode(type: MusicResponse.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    print("\(APIError.errorURL.localizedDescription)")
                    return .errorURL
                case is DecodingError:
                    print("\(APIError.errorParsing.localizedDescription)")
                    return .errorParsing
                default:
                    print("\(APIError.unknown.localizedDescription)")
                    return error as? APIError ?? .unknown
                }
            }.eraseToAnyPublisher()
    }
}
