//
//  MainMenu.swift
//  Space Riot
//
//  Created by alex on 12.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

/*
 level in UI view class
 0 - background
 1 - everything on the background / bottom menu
 2 - icons on the bottom menu, menu windows
 3 - everything in the menu window
 4 - everything in the inner windows
 */

import Foundation
import SpriteKit
import FirebaseFirestore

class MainMenu: SKScene {
    static var instance: MainMenu?

	var userSets = userOptionsList()

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
    var gameBarMenuWindow: SKSpriteNode?
    var innerWindow: SKSpriteNode?
    var titleinnerWindow: SKSpriteNode?
    var backButton: SKSpriteNode?
    var movingObject: SKSpriteNode?
    var cropObject: SKCropNode?
    var testInnerWindow: SKShapeNode?

	static func getInstance(size: CGSize) -> MainMenu{
		if(instance == nil){
			instance = MainMenu(size: size)
		}
		return instance!
	}

	func saveUserDataToFireBase() {
		var ref: DocumentReference? = nil
		ref = db.collection("users").addDocument(data: [
			"FullName" : FacebookLoginData.fullName,
			"Email" : FacebookLoginData.email,
		]) {
			err in if let err = err {
				print("error adding document")
			} else {
				print("document loaded succesfully")
			}
		}
	}

    override init(size: CGSize) {
        super.init(size: size)

		// save to google firebase storage

		saveUserDataToFireBase()

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

        gameBar = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Empty-bar/bar")
            item.position = CGPoint(x: self.size.width/2, y: 0)
            item.size.width = self.size.width * 0.95
            item.size.height = self.size.height * 0.27
            item.setScale(1)
            item.zPosition = 10
            return item
        }()

