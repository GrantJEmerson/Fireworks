//
//  Country.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

struct Country {
    
    static let all = [
        Country(name: "United States", flag: #imageLiteral(resourceName: "United_States"),
                fact: "Annually on the 4th of July, the United States celebrates their independence from Britain in 1776. People gather together in crowds to watch fireworks and enjoy some time spent with their family and friends."),
        Country(name: "Japan", flag: #imageLiteral(resourceName: "Japan"), fact: ""),
        Country(name: "India", flag: #imageLiteral(resourceName: "India"), fact: ""),
        Country(name: "Singapore", flag: #imageLiteral(resourceName: "Singapore"), fact: ""),
        Country(name: "Peru", flag: #imageLiteral(resourceName: "Peru"), fact: ""),
        Country(name: "United Arab Emirates", flag: #imageLiteral(resourceName: "united-arab-emirates"), fact: ""),
        Country(name: "China", flag: #imageLiteral(resourceName: "China"), fact: ""),
        Country(name: "France", flag: #imageLiteral(resourceName: "France"), fact: ""),
        Country(name: "Hungary", flag: #imageLiteral(resourceName: "Hungary"), fact: ""),
        Country(name: "Malta", flag: #imageLiteral(resourceName: "Malta"), fact: ""),
        Country(name: "Switzerland", flag: #imageLiteral(resourceName: "Switzerland"), fact: ""),
        Country(name: "United Kingdom", flag: #imageLiteral(resourceName: "United_Kingdom"), fact: "")
    ]
    
    let name: String
    let flag: UIImage
    let fact: String
}
