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
    static var instance: MainMenu?
    var background: SKSpriteNode?
    var bottomSpace: CGFloat?
    var gameBar: SKSpriteNode?
    var shopCart: SKSpriteNode?
    var videoAds: SKSpriteNode?
    var leaderboard: SKSpriteNode?
    var settings: SKSpriteNode?
    var gameTitle: SKSpriteNode?
    var gamePlayButton: SKSpriteNode?
    var playerProfileRing: SKSpriteNode?
    var playerProfileImage: SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        MainMenu.instance = self
        background = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Background/background5down")
            item.anchorPoint = self.anchorPoint
            item.size = self.size
            item.zPosition = 0
            return item
        }()
        
        gameTitle = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Log-in-Scene/title/SPACE_RIOT")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            item.setScale(3.8)
            item.zPosition = 1
            return item
        }()

        gamePlayButton = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Play-button/play-button")
            item.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
            item.setScale(3.8)
            item.zPosition = 1
            item.name = "gamePlayButton"
            return item
        }()
        
        playerProfileRing = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/profile/Oval")
            item.position = CGPoint(x: self.size.width * 0.12, y: self.size.height*0.93)
            item.setScale(5)
            item.zPosition = 1
            item.name = "playerProfileRing"
            return item
        }()
        
        playerProfileImage = {
            var item = SKSpriteNode(texture: SKTexture(image: FacebookLoginData.maskRoundedImage(image: FacebookLoginData.userPhoto!, radius: FacebookLoginData.userPhoto!.size.width/2)))
            item.position = CGPoint(x: self.size.width * 0.12, y: self.size.height*0.93)
            item.setScale(1)
            item.zPosition = 2
            item.name = "playerProfileImage"
            return item
        }()
        
        gameBar = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Empty-bar/bar")
            item.position = CGPoint(x: self.size.width/2, y: 0)
            item.size.width = self.size.width * 0.95
            item.size.height = self.size.height * 0.27
            item.zPosition = 1
            return item
        }()
        
        shopCart = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Shop/Shopping")
            item.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            item.name = "shopCart"
            return item
        }()

        videoAds = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Video/video-ad")
            item.position = CGPoint(x: self.size.width * 0.383, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            item.name = "videoAds"
            return item
        }()

        leaderboard = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Ranking/ranking")
            item.position = CGPoint(x: self.size.width * 0.6163, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            item.name = "leaderboard"
            return item
        }()

        settings = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Settings/settings")
            item.position = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = 2
            item.name = "settings"
            return item
        }()

        self.addChild(background!)
        self.addChild(gameTitle!)
        self.addChild(gamePlayButton!)
        self.addChild(playerProfileRing!)
        self.addChild(gameBar!)
        self.addChild(shopCart!)
        self.addChild(videoAds!)
        self.addChild(leaderboard!)
        self.addChild(settings!)
        self.addChild(playerProfileImage!)
        MoveMeniBar(space: 200)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("* MainMenu Deinit")
    }
    
    func MoveMeniBar(space: CGFloat){
        if(GameViewController.instance.bannerViewBottom.isDescendant(of: GameViewController.instance.view)){
            bottomSpace = bottomSpace == nil ? space : 0
            gameBar!.position.y += bottomSpace!
            gamePlayButton!.position.y = ((gameTitle!.position.y - gameTitle!.size.height/2) - (gameBar!.position.y + gameBar!.size.height/2))/2 + (gameBar!.position.y + gameBar!.size.height/2)
            shopCart!.position.y += bottomSpace!
            videoAds!.position.y += bottomSpace!
            leaderboard!.position.y += bottomSpace!
            settings!.position.y += bottomSpace!
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            var pointOfTouch = touch.location(in: self)
            var nodeInTouch = nodes(at: pointOfTouch)
            for node in nodeInTouch{
                switch node.name {
                    case "shopCart":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {
                            
                        })
                        break
                    case "videoAds":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {
                            
                        })
                        break
                    case "leaderboard":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {

                        })
                        break
                    case "settings":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {
                            
                        })
                        break
                    case "gamePlayButton":
                        Animations.ButtonClickAnimation(item: node, action: SKAction.run {
                            
                        })
                        break
                    case "playerProfileImage":
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
