//
//  CharacterNameTableViewCell.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 6/9/23.
//

import Foundation
import UIKit

class CharacterNameTableViewCell: UITableViewCell {
    static let identifier = "CharacterNameTableViewCell"
    private var character: Character?
    weak var delegate: CharacterCollecionViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(character: Character) {
        self.character = character
        self.contentView.layer.cornerRadius = 10
        
        if let imageURL = character.image {
            self.delegate?.loadImage(from: imageURL, completion: { image in
                self.setImage(image: image)
            })
        }
        
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        self.nameLabel.text = character.name
        
    }
    
    func setImage(image: UIImage?) {
        DispatchQueue.main.async() { [weak self] in
            self?.characterImageView.image = image
        }
    }
    
}