        playerProfileRing = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/profile/Oval")
            item.position = CGPoint(x: self.size.width * 0.12, y: self.size.height*0.93)
            item.setScale(4.5)
            item.zPosition = gameBar!.zPosition + 1
            item.name = "playerProfileRing"
            return item
        }()

        shopCart = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Shop/Shopping")
            item.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = gameBar!.zPosition + 1
            item.name = "shopCart"
            return item
        }()

        videoAds = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Video/video-ad")
            item.position = CGPoint(x: self.size.width * 0.383, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = gameBar!.zPosition + 1
            item.name = "videoAds"
            return item
        }()

        leaderboard = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Ranking/ranking")
            item.position = CGPoint(x: self.size.width * 0.6163, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = gameBar!.zPosition + 1
            item.name = "leaderboard"
            return item
        }()

        settings = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Main-Menu/Bar/Icon-Settings/settings")
            item.position = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.065)
            item.setScale(self.size.width * 0.0025)
            item.zPosition = gameBar!.zPosition + 1
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
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit{

    }

    func showMenuWindows(item: SKNode){
        for node in self.children {
            if(node.name != nil){
                if(node.name!.contains("Window")){
                    node.removeFromParent()
                }
            }
        }
        Utilities.AddChild(scene: self, item: item)
    }

    func clearMenuWindows(){
        for node in self.children {
            if(node.name != nil){
                if(node.name!.contains("Window")){
                    node.removeFromParent()
                }
            }
        }
    }

    func shoppingCart(){
        gameBarMenuWindow = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Window-shop/windows/window")
            item.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - self.size.height * 0.025)
            item.size = CGSize(width: self.size.width * 0.99, height: self.size.height * 0.7)
            item.setScale(1)
            item.zPosition = 2
            item.name = "shopCart Window"
            return item
        }()

        backButton = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Window-shop/buttons/back")
            item.setScale(5)
            item.position = CGPoint(x: -gameBarMenuWindow!.size.width * 0.48 + item.size.width, y: gameBarMenuWindow!.size.height * 0.48 - item.size.height)
            item.zPosition = 3
            item.name = "back button Window"
            return item
        }()

        innerWindow = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Window-shop/windows/Inner-window")
            item.setScale(3)
            item.size = CGSize(width: gameBarMenuWindow!.size.width * 0.9, height: gameBarMenuWindow!.size.height * 0.8)
            item.position = CGPoint(x: 0, y: -35)
            item.zPosition = 3
            item.name = "inner Window"
            return item
        }()

        titleinnerWindow = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Window-shop/Text-icon/Text-icon")
            item.setScale(1.5)
            item.position = CGPoint(x: 0, y: innerWindow!.size.height * 0.125)
            item.zPosition = 4
            item.name = "title inner Window"
            return item
        }()

        testInnerWindow = {
            var item = SKShapeNode(rectOf: CGSize(width: (innerWindow!.size.width * 0.85) / (innerWindow!.xScale), height: (innerWindow!.size.height * 0.67) / (innerWindow!.xScale)))
            item.position = CGPoint(x: -1, y: innerWindow!.position.y * 1.4)
            item.fillColor = .black
            item.zPosition = 4
            return item
        }()

        movingObject = {
            var item = SKSpriteNode()
            item.size = testInnerWindow!.frame.size
            item.size.height = testInnerWindow!.frame.size.height * 2
            item.position = testInnerWindow!.position
            item.position.y = testInnerWindow!.frame.height + testInnerWindow!.position.y
            item.name = "movingObject"
            item.color = .black
            return item
        }()

        cropObject = {
            var item = SKCropNode()
            item.position = CGPoint(x: 0, y: 0)
            item.addChild(movingObject!)
            item.maskNode = testInnerWindow!
            return item
        }()

        innerWindow!.addChild(cropObject!)
        innerWindow!.addChild(titleinnerWindow!)
        gameBarMenuWindow!.addChild(innerWindow!)
        gameBarMenuWindow!.addChild(backButton!)
        showMenuWindows(item: gameBarMenuWindow!)
    }

    func LeaderBoardMenu(){

        gameBarMenuWindow = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Window-ranking/Facebook/Window/big-window")
            item.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - self.size.height * 0.015)
            item.size = CGSize(width: self.size.width * 0.99, height: self.size.height * 0.7)
            item.setScale(1)
            item.zPosition = 2
            item.name = "LeaderBoard Window"
            item.action(forKey: "testAction")
            return item
        }()
        showMenuWindows(item: gameBarMenuWindow!)
    }

    func SettingsMenu(){
        gameBarMenuWindow = {
            var item = SKSpriteNode(imageNamed: "Space-Riot-Assets/Window-settings/windows/Window-settings")
            item.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - self.size.height * 0.015)
            item.size = CGSize(width: self.size.width * 0.99, height: self.size.height * 0.7)
            item.setScale(1)
            item.zPosition = 2
            item.name = "Setting Window"
            return item
        }()
        showMenuWindows(item: gameBarMenuWindow!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard var touch = touches.first else {return}
        var pointOfTouch = touch.location(in: self)
        var frontTouchNode = atPoint(pointOfTouch)
        switch frontTouchNode.name {
            case "shopCart":
                Animations.ButtonClickAnimation(item: frontTouchNode, action: SKAction.run {
                    self.shoppingCart()
                })
                break
            case "back button Window":
                Animations.ButtonClickAnimation(item: frontTouchNode, action: SKAction.run {
                    self.clearMenuWindows()
                })
                break
            case "videoAds":4
                Animations.ButtonClickAnimation(item: frontTouchNode, action: SKAction.run {

                })
                break
            case "leaderboard":
                Animations.ButtonClickAnimation(item: frontTouchNode, action: SKAction.run {
                    self.LeaderBoardMenu()
                })
                break
            case "settings":
                Animations.ButtonClickAnimation(item: frontTouchNode, action: SKAction.run {
                    self.SettingsMenu()
                })
                break
            case "gamePlayButton":
                Animations.ButtonClickAnimation(item: frontTouchNode, action: SKAction.run {
					var sceneMoveTo = GameScene.getInstance(size: self.size)
					sceneMoveTo.scaleMode = self.scaleMode
					var myTransion = SKTransition.fade(withDuration: 0.5)
					self.view!.presentScene(sceneMoveTo, transition: myTransion)  
                })
                break
            case "playerProfileImage":
                Animations.ButtonClickAnimation(item: frontTouchNode, action: SKAction.run {
                    GameViewController.instance.loginButton.sendActions(for: .touchUpInside)
                })
                break
            default:
                break
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(innerWindow != nil){
            for touch in touches{
                var previousToch = touch.previousLocation(in: innerWindow!)
                var location = touch.location(in: innerWindow!)
                var distanceY = location.y - previousToch.y
                var limit = testInnerWindow!.position.y
                var MovingObjY = movingObject!.position.y
                movingObject!.run(SKAction.moveBy(x: .zero , y: distanceY, duration: 0.3))
            }
        }
    }
}

class userOptionsList: Codable {
	var TouchSensibilityPosition: CGPoint?
	var TouchSensibilityMultiplier: CGFloat?
	var Music: Bool?
	var loginFacebook: Bool?
}
