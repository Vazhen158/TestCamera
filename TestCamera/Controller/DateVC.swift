//
//  DateVC.swift
//  TestCamera
//
//  Created by Андрей Важенов on 21.06.2022.
//

import UIKit


class DateVC: UIViewController, UpdateImage {
    
    func update(image: UIImage?) {
        imageViewDate.image = image
    }
  
    var imageDate: UIImage?
    var auxiliaryDateButton = AuxiliaryButton()
    private var dateButton = DateButton()
    private var dateLabel = DateLabel()
    var updateDateImageDelegate: UpdateImage?
    
    var imageViewDate: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -1
        return image
    }()
    
    private var scrollView = UIScrollView()
    private var container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewDate.image = imageDate
        view.addSubview(imageViewDate)
        view.backgroundColor = #colorLiteral(red: 0.1079640165, green: 0.1179675236, blue: 0.1687111855, alpha: 1)
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        scrollView.contentSize = CGSize(width: dateButton.dateButton.bounds.width * 10, height: 150)
        scrollView.delegate = self

        view.addSubview(auxiliaryDateButton.backButton)
        view.addSubview(auxiliaryDateButton.saveButton)
        
        container.addSubview(dateButton.dateButton)
        container.addSubview(dateButton.date3Button)
        container.addSubview(dateButton.date4Button)
        
        container.addSubview(dateLabel.noDateLabel)
        container.addSubview(dateLabel.todayLabel)
        container.addSubview(dateLabel.customDateLabel)
        
        auxiliaryDateButton.backButton.addTarget(self, action: #selector(dateBackButtonTap), for: .touchUpInside)
        auxiliaryDateButton.saveButton.addTarget(self, action: #selector(dateSaveButtonTap), for: .touchUpInside)
        
        dateButton.dateButton.addTarget(self, action: #selector(dateTap), for: .touchUpInside)
        dateButton.dateButton.setBackgroundImage(imageDate, for: .normal)
        
        dateButton.date3Button.addTarget(self, action: #selector(todayDateTap), for: .touchUpInside)
        dateButton.date3Button.setBackgroundImage(imageDate, for: .normal)
        
        dateButton.date4Button.addTarget(self, action: #selector(customDateTap), for: .touchUpInside)
        dateButton.date4Button.setBackgroundImage(imageDate, for: .normal)

        setupConstarints()
    }
    
    @objc func dateBackButtonTap() {
        updateDateImageDelegate?.update(image: imageViewDate.image)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func dateSaveButtonTap() {
        let alert = UIAlertController(title: "Attention", message: "Save photo to gallery?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { alert in
            UIImageWriteToSavedPhotosAlbum(self.imageViewDate.image!, nil, nil, nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @objc func dateTap() {
        imageViewDate.image = imageDate
    }
    
    @objc func todayDateTap() {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "d M ''yy"
        let formatteddate = formatter.string(from: time as Date)
        guard let imageOne = imageDate else {return}
        imageViewDate.image = imageOne.textToImage(drawText: formatteddate as NSString, inImage: imageOne.scaleImage(toWidth: 1000))
    }
    
    
    @objc func customDateTap() {
        let dest = DatePickerVC()
        imageViewDate.image = imageDate
        dest.updateDatePickerImageDelegate = self
        dest.imageDatePick = imageViewDate.image
       self.navigationController?.pushViewController(dest, animated: false)
    }
    
    private func setupConstarints() {
        
        scrollView.anchor( left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,  height: 250)
        
        container.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, padddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: view.frame.size.width * 1.1 ) //height: 100
        
        dateButton.dateButton.anchor(top: container.topAnchor,  bottom: container.bottomAnchor,  padddingTop: 20,  paddingBottom: -20, paddingRight: 40, width: 96, height: 96)
        dateLabel.noDateLabel.centerY(inView: dateButton.dateButton, leftAncor: dateButton.dateButton.leftAnchor, rightAnchor: dateButton.dateButton.rightAnchor, paddingLeft: 0, paddingRight: 0, constant: 65)
        
        dateButton.date3Button.anchor(top: container.topAnchor, left: dateButton.dateButton.rightAnchor, bottom: container.bottomAnchor,  padddingTop: 20, paddingLeft: 40, paddingBottom: -20, width: 96)
        dateLabel.todayLabel.centerY(inView: dateButton.date3Button, leftAncor: dateButton.date3Button.leftAnchor, rightAnchor: dateButton.date3Button.rightAnchor, paddingLeft: 0, paddingRight: 0, constant: 65)
        
        dateButton.date4Button.anchor(top: container.topAnchor, left: dateButton.date3Button.rightAnchor, bottom: container.bottomAnchor,  padddingTop: 20, paddingLeft: 40, paddingBottom: -20, width: 96)
        dateLabel.customDateLabel.centerY(inView: dateButton.date4Button, leftAncor: dateButton.date4Button.leftAnchor, rightAnchor: dateButton.date4Button.rightAnchor, paddingLeft: 0, paddingRight: 0, constant: 65)
        
        NSLayoutConstraint.activate([
            
            imageViewDate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageViewDate.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewDate.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewDate.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            auxiliaryDateButton.backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryDateButton.backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            auxiliaryDateButton.saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryDateButton.saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

}
extension DateVC: UIScrollViewDelegate {
    // 1. Вызывается в реальном времени при прокрутке scrollView
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
    // 2. Вызывается, когда scrollView собирается начать перетаскивание
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
    }
}
