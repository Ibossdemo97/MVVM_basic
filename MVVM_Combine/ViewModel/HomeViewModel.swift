//
//  HomeViewModel.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 16/5/24.
//

import Foundation
import Combine

final class HomeViewModel {
    
    
    enum State {
        case initial
        case fetched
        case error(message: String)
        case reloadCell(indexPath: IndexPath)
    }
    
    enum Action {
        case fetchData
        case reset
        case downloadImage(indexpath: IndexPath)
    }
    
    @Published var musics = [Music]()
    @Published var isLoading: Bool = false
    
    let action = PassthroughSubject<Action, Never>()
    let state = CurrentValueSubject<State, Never>(.initial)
    
    var subcriptions = [AnyCancellable]()
    var musicsCancellable = [AnyCancellable]()
    
    init() {
        
        state
            .sink { [weak self] state in
            self?.processState(state)
        }.store(in: &subcriptions)

        action
            .sink { [weak self] action in
                self?.processAction(action)
            }.store(in: &subcriptions)

    }
    
    private func fetchData() {
        
        musicsCancellable = []
        
        API.Music.getNewMusic(limit: 100)
            .map(\.feed.results)
            .replaceError(with: [])
            .assign(to: \.musics, on: self)
            .store(in: &musicsCancellable)
        
    }
    
    private func downloadImage(indexpath: IndexPath) {
        if indexpath.row < musics.count {
            let item = musics[indexpath.row]
            
            API.image(urlString: item.artworkUrl100)
                .replaceError(with: nil)
                .sink(receiveValue: { image in
                    item.thumbnailImage = image
                    self.state.send(.reloadCell(indexPath: indexpath))
                }).store(in: &musicsCancellable)
        }
    }
    
    private func processAction(_ action: Action) {
        switch action {
        case .fetchData:
            print("ViewModel -> Action: FetchData")
            fetchData()
        case .reset:
            print("ViewModel -> Action: Reset")
            musics = []
            fetchData()
        case .downloadImage(let indexpath):
            print("ViewModel -> Action: Download at \(indexpath)")
            downloadImage(indexpath: indexpath)
        }
    }
   
    private func processState(_ state: State) {
        switch state {
        case .initial:
            print("ViewModel -> State: initial")
            isLoading = false
        case .fetched:
            print("ViewModel -> State: fetched")
            isLoading = true
        case .error(let message):
            print("ViewModel -> State: Error: \(message)")
        case .reloadCell(let indexPath):
            print("ViewModel -> State: ReloadCell: \(indexPath)")
        }
    }
}

extension HomeViewModel {
    func numberOfRows(in section: Int) -> Int {
        return musics.count
    }
    
    func musicCellViewModel(at indexPatch: IndexPath) -> MusicCellViewModel {
        return MusicCellViewModel(music: musics[indexPatch.row])
    }
}
