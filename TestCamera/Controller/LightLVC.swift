//
//  LightLVC.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

class LightLVC: UIViewController, UIGestureRecognizerDelegate {
    
    private var auxiliaryFilterButton = AuxiliaryButton()
    
    var imageLeaks: UIImage?
    
    var updateLightLeaksImageDelegate: UpdateImage?
    
    var imageViewLightL: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -1
        return image
    }()

    lazy var leaksArray = [
        effectCell(name: "No Effect", imageCell: nil),
        effectCell(name: nil, imageCell: UIImage(named: "LL1")),
        effectCell(name: nil, imageCell: UIImage(named: "LL2")),
        effectCell(name: nil, imageCell: UIImage(named: "LL3")),
        effectCell(name: nil, imageCell: UIImage(named: "LL4")),
        effectCell(name: nil, imageCell: UIImage(named: "LL5")),
        effectCell(name: nil, imageCell: UIImage(named: "LL6")),
        effectCell(name: nil, imageCell: UIImage(named: "LL7")),
        effectCell(name: nil, imageCell: UIImage(named: "LL8")),
        effectCell(name: nil, imageCell: UIImage(named: "LL9")),
        effectCell(name: nil, imageCell: UIImage(named: "LL10")),
        effectCell(name: nil, imageCell: UIImage(named: "LL11")),
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
        let correctImage = imageLeaks?.fixOrientation()
        imageViewLightL.image = correctImage
        view.addSubview(collectionView)
        view.addSubview(imageViewLightL)
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
        if leaksArray.count > 0 {
            selectedFilter = leaksArray[0]
        }
    }
    
    
    @objc func filterSaveButtonTap() {
        let alert = UIAlertController(title: "Attention", message: "Save photo to gallery?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { alert in
            UIImageWriteToSavedPhotosAlbum(self.imageViewLightL.image!, nil, nil, nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @objc func filterBackButtonTap() {
        updateLightLeaksImageDelegate?.update(image: imageViewLightL.image)
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
        imageViewLightL.image = UIImage(cgImage: newCGImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        imageViewLightL.contentMode = .scaleAspectFit
        
    }
    
    
    func setConsrtraints() {
        
        NSLayoutConstraint.activate([
            
            imageViewLightL.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageViewLightL.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewLightL.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewLightL.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
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

extension LightLVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leaksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: CollectionCellFilter.identifier,
                                 for: indexPath) as? CollectionCellFilter
        else {
            return UICollectionViewCell()
        }
        
        cell.configureTwo(with: leaksArray[indexPath.item])
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilter = leaksArray[indexPath.row]
        guard  let image1 = imageLeaks?.fixOrientation().scaleImage(toWidth: 1300) else {return}
        switch indexPath.row {
        case 0:
            imageViewLightL.image = image1
        case 1:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL1")!)
        case 2:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL2")!)
        case 3:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL3")!)
        case 4:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL4")!)
        case 5:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL5")!)
        case 6:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL6")!)
        case 7:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL7")!)
        case 8:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL8")!)
        case 9:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL9")!)
        case 10:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL10")!)
            
        case 11:
            applyTexture(originalImage: image1, textureImage: UIImage(named: "LL11")!)
            
        default:
            print("tap")
            
        }
        
        
    }
}
