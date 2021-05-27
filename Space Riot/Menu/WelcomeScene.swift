//
//  WelcomeScene.swift
//  Space Riot
//
//  Created by alex on 12.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

class WelcomeScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        var background: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Welcome-Scene/start screen")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            var scaleFactor = (self.size.height/item.size.height)
            item.setScale(scaleFactor)
            item.zPosition = 0
            return item
        }()
        self.addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        
    }

	override func didMove(to view: SKView) {
		Utilities.determentLogin(self)
    }
}
