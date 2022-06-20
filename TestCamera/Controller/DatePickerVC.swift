//
//  DatePickerVC.swift
//  TestCamera
//
//  Created by Андрей Важенов on 21.06.2022.
//

import UIKit

class DatePickerVC: UIViewController {
    
    var imageDatePick: UIImage?
    private var auxiliaryDateButton = AuxiliaryButton()
    
    var pickerDate = UIDatePicker()
    var updateDatePickerImageDelegate: UpdateImage?
    
    var imageViewDatePick: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -1
        return image
    }()
    
    let buttonDatePick : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.4312084615, green: 0.1073774174, blue: 0.876906991, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(doneTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageViewDatePick)
        imageViewDatePick.image = imageDatePick
        view.addSubview(auxiliaryDateButton.backButton)
        view.addSubview(auxiliaryDateButton.saveButton)
        view.addSubview(buttonDatePick)
        view.addSubview(pickerDate)
        view.backgroundColor = #colorLiteral(red: 0.1079640165, green: 0.1179675236, blue: 0.1687111855, alpha: 1)
        auxiliaryDateButton.backButton.addTarget(self, action: #selector(dateBackButtonTap), for: .touchUpInside)
        auxiliaryDateButton.saveButton.addTarget(self, action: #selector(dateSaveButtonTap), for: .touchUpInside)
        
        setupPicker()
        setupConstarints()
    }

    @objc func pickerTap(paramPicker: UIDatePicker) {
        if paramPicker.isEqual(self.pickerDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d M ''yy"
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
        }
    }
    
    @objc func doneTap(paramPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d M ''yy"
        guard let imageTwo = imageDatePick else {return}
        imageViewDatePick.image = imageTwo.textToImage(drawText: dateFormatter.string(from: pickerDate.date) as NSString, inImage: imageTwo.scaleImage(toWidth: 1000))
        updateDatePickerImageDelegate?.update(image: imageViewDatePick.image)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func dateBackButtonTap() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func dateSaveButtonTap() {
        let alert = UIAlertController(title: "Attention", message: "Save photo to gallery?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { alert in
            UIImageWriteToSavedPhotosAlbum(self.imageViewDatePick.image!, nil, nil, nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func setupPicker() {
        pickerDate.addTarget(self, action: #selector(pickerTap), for: .valueChanged)
        pickerDate.datePickerMode = .date
        if #available(iOS 13.4, *) {
            pickerDate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        pickerDate.setValue(UIColor.white, forKey: "textColor")
        pickerDate.setValue(false, forKey: "highlightsToday")
        pickerDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerDate.bottomAnchor.constraint(equalTo: buttonDatePick.topAnchor, constant: -20),
            pickerDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickerDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pickerDate.topAnchor.constraint(equalTo: imageViewDatePick.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupConstarints() {
        
        NSLayoutConstraint.activate([
            
            imageViewDatePick.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageViewDatePick.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewDatePick.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewDatePick.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            auxiliaryDateButton.backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryDateButton.backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            auxiliaryDateButton.saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryDateButton.saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonDatePick.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buttonDatePick.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonDatePick.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonDatePick.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonDatePick.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
        ])
  
    }

}
