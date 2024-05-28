//
//  UITextFieldPublisher.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    var publisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
}
