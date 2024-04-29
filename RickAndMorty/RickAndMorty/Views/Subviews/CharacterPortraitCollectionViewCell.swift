//
//  CharacterPortraitCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit

final class CharacterPortraitCollectionViewCell: UICollectionViewCell {
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
        self.nameLabel.allowsDefaultTighteningForTruncation = true
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.imageView.layer.cornerRadius = 10
        
        if let imageURL = character.image {
            self.delegate?.loadImage(from: imageURL, completion: { image in
                self.setImage(image: image)
            })
        } else {
            self.imageView.image = UIImage(named: "placeHolderRAM")
        }
    }
    
    func setImage(image: UIImage?) {
        DispatchQueue.main.async() { [weak self] in
            if self?.character?.image != nil {
                self?.imageView.image = image
            }
        }
    }
}
