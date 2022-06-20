//
//  LabelEffect.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import UIKit

struct LabelEffect {
let lightLeaksLabel: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.textColor = .white
    title.font = UIFont(name: "HelveticaNeue-Light", size: 12)
    title.textAlignment = .center
    title.text = "Light leaks"
    return title
}()

let texturesLabel: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.textColor = .white
    title.font = UIFont(name: "HelveticaNeue-Light", size: 12)
    title.textAlignment = .center
    title.text = "Textures"
    return title
}()

let dateLabel: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.textColor = .white
    title.font = UIFont(name: "HelveticaNeue-Light", size: 12)
    title.textAlignment = .center
    title.text = "Date"
    return title
}()

}
