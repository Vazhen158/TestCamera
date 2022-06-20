//
//  ButtonEffect.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

struct ButtonEffect {
    
    var lightLeaksButton: UIButton = {
        let buttonLightLeaks = UIButton(type: .system)
        let lightLeaksImageButton = UIImage(named: "lightLeaks")
        buttonLightLeaks.frame = CGRect(x: 0, y: 0, width: 98, height: 98)
        buttonLightLeaks.translatesAutoresizingMaskIntoConstraints = false
        buttonLightLeaks.layer.cornerRadius = buttonLightLeaks.frame.width / 2
        buttonLightLeaks.clipsToBounds = false
        buttonLightLeaks.setBackgroundImage(lightLeaksImageButton, for: .normal)
        return buttonLightLeaks
    }()
    
    var texturesButton: UIButton = {
        let buttonTextures = UIButton(type: .system)
        let texturesImageButton = UIImage(named: "textures")
        buttonTextures.frame = CGRect(x: 0, y: 0, width: 98, height: 98)
        buttonTextures.translatesAutoresizingMaskIntoConstraints = false
        buttonTextures.layer.cornerRadius = buttonTextures.frame.width / 2
        buttonTextures.clipsToBounds = false
        buttonTextures.setBackgroundImage(texturesImageButton, for: .normal)
        return buttonTextures
    }()
    
    
    var dateButton: UIButton = {
        let buttonDate = UIButton(type: .system)
        let dateImageButton = UIImage(named: "date")
        buttonDate.frame = CGRect(x: 0, y: 0, width: 98, height: 98)
        buttonDate.translatesAutoresizingMaskIntoConstraints = false
        buttonDate.layer.cornerRadius = buttonDate.frame.width / 2
        buttonDate.clipsToBounds = false
        buttonDate.setBackgroundImage(dateImageButton, for: .normal)
        return buttonDate
    }()
    
    
}

