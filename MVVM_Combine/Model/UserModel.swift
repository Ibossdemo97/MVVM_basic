//
//  MOdel.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import Foundation

final class User {
    var username: String
    var password: String
    var islogin = false
    var about = "n/a"
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
