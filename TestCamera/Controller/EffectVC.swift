//
//  EffectVC.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

class EffectsVC: UIViewController {
    
    var imagePhoto: UIImage?
    var auxiliaryEffectButton = AuxiliaryButton()
    var buttonEffect = ButtonEffect()
    var labelEffect = LabelEffect()
    var updateEffectImageDelegate: UpdateImage?
    
    var imageViewEffect: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -1
        return image
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1079640165, green: 0.1179675236, blue: 0.1687111855, alpha: 1)
        view.addSubview(imageViewEffect)
        view.addSubview(buttonEffect.lightLeaksButton)
        view.addSubview(buttonEffect.texturesButton)
        view.addSubview(buttonEffect.dateButton)
        view.addSubview(labelEffect.lightLeaksLabel)
        view.addSubview(labelEffect.texturesLabel)
        view.addSubview(labelEffect.dateLabel)
        view.addSubview(auxiliaryEffectButton.saveButton)
        view.addSubview(auxiliaryEffectButton.cameraBackButton)
        
        auxiliaryEffectButton.cameraBackButton.addTarget(self, action: #selector(cameraBackButtonTap), for: .touchUpInside)
        auxiliaryEffectButton.saveButton.addTarget(self, action: #selector(effectsSaveButtonTap), for: .touchUpInside)
       
        buttonEffect.texturesButton.addTarget(self, action: #selector(textureTap), for: .touchUpInside)
        buttonEffect.lightLeaksButton.addTarget(self, action: #selector(lightLTap), for: .touchUpInside)
        buttonEffect.dateButton.addTarget(self, action: #selector(dateButtonTap), for: .touchUpInside)
        setConsrtraints()
        imageViewEffect.image = imagePhoto
        
    }
    
    @objc func cameraBackButtonTap() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func effectsSaveButtonTap() {
        let alert = UIAlertController(title: "Attention", message: "Save photo to gallery?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { alert in
            UIImageWriteToSavedPhotosAlbum(self.imageViewEffect.image!, nil, nil, nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @objc func textureTap() {
        let dest = TextureVC()
        dest.updateImageEDelegate = self
        dest.imageTexture = effectCell.imageWithView(view: imageViewEffect) //?.scaleImage(toWidth: 1000)  //imageViewEffect.image
       self.navigationController?.pushViewController(dest, animated: false)
    }

    @objc func lightLTap() {
        let dest = LightLVC()
        dest.updateLightLeaksImageDelegate = self
        dest.imageLeaks = effectCell.imageWithView(view: imageViewEffect)//?.scaleImage(toWidth: 1000)
       self.navigationController?.pushViewController(dest, animated: false)
    }
    
    @objc func dateButtonTap() {
        let dest = DateVC()
        dest.updateDateImageDelegate = self
        dest.imageDate = effectCell.imageWithView(view: imageViewEffect)
       self.navigationController?.pushViewController(dest, animated: false)
    }
    
    func setConsrtraints() {
        
        NSLayoutConstraint.activate([
            imageViewEffect.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageViewEffect.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewEffect.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewEffect.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            auxiliaryEffectButton.cameraBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryEffectButton.cameraBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            auxiliaryEffectButton.saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryEffectButton.saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            buttonEffect.lightLeaksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            buttonEffect.lightLeaksButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
            
            buttonEffect.texturesButton.leadingAnchor.constraint(equalTo:  buttonEffect.lightLeaksButton.trailingAnchor, constant: 70),
            buttonEffect.texturesButton.centerYAnchor.constraint(equalTo: buttonEffect.lightLeaksButton.centerYAnchor),
            
            
            buttonEffect.dateButton.leadingAnchor.constraint(equalTo:  buttonEffect.texturesButton.trailingAnchor, constant: 70),
            buttonEffect.dateButton.centerYAnchor.constraint(equalTo: buttonEffect.lightLeaksButton.centerYAnchor),
            
            labelEffect.lightLeaksLabel.widthAnchor.constraint(equalToConstant: 65),
            labelEffect.lightLeaksLabel.heightAnchor.constraint(equalToConstant: 17),
            labelEffect.lightLeaksLabel.topAnchor.constraint(equalTo: buttonEffect.lightLeaksButton.bottomAnchor, constant: 10),
            labelEffect.lightLeaksLabel.centerXAnchor.constraint(equalTo: buttonEffect.lightLeaksButton.centerXAnchor),
            
            labelEffect.texturesLabel.widthAnchor.constraint(equalToConstant: 51),
            labelEffect.texturesLabel.heightAnchor.constraint(equalToConstant: 17),
            labelEffect.texturesLabel.topAnchor.constraint(equalTo: buttonEffect.texturesButton.bottomAnchor, constant: 10),
            labelEffect.texturesLabel.centerXAnchor.constraint(equalTo: buttonEffect.texturesButton.centerXAnchor),
            
            
            labelEffect.dateLabel.widthAnchor.constraint(equalToConstant: 30),
            labelEffect.dateLabel.heightAnchor.constraint(equalToConstant: 17),
            labelEffect.dateLabel.topAnchor.constraint(equalTo: buttonEffect.dateButton.bottomAnchor, constant: 10),
            labelEffect.dateLabel.centerXAnchor.constraint(equalTo: buttonEffect.dateButton.centerXAnchor)
        ])
    }
}

extension EffectsVC: UpdateImage {
    func update(image: UIImage?) {
        imageViewEffect.image = image
    }
 
}
