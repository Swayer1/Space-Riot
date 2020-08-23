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
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Background/background5down")
            item.anchorPoint = self.anchorPoint
            item.size = self.size
            item.zPosition = 0
            return item
        }()
        
        var gameTitle: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Game-name/title")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            item.setScale(6)
            item.zPosition = 1
            return item
        }()
        
        var gamePlayButton: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Play-button/play-button")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.5)
            item.setScale(3)
            item.zPosition = 1
            return item
        }()
        
        var playerProfile: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/profile/Oval")
            item.position = CGPoint(x: self.size.width * 0.15, y: self.size.height*0.9)
            item.setScale(6)
            item.zPosition = 1
            return item
        }()
        
        self.addChild(background)
        self.addChild(gameTitle)
        self.addChild(gamePlayButton)
        self.addChild(playerProfile)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("* MainMenu Deinit")
    }
}
