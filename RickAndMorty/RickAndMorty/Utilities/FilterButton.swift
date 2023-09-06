//
//  FilterButton.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 4/9/23.
//

import Foundation
import UIKit

class FilterButton : UIButton {
    var status: CharacterStatus?
    var gender: CharacterGender?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6
        layer.borderColor = UIColor.blue.cgColor
        isSelected = false
    }
    
    override var isSelected: Bool { didSet {
        if isSelected{
            setTitleColor(UIColor.blue, for: .normal)
            backgroundColor = UIColor.white
            layer.borderWidth = 1
        } else{
            setTitleColor(UIColor.systemGray, for: .normal)
            backgroundColor = UIColor.systemGray5
            layer.borderWidth = 0
        }}
    }
}
