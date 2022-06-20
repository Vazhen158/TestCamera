//
//  TextureVC.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit
import CoreImage

class TextureVC: UIViewController, UIGestureRecognizerDelegate {
    
    private var auxiliaryFilterButton = AuxiliaryButton()
    
    var imageTexture: UIImage?
    
    var updateImageEDelegate: UpdateImage?
    
    var imageViewTexture: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -1
        return image
    }()
    
    
    lazy var textureArray = [
        effectCell(name: "No Effect", imageCell: nil),
        effectCell(name: nil, imageCell: UIImage(named: "T1")),
        effectCell(name: nil, imageCell: UIImage(named: "T2")),
        effectCell(name: nil, imageCell: UIImage(named: "T3")),
        effectCell(name: nil, imageCell: UIImage(named: "T4")),
        effectCell(name: nil, imageCell: UIImage(named: "T5")),
        effectCell(name: nil, imageCell: UIImage(named: "T6")),
        effectCell(name: nil, imageCell: UIImage(named: "T7")),
        effectCell(name: nil, imageCell: UIImage(named: "T8")),
        effectCell(name: nil, imageCell: UIImage(named: "T9")),
        effectCell(name: nil, imageCell: UIImage(named: "T10")),
        effectCell(name: nil, imageCell: UIImage(named: "T11")),
        effectCell(name: nil, imageCell: UIImage(named: "T12")),
        effectCell(name: nil, imageCell: UIImage(named: "T13")),
        effectCell(name: nil, imageCell: UIImage(named: "T14")),
        effectCell(name: nil, imageCell: UIImage(named: "T15")),
        effectCell(name: nil, imageCell: UIImage(named: "T16")),
        effectCell(name: nil, imageCell: UIImage(named: "T17"))
    ]
    
    var selectedFilter: effectCell? = nil
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = .init(width: 96, height: 126)
        flow.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        flow.minimumLineSpacing = 28
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        collectionView.register(CollectionCellFilter.self, forCellWithReuseIdentifier: CollectionCellFilter.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1079640165, green: 0.1179675236, blue: 0.1687111855, alpha: 1)
        let correctImage = imageTexture?.fixOrientation()
        imageViewTexture.image = correctImage
        view.addSubview(collectionView)
        view.addSubview(imageViewTexture)
        view.addSubview(auxiliaryFilterButton.backButton)
        view.addSubview(auxiliaryFilterButton.saveButton)
        auxiliaryFilterButton.backButton.addTarget(self, action: #selector(filterBackButtonTap), for: .touchUpInside)
        auxiliaryFilterButton.saveButton.addTarget(self, action: #selector(filterSaveButtonTap), for: .touchUpInside)
        setConsrtraints()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func selectFirstCategory(){
        if textureArray.count > 0 {
            selectedFilter = textureArray[0]
        }
    }
    
    
    @objc func filterSaveButtonTap() {
        let alert = UIAlertController(title: "Attention", message: "Save photo to gallery?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { alert in
            UIImageWriteToSavedPhotosAlbum(self.imageViewTexture.image!, nil, nil, nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @objc func filterBackButtonTap() {
        updateImageEDelegate?.update(image: imageViewTexture.image)
        self.navigationController?.popViewController(animated: false)
    }

    func applyTexture(originalImage: UIImage, textureImage: UIImage) {
        UIGraphicsBeginImageContextWithOptions(originalImage.size, true, originalImage.scale)
        textureImage.draw(in: CGRect(origin: CGPoint.zero, size: originalImage.size))
        let resizedTextureImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let inputImage = CIImage(image: originalImage)
        let backgroundImage = CIImage(image: resizedTextureImage)
        let filter = CIFilter(name: "CIScreenBlendMode") // CIExclusionBlendMode,  CILinearDodgeBlendMode CIScreenBlendMode
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)
        let newCIImage = (filter?.outputImage)!
        
        let context = CIContext(options: nil)
        let newCGImage = context.createCGImage(newCIImage, from: newCIImage.extent)!
        imageViewTexture.image = UIImage(cgImage: newCGImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        imageViewTexture.contentMode = .scaleAspectFit
        
    }
    
    
    func setConsrtraints() {
        
        NSLayoutConstraint.activate([
            imageViewTexture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageViewTexture.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewTexture.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewTexture.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            auxiliaryFilterButton.backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryFilterButton.backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            auxiliaryFilterButton.saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            auxiliaryFilterButton.saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            collectionView.heightAnchor.constraint(equalToConstant: 126)
        ])
        
    }
    
}

extension TextureVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: CollectionCellFilter.identifier,
                                 for: indexPath) as? CollectionCellFilter
        else {
            return UICollectionViewCell()
        }
        
        cell.configureTwo(with: textureArray[indexPath.item])
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilter = textureArray[indexPath.row]
        guard  let image1 = imageTexture?.fixOrientation().scaleImage(toWidth: 1300) else {return}
        switch indexPath.row {
        case 0:
            imageViewTexture.image = image1
        case 1:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T1")!)
        case 2:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T2")!)
        case 3:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T3")!)
        case 4:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T4")!)
        case 5:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T5")!)
        case 6:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T6")!)
        case 7:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T7")!)
        case 8:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T8")!)
        case 9:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T9")!)
        case 10:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T10")!)
            
        case 11:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T11")!)
        case 12:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T12")!)
        case 13:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T13")!)
        case 14:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T14")!)
        case 15:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T15")!)
        case 16:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T16")!)
        case 17:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "T17")!)
            
        default:
            print("tap")
            
        }
        
        
    }
}
