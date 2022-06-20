//
//  CellEffect.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

struct effectCell {
    let name: String?
    let imageCell: UIImage?
    
  static func imageWithView(view: UIView) -> UIImage? {
       UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    
}
