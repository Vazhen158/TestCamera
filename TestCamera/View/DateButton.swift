//
//  DateButton.swift
//  TestCamera
//
//  Created by Андрей Важенов on 21.06.2022.
//

import UIKit

struct DateButton {
    
    var dateButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .white
        button.frame.size = CGSize(width: 96, height: 96)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var date3Button: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .white
        button.frame.size = CGSize(width: 96, height: 96)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var date4Button: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .white
        button.frame.size = CGSize(width: 96, height: 96)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}
