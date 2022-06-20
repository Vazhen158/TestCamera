//
//  AuxiliaryButton.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

struct AuxiliaryButton {
    
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        let imageButton = UIImage(named: "saveButton")
        button.frame = CGRect(x: 0, y: 0, width: 73, height: 44)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = false
        button.setBackgroundImage(imageButton, for: .normal)
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton(type: .system)
        let imageButton = UIImage(named: "backButton")
        button.frame = CGRect(x: 0, y: 0, width: 73, height: 44)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = false
        button.setBackgroundImage(imageButton, for: .normal)
        return button
    }()
    
    var cameraBackButton: UIButton = {
        let button = UIButton(type: .system)
        let imageButton = UIImage(named: "cameraBack")
        button.frame = CGRect(x: 0, y: 0, width: 73, height: 44)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = false
        button.setBackgroundImage(imageButton, for: .normal)
        return button
    }()
    
}
