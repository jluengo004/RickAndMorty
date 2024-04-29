//
//  UIViewControllerExtension.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message : String, isError: Bool) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = isError ? UIColor.red.withAlphaComponent(0.8) : UIColor.green.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    public func showAlertMessage(title: String, message: String){
        let alertMessagePopUpBox = UIAlertController(title: title, message: "\(message).\nPlease try Again", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}
