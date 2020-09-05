//
//  WelcomeScene.swift
//  Space Riot
//
//  Created by alex on 12.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit
import Reachability

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
        print("* welcomeScene deinit")
    }
    
    override func didMove(to view: SKView) {
        var defaults = UserDefaults()
        var loginType = defaults.integer(forKey: "loginType")
        switch loginType {
            case 0:
                Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: LogInScene.self, delay: 1)
                break
            case 1:
                let reachability = try! Reachability()
                if reachability.isReachable {
                    GameViewController.instance.getFacebookLoginData()
                }
                Utilities.LoadFacebookDataToDevice()
                Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: MainMenuFacebookLogin.self, delay: 1)
                break
            case 2:
                Animations.changeSceneAnimationWithDelay(fromScene: self, toScene: MainMenuGuessLogin.self, delay: 1)
                break
            default:
                break
        }
    }
}
