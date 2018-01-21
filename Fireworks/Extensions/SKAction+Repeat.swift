//
//  SKAction+Repeat.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/20/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import SpriteKit

extension SKAction {
    func repeated() -> SKAction {
        return SKAction.repeatForever(self)
    }
}
