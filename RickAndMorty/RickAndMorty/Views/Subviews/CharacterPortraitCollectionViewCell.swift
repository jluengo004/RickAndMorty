//
//  CharacterPortraitCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit

class CharacterPortraitCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharacterPortraitCollectionViewCell"
    private var character: Character?
    weak var delegate: CharacterCollecionViewCellDelegate?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(character: Character) {
        self.character = character
        self.nameLabel.text = character.name
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.nameLabel.tintColor = UIColor.white
        self.imageView.layer.cornerRadius = 10
        
        if let imageURL = character.image {
            self.delegate?.loadImage(from: imageURL, completion: { image in
                self.setImage(image: image)
            })
        }
    }
    
    func setImage(image: UIImage?) {
        DispatchQueue.main.async() { [weak self] in
            self?.imageView.image = image
        }
    }
    
}
