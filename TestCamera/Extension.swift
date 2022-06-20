//
//  Extension.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

extension UIImage {
    
    func textToImage(drawText text: NSString, inImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let font = UIFont(name: "HelveticaNeue-Light", size: 60)! //DS-Digital
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let textColor = UIColor.systemOrange
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:textStyle, NSAttributedString.Key.foregroundColor:textColor]
        let textH = font.lineHeight
        let textX =  (image.size.width - textH) / 2.5
        let textY = (image.size.height - textH) / 1.03
        let textRect = CGRect(x: textX, y: textY, width: image.size.width, height: textH)
        text.draw(in: textRect.integral, withAttributes: attributes)
       let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func fixOrientation() -> UIImage {
        
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result!
        }
    }
    
    func scaleImage(toWidth newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)

        let renderer = UIGraphicsImageRenderer(size: newSize)

        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
        return image
    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? =  nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                padddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, bottomAnchor: NSLayoutYAxisAnchor? = nil,
                 paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let top = topAnchor {
            anchor(top: topAnchor, padddingTop: paddingTop)
        }
        
        if let bottom = bottomAnchor {
            anchor(bottom: bottomAnchor, paddingBottom: paddingBottom)
        }
    }
    
    func centerY(inView view: UIView, leftAncor: NSLayoutXAxisAnchor? = nil, rightAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0,constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAncor {
            anchor(left: leftAncor, paddingLeft: paddingLeft)
        }
        
        if let right = rightAnchor {
            anchor(right: rightAnchor, paddingRight: paddingRight)
        }
    }
}

extension CGSize {
    
    func applying(cgOrientation: CGImagePropertyOrientation) -> CGSize {
        switch cgOrientation {
        case .up, .upMirrored, .down, .downMirrored:
            return self
        case .left, .leftMirrored, .right, .rightMirrored:
            return .init(width: height, height: width)
        }
    }
    
}
