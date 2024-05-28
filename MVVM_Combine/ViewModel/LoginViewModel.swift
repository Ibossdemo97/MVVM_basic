//
//  LoginViewModel.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import Foundation
import Combine

enum State {
    case initial
    case logined
    case error(message: String)
}

enum Action {
    case login
    case clear
}

final class LoginViewModel {
    
    let action = PassthroughSubject<Action, Never>()
      
    let state = CurrentValueSubject<State, Never>(.initial)
      
    var subscriptions = [AnyCancellable]()
    var validateText: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($username, $password)
            .map { !($0!.isEmpty || $1!.isEmpty) }
            .eraseToAnyPublisher()
    }
    
    @Published var username: String?
    @Published var password: String?
    @Published var isLoading: Bool = false
    
    var user: User?
    
    init(username: String, password: String) {
        self.user = .init(username: username, password: password)
        
        state.sink{ [weak self] state in
            self?.processState(state)
        }.store(in: &subscriptions)
        
        action.sink { [weak self] action in
            self?.processAction(action)
        }.store(in: &subscriptions)
        
        $username.sink { print( $0 ?? "")}.store(in: &subscriptions)
    }
    
    private func processAction(_ action: Action) {
        switch action {
        case .login:
            print("ViewModel -> Login")
            _ = login().sink { done in
                self.isLoading = false
            
                if done {
                    self.state.value = .logined
                } else {
                    self.state.value = .error(message: "Login false")
                }
            }
        case .clear:
            self.clear()
        }
    }
    
    private func processState(_ state: State) {
        switch state {
        case .initial:
            if let user = user {
                username = user.username
                password = user.password
                isLoading = false
            } else {
                username = ""
                password = ""
                isLoading = false
            }
        case .logined:
            print("LOGIN")
            isLoading = true
        case .error(let message):
            print("ERROR: \(message)")
        }
    }
    
    func clear() {
        username = ""
        password = ""
    }
    
    func login() -> AnyPublisher<Bool, Never> {
        if isLoading {
            return $isLoading.map { !$0 }.eraseToAnyPublisher()
        }
        isLoading = true
        
        let test = username == "" && password == "123456"
        
        let subject = CurrentValueSubject<Bool, Never>(test)
        return subject.delay(for: .seconds(3), scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }
}
