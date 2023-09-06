//
//  CharacterCollecionViewCell.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import UIKit

protocol CharacterCollecionViewCellDelegate: AnyObject {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class CharacterCollecionViewCell: UICollectionViewCell {
    static let identifier = "CharacterCollecionViewCell"
    private var character: Character?
    weak var delegate: CharacterCollecionViewCellDelegate?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var episodesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(character: Character) {
        self.character = character
        self.contentView.layer.cornerRadius = 10
        self.stackView.layer.cornerRadius = 10
        self.imageView.layer.cornerRadius = 10
        self.nameLabel.layer.cornerRadius = 10
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        var underlineAttributedString = NSAttributedString(string: "", attributes: underlineAttribute)
        
        if let imageURL = character.image {
            self.delegate?.loadImage(from: imageURL, completion: { image in
                self.setImage(image: image)
            })
        }
        
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.nameLabel.text = character.name
        if let status = character.status {
            underlineAttributedString = NSAttributedString(string: "Status: \(status)", attributes: underlineAttribute)
            self.statusLabel.attributedText = underlineAttributedString
        }
        if let species = character.species {
            underlineAttributedString = NSAttributedString(string: "Specie: \(species)", attributes: underlineAttribute)
            self.speciesLabel.attributedText = underlineAttributedString
        }
        if let gender = character.gender {
            underlineAttributedString = NSAttributedString(string: "Gender: \(gender)", attributes: underlineAttribute)
            self.genderLabel.attributedText = underlineAttributedString
        }
        let episodeCount = character.episode.count
        let episodesString = episodeCount > 1 ? "episodes" : "episode"
        underlineAttributedString = NSAttributedString(string: "Appeared in \(episodeCount) \(episodesString)", attributes: underlineAttribute)
        self.episodesLabel.attributedText = underlineAttributedString
    }
    
    func setImage(image: UIImage?) {
        DispatchQueue.main.async() { [weak self] in
            self?.imageView.image = image
        }
    }
    
}
