//
//  BaseViewController.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import Foundation
import UIKit
import Combine

class BaseViewController: UIViewController {
    var subcriptions = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
        bindingToView()
        bindingToViewModel()
        router()
    }
    
    func setupData() {
        
    }
    
    func setupUI() {
        
    }
    
    func bindingToView() {
        
    }
    
    func bindingToViewModel() {
        	
    }
    
    func router() {
        
    }
    
    func alert(title: String, message: String) -> AnyPublisher<Void, Never> {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return Future { resoulve in
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                resoulve(.success(()))
            }))
            self.present(alertVC, animated: true, completion: nil)
        }.handleEvents(receiveCancel: {
            self.dismiss(animated: true)
        }).eraseToAnyPublisher()
    }
    
}
