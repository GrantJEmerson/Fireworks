//
//  Firework.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/19/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

struct Firework {
    
    static let defaultSet = [
        Firework(name: "Classic", thumbNailImage: #imageLiteral(resourceName: "ClassicFireworkThumbnail")),
        Firework(name: "Crackle", thumbNailImage: #imageLiteral(resourceName: "CrackleFireworkThumbnail")),
        Firework(name: "BigO", thumbNailImage: #imageLiteral(resourceName: "BigOFireworkThumbnail")),
        Firework(name: "RapidFire", thumbNailImage: #imageLiteral(resourceName: "RapidFireFireworkThumbnail"))
    ]
    
    let name: String
    let thumbNailImage: UIImage
}
