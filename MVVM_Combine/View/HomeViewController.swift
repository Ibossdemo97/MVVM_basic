//
//  HomeViewController.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var musicTableView: UITableView!
    
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
    }
    
    @objc func reset() {
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as? MusicTableViewCell else {
            return MusicTableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

