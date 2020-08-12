//
//  MainMenu.swift
//  Space Riot
//
//  Created by alex on 12.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        var background: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space Riot Assets/Main-Menu/Background/background5down")
            item.anchorPoint = self.anchorPoint
            item.size = self.size
            item.zPosition = 0
            return item
        }()
        
        self.addChild(background)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("* MainMenu Deinit")
    }
}
