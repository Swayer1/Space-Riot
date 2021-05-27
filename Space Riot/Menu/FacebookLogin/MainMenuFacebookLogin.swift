//
//  MainMenuFacebookLogin.swift
//  Space Riot
//
//  Created by alex on 27.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuFacebookLogin: MainMenu{
    var playerProfileImage: SKSpriteNode?
    override init(size: CGSize) {        
        super.init(size: size)
        playerProfileImage = {
            var item = SKSpriteNode(texture: SKTexture(image: FacebookLoginData.userPhoto!))
            item.position = CGPoint(x: self.size.width * 0.12, y: self.size.height*0.93)
            item.setScale(1)
            item.zPosition = 1
            item.name = "playerProfileImageFacebook"
            return item
        }()
        self.addChild(playerProfileImage!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches{
            var pointOfTouch = touch.location(in: self)
            var nodeInTouch = nodes(at: pointOfTouch)
            for node in nodeInTouch{
                switch node.name {
                    case "playerProfileImageFacebook":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {
                            GameViewController.instance.loginButton.sendActions(for: .touchUpInside)                            
                        })
                        break
                    default:
                        break
                }
            }
        }
    }

}
