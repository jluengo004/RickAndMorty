//
//  CharacterCollecionViewCell.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import UIKit

protocol CharacterCollecionViewCellDelegate: AnyObject {
    func characterSelected(character: Character)
}

class CharacterCollecionViewCell: UICollectionViewCell {
    static let identifier = "CharacterCollecionViewCell"
    weak var delegate: CharacterCollecionViewCellDelegate?
    private var character: Character?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var originLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var episodesLabel: UILabel!
    @IBOutlet private weak var mainButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(character: Character) {
        self.character = character
        self.contentView.layer.cornerRadius = 10
        
        self.nameLabel.text = "Name: \(character.name)"
        if let status = character.status {
            self.statusLabel.text = "Status: \(status)"
        }
        if let species = character.species {
            self.speciesLabel.text = "Specie: \(species)"
        }
        if let originName = character.origin?.name {
            self.originLabel.text = "Origin: \(originName)"
        }
        if let locationName = character.location?.name {
            self.locationLabel.text = "Actual Location: \(locationName)"
        }
        self.episodesLabel.text = "Appeared in \(character.episode.count) episodes"
    }
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        if let character = self.character {
            self.delegate?.characterSelected(character: character)
        }
    }
    
}
