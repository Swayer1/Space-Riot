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
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Log-in-Scene/title/SPACE_RIOT")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            item.setScale(3.8)
            item.zPosition = 1
            return item
        }()

        var gamePlayButton: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Play-button/play-button")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
            item.setScale(3.8)
            item.zPosition = 1
            return item
        }()
        
        var playerProfile: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/profile/Oval")
            item.position = CGPoint(x: self.size.width * 0.12, y: self.size.height*0.93)
            item.setScale(5)
            item.zPosition = 1
            return item
        }()
        
        var gameBar: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Empty-bar/bar")
            item.position = CGPoint(x: self.size.width/2, y: 0)
            item.size.width = self.size.width * 0.95
            item.size.height = self.size.height * 0.27
            item.zPosition = 1
            return item
        }()
        
        var shopCart: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Shop/Shopping")
            item.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            return item
        }()

        var videoAds: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Video/video-ad")
            item.position = CGPoint(x: self.size.width * 0.383, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            return item
        }()

        var leaderboard: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Ranking/ranking")
            item.position = CGPoint(x: self.size.width * 0.6163, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            return item
        }()

        var settings: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Settings/settings")
            item.position = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            return item
        }()

        self.addChild(background)
        self.addChild(gameTitle)
        self.addChild(gamePlayButton)
        self.addChild(playerProfile)
        self.addChild(gameBar)
        self.addChild(shopCart)
        self.addChild(videoAds)
        self.addChild(leaderboard)
        self.addChild(settings)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("* MainMenu Deinit")
    }
}
