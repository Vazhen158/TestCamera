//
//  DateLabel.swift
//  TestCamera
//
//  Created by Андрей Важенов on 21.06.2022.
//

import UIKit

struct DateLabel {
    
    let noDateLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        title.textAlignment = .center
        title.text = "No date"
        return title
    }()
    
    
    let todayLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        title.textAlignment = .center
        title.text = "Today"
        return title
    }()
    
    let customDateLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        title.textAlignment = .center
        title.text = "Custom"
        return title
    }()
    
    
}


