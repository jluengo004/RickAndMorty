//
//  CharacterFilterBackdrop.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 4/9/23.
//

import Foundation
import UIKit

public protocol CharacterFilterBackdropDelegate {
    func searchCharacters(filters: CharacterServiceParamsModel)
    func dismissView()
}

public class CharacterFilterBackdrop: UIView {
    @IBOutlet public var containerView: CharacterFilterBackdrop!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var speciesTextField: UITextField!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var typeTextField: UITextField!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusStackView: UIStackView!
    @IBOutlet private weak var aliveButton: FilterButton!
    @IBOutlet private weak var deadButton: FilterButton!
    @IBOutlet private weak var unknownStatusButton: FilterButton!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var genderStackView: UIStackView!
    @IBOutlet private weak var femaleButton: FilterButton!
    @IBOutlet private weak var maleButton: FilterButton!
    @IBOutlet private weak var genderlessButton: FilterButton!
    @IBOutlet private weak var unknownGenderButton: FilterButton!
    @IBOutlet private weak var searchButton: UIButton!
    
    public var delegate: CharacterFilterBackdropDelegate?
    private var selectedStatusButton: FilterButton?
    private var selectedGenderButton: FilterButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let name = String(describing: type(of: self))
        let bundle = Bundle(for: self.classForCoder)
        self.containerView = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? CharacterFilterBackdrop
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDefaultView() {
        self.containerView.nameLabel.text = "Name"
        self.containerView.speciesLabel.text = "Specie"
        self.containerView.typeLabel.text = "Type"
        self.containerView.statusLabel.text = "Status"
        self.containerView.genderLabel.text = "Gender"
        
        self.containerView.aliveButton.setTitle("Alive", for: .normal)
        self.containerView.aliveButton.status = .alive
        self.containerView.deadButton.setTitle("Dead", for: .normal)
        self.containerView.deadButton.status = .dead
        self.containerView.unknownStatusButton.setTitle("Unknown", for: .normal)
        self.containerView.unknownStatusButton.status = .unknown
        self.containerView.femaleButton.setTitle("Female", for: .normal)
        self.containerView.femaleButton.gender = .female
        self.containerView.maleButton.setTitle("Male", for: .normal)
        self.containerView.maleButton.gender = .male
        self.containerView.genderlessButton.setTitle("Genderless", for: .normal)
        self.containerView.genderlessButton.gender = .genderless
        self.containerView.unknownGenderButton.setTitle("Unknown", for: .normal)
        self.containerView.unknownGenderButton.gender = .unknown
        
        self.containerView.nameTextField.delegate = self
        self.containerView.speciesTextField.delegate = self
        self.containerView.typeTextField.delegate = self
        
        self.containerView.searchButton.setTitle("Search", for: .normal)
        self.containerView.searchButton.backgroundColor = UIColor(red: 48/255, green: 71/255, blue: 140/255, alpha: 1)
        self.containerView.searchButton.setTitleColor(UIColor.white, for: .normal)
        self.containerView.searchButton.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.containerView.backgroundView.addGestureRecognizer(tap)
    }
    
    @objc private func statusButtonTapped(_ sender: FilterButton) {
        if self.selectedStatusButton != sender {
            self.selectedStatusButton?.isSelected = !(self.selectedStatusButton?.isSelected ?? false)
            self.selectedStatusButton = sender
        } else {
            self.selectedStatusButton = nil
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc private func genderButtonTapped(_ sender: FilterButton) {
        if self.selectedGenderButton != sender {
            self.selectedGenderButton?.isSelected = !(self.selectedGenderButton?.isSelected ?? false)
            self.selectedGenderButton = sender
        } else {
            self.selectedGenderButton = nil
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc private func searchButtonTapped(_ sender: Any) {
        let filterParams = CharacterServiceParamsModel(ids: nil,
                                                       name: self.containerView.nameTextField.text,
                                                       status: self.selectedStatusButton?.status,
                                                       species:  self.containerView.speciesTextField.text,
                                                       type:  self.containerView.typeTextField.text,
                                                       gender: self.selectedGenderButton?.gender)
        
        delegate?.searchCharacters(filters: filterParams)
    }
    
    @objc private func dismissView() {
        delegate?.dismissView()
    }
    
    public func addCharacterFilterBackdrop(viewMain: UIView, delegate: CharacterFilterBackdropDelegate?){
        let characterFilterBackdrop = getCharacterFilterBackdropOverlay()
        characterFilterBackdrop.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        characterFilterBackdrop.frame = viewMain.bounds
        self.delegate = delegate
        self.containerView.searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        self.containerView.femaleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        self.containerView.maleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        self.containerView.genderlessButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        self.containerView.unknownGenderButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        self.containerView.aliveButton.addTarget(self, action: #selector(statusButtonTapped(_:)), for: .touchUpInside)
        self.containerView.deadButton.addTarget(self, action: #selector(statusButtonTapped(_:)), for: .touchUpInside)
        self.containerView.unknownStatusButton.addTarget(self, action: #selector(statusButtonTapped(_:)), for: .touchUpInside)
        viewMain.addSubview(characterFilterBackdrop)
    }
    
    fileprivate func getCharacterFilterBackdropOverlay() -> CharacterFilterBackdrop {
        setDefaultView()
        return self
    }
    
}

extension CharacterFilterBackdrop: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        jumpToNextTF(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        jumpToNextTF(textField)
        return true
    }
    
    private func jumpToNextTF(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == self.containerView.nameTextField {
            self.containerView.speciesTextField.becomeFirstResponder()
        } else if textField == self.containerView.speciesTextField{
            self.containerView.typeTextField.becomeFirstResponder()
        }
    }
    
}

