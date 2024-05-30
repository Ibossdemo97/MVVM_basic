//
//  MusicModel.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 16/5/24.
//

import Foundation
import UIKit
import Combine

class Music: Decodable {
    var name: String
    var id: String
    var artistName: String
    var artworkUrl100: String
    
    var thumbnailImage: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case artistName
        case artworkUrl100
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        
    }
}
