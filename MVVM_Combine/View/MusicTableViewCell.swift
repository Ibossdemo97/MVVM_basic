//
//  MusicTableViewCell.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import UIKit
import Combine

class MusicTableViewCell: UITableViewCell {

    var downloadPublisher = PassthroughSubject<Void, Never>()
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var viewModel: MusicCellViewModel? {
        didSet {
            self.bindingToView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingToView() {
        self.nameLabel.text = viewModel?.music.name
        self.artistNameLabel.text = viewModel?.music.artistName
        
        if let image = viewModel?.music.thumbnailImage {
            self.thumbnailImageView.image = image
        } else {
            self.thumbnailImageView.image = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.downloadPublisher.send()
        })
    }
    
}
