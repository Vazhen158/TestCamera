//
//  CollectionCellEffect.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

class CollectionCellFilter: UICollectionViewCell {
    
    static let identifier = "CategoryViewCell"

    lazy var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1079640165, green: 0.1179675236, blue: 0.1687111855, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabelTwo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupConstraints()
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                imageView.layer.borderWidth = 2
                imageView.layer.cornerRadius = 12
                imageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                imageView.layer.cornerRadius = 12
                imageView.layer.borderWidth = 2
                imageView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews(){
        addSubview(categoryView)
        
        categoryView.addSubview(imageView)
        categoryView.addSubview(countLabel)
        categoryView.addSubview(countLabelTwo)
    }
    
    func setupConstraints(){
        
        imageView.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: categoryView.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: -30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        countLabel.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: -10).isActive = true
        countLabel.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor).isActive = true
        
        countLabelTwo.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        countLabelTwo.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        categoryView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        categoryView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func configureTwo(with category: effectCell){
        countLabelTwo.text = category.name
        imageView.image = category.imageCell
    }
    
}

