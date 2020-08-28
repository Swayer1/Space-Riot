//
//  MainMenuGuessLogin.swift
//  Space Riot
//
//  Created by alex on 27.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuGuessLogin: MainMenu{
    var playerProfileImage: SKSpriteNode?
    override init(size: CGSize) {
        super.init(size: size)
        print("* guessMainMenu")
        playerProfileImage = {
            var item = SKSpriteNode(texture: SKTexture(image: GuessLoginData.userPhoto))
            item.position = CGPoint(x: self.size.width * 0.12, y: self.size.height*0.93)
            item.setScale(5)
            item.zPosition = 1
            item.name = "playerProfileImageGuess"
            return item
        }()
        self.addChild(playerProfileImage!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("* MainMenuGuessLogin Deinit")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches{
            var pointOfTouch = touch.location(in: self)
            var nodeInTouch = nodes(at: pointOfTouch)
            for node in nodeInTouch{
                switch node.name {
                    case "playerProfileImageGuess":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {
                            Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: LogInScene.self, delay: 0)
                        })
                        break
                    default:
                        break
                }
            }
        }
    }
}
