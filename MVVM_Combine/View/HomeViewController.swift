//
//  HomeViewController.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {

    @IBOutlet weak var musicTableView: UITableView!
    
    var viewModel = HomeViewModel()
    var cellSubcription: [IndexPath: AnyCancellable] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = "Home"
        musicTableView.delegate = self
        musicTableView.dataSource = self
        musicTableView.register(UINib(nibName: "MusicTableViewCell", bundle: .main), forCellReuseIdentifier: "MusicTableViewCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
    }

    override func setupData() {
        super.setupData()
        
        self.viewModel.action.send(.fetchData)
    }
    
    @objc func reset() {
        
    }
    
    override func bindingToView() {
        viewModel.$musics
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { result in
                print("binding table: \(self.viewModel.numberOfRows(in: 1))")
                self.cellSubcription.removeAll()
                self.musicTableView.reloadData()
            }).store(in: &subcriptions)
        
        viewModel.state
            .sink { [weak self] state in
                if case .reloadCell(let indexPath) = state {
                    self?.musicTableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            .store(in: &subcriptions)
    }
    
    func storeCellCancellable(index: IndexPath, cell: MusicTableViewCell) {
        if !cellSubcription.keys.contains(index) {
            print("")
            
            let cancellable = cell.downloadPublisher
                .debounce(for: 0.1, scheduler: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.action.send(.downloadImage(indexpath: index))
                }
            cellSubcription[index] = cancellable
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as? MusicTableViewCell else {
            return MusicTableViewCell()
        }
        let vm = viewModel.musicCellViewModel(at: indexPath)
        cell.viewModel = vm
        self.storeCellCancellable(index: indexPath, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print("Luyen 1")
//        let array = [1,2,3]
//        for index in 0...4 {
//            print(array[index])
//        }
    }
}

