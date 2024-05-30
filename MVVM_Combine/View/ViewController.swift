//
//  ViewController.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import UIKit
import Foundation
import CommonCrypto

class ViewController: BaseViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var viewModel = LoginViewModel(username: "abcxyz", password: "123456")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let crypto = WebCrypto()
//        let input = Data("U2FsdGVkX1/hcIiMnTPnmBbEfzNtNyxkGhyc1jO+IZD8c3kP4nz62fOVWaSTsmO03st58nmSS7S7ETiYLuQjZRGD6sTSvjHWxx7OOLNJtxZi1SvG6vrKAailL7v1+j0i8uvjcCNUmJkHDkLDkP6SMYJ/FxpOcRoUBoF6FATCjsvZNNRqep+PrmJPVBM2nErv1eAc73xSAtznKShC23xzNA8u+fdcuBJp3D1CAVaUb1cezEk4+IZ92i992YZmZKjdmtUPUtr8ZcBEYpqWFitoLR9Ccbr1kBuVUti6/HBRPNf6XoUk0gkj+G5EYnUp7BgzfZkgoXe1/+xbFFfBx7SK0GYeZvmoIEnKpS9RtCZ0GUgk6DTLzJ/ibB/81WATADhpEuA8yEhXXdTU5DqyWfLOMbAIS1zthEUpiAqg2bgwm1sI1xO8/IT68BgAUHl0X6uh638CzrrL96rpU6rG9Eu3+NZNSk8zUokT3Y+pQYp9KVUW6VE5FKdcGJL+EULoZ9CEqt0xTPhNpprfukwjzM3Lyg=".utf8)
//        let key = "UD4WPukv3D122MWQMddUrNe)pn697MYmhg^b00b204fght"
//        let iv = "???"
//
//        crypto.encrypt(data: input, key: key, iv: iv, callback: {(encrypted: Data?, error: Error?) in
//            print(encrypted!)
//        })


    }

    override func setupData() {
        super.setupData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.title = "Login"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
        
    }
    
    override func bindingToView() {
        super.bindingToView()
        
        viewModel.$username
            .assign(to: \.text, on: usernameTextField)
            .store(in: &subcriptions)
        
        viewModel.$password
            .assign(to: \.text, on: passwordTextField)
            .store(in: &subcriptions)
        
        viewModel.$isLoading
            .sink(receiveValue: { isLoading in
                if isLoading {
                    self.indicatorView.startAnimating()
                } else {
                    self.indicatorView.stopAnimating()
                }
            }).store(in: &subcriptions)
        
        viewModel.validateText
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &subcriptions)
    }
    
    override func bindingToViewModel() {
        super.bindingToViewModel()
        
        usernameTextField.publisher
            .assign(to: \.username, on: viewModel)
            .store(in: &subcriptions)
        
        passwordTextField.publisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subcriptions)
    }
    
    override func router() {
        super.router()
        
        viewModel.state
            .sink { [weak self] state in
                if case .error(let message) = state {
                    _ = self?.alert(title: "Demo MVVM_Combine", message: message)
                } else if case .logined = state {
                    self!.viewModel.isLoading = false
                    
                    let vc = HomeViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }.store(in: &subcriptions)
    }
    
    @objc func clear() {
        viewModel.clear()
    }
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        viewModel.login()
            .sink { [weak self] done in
                self!.viewModel.isLoading = false
                
                if done {
                    let vc = HomeViewController()
                    self?.present(vc, animated: true)
                } else {
                    self?.alert(title: "Check Login", message: "login failed")
                }
            }.store(in: &subcriptions)
    }
}

