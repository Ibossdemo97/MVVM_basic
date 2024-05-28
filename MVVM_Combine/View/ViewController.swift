//
//  ViewController.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import UIKit

class ViewController: BaseViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var viewModel = LoginViewModel(username: "abcxyz", password: "123456")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self?.alert(title: "Check Login", message: "login failed")
                }
            }.store(in: &subcriptions)
    }
}

