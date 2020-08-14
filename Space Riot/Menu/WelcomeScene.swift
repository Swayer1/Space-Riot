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
            var item = SKSpriteNode(imageNamed: "Space Riot Assets/Welcome-Scene/start screen")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            var scaleFactor = (self.size.height/item.size.height)
            item.setScale(scaleFactor)
            item.zPosition = 0
            return item
        }()
        self.addChild(background)
//        Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: LogInScene.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("* welcomeScene deinit")
    }
    
    override func didMove(to view: SKView) {        
        Animations.ButtonClickAnimation(item: self, action: SKAction.run {
            switch GameViewController.instance.loginType {
                case 0:
                    Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: LogInScene.self, delay: 1)
                    break
                case 1:
                    GameViewController.instance.getFacebookLoginData()
                    Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: MainMenu.self, delay: 1)
                    break
                case 2:
                    break
                default:
                break
            }
        })
    }
}
