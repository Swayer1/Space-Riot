//
//  LogInScene.swift
//  Space Riot
//
//  Created by alex on 12.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

class LogInScene: SKScene {
    static var instance: LogInScene?
    override init(size: CGSize) {
        super.init(size: size)
        var background: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Log-in-Scene/background/background5down")
            item.anchorPoint = self.anchorPoint
            item.size = self.size
            item.zPosition = 0
            return item
        }()
        
        var facebookButton: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Log-in-Scene/buttons/Facebook/facebook")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
            item.name = "facebookButton"
            item.setScale(3.8)
            item.zPosition = 1
            return item
        }()

        var guessButton: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Log-in-Scene/buttons/Guest/guest_button")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
            item.name = "guessButton"
            item.setScale(3.8)
            item.zPosition = 1
            return item
        }()

        var gameTitle: SKSpriteNode = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Log-in-Scene/title/SPACE_RIOT")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            item.setScale(3.8)
            item.zPosition = 1
            return item
        }()
        
        self.addChild(background)
        self.addChild(facebookButton)
        self.addChild(guessButton)
        self.addChild(gameTitle)
        
        LogInScene.instance = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("* loginForm Deinit")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            var pointOfTouch = touch.location(in: self)
            var nodeInTouch = nodes(at: pointOfTouch)
            for node in nodeInTouch{
                switch node.name {
                    case "facebookButton":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {                            
                            GameViewController.instance.loginButton.sendActions(for: .touchUpInside)
                        })
                        break
                    case "guessButton":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {
                            self.GuestLogin()
                            LogInScene.instance = nil
                        })
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func GuestLogin(){
        GameViewController.instance.loginType = 2
        Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: MainMenu.self, delay: 0)
    }
}
