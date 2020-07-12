//
//  Menu.swift
//  Corona shooter
//
//  Created by alex on 9.06.20.
//  Copyright © 2020 alex. All rights reserved.
//
// AdMob Home screen ad id: ca-app-pub-4381085821462829/9989967360
// AdMob Test id : ca-app-pub-3940256099942544/6300978111



import Foundation
import SpriteKit
import UIKit
import GoogleMobileAds
import FBSDKLoginKit

class Menu: SKScene{

    let background: SKSpriteNode
    let gameBy: SKLabelNode
    let gameName1: SKLabelNode
    let gameName2: SKLabelNode
    let startGame: SKLabelNode
    let gameOverLabel: SKLabelNode
    let scoreLabel: SKLabelNode
    let loginButton: FBLoginButton
    let highScoreLabel: SKLabelNode
    let restartLabel: SKLabelNode



    init(size: CGSize, form: String) {

        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")

        if(gameScorePlayer > highScoreNumber){
            highScoreNumber = gameScorePlayer
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }

        self.background = SKSpriteNode(imageNamed: "Normal/background1")
        self.gameBy = SKLabelNode()
        self.gameName1 = SKLabelNode()
        self.gameName2 = SKLabelNode()
        self.startGame = SKLabelNode()
        gameOverLabel = SKLabelNode()
        scoreLabel = SKLabelNode()
        loginButton = FBLoginButton()
        highScoreLabel = SKLabelNode()
        restartLabel = SKLabelNode()

        super.init(size: size)

        self.background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.background.zPosition = 0
        self.background.setScale(1)
        self.background.size = self.size

        self.gameBy.text = "Alex's production"
        self.gameBy.fontSize = 50
        self.gameBy.fontColor = SKColor.white
        self.gameBy.fontName = "AvenirNext-Bold"
        self.gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        self.gameBy.zPosition = 1

        self.gameName1.text = "Solo"
        self.gameName1.fontSize = 200
        self.gameName1.fontColor = SKColor.white
        self.gameName1.fontName = "AvenirNext-Bold"
        self.gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        self.gameName1.zPosition = 1

        self.gameName2.text = "Mission"
        self.gameName2.fontSize = 200
        self.gameName2.fontColor = SKColor.white
        self.gameName2.fontName = "AvenirNext-Bold"
        self.gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        self.gameName2.zPosition = 1

        self.startGame.text = "Start Game"
        self.startGame.name = "Start Game"
        self.startGame.fontSize = 150
        self.startGame.fontColor = SKColor.white
        self.startGame.fontName = "AvenirNext-Bold"
        self.startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        self.startGame.zPosition = 1

        self.gameOverLabel.text = "Game Over"
        self.gameOverLabel.fontSize = 200
        self.gameOverLabel.fontColor = SKColor.white
        self.gameOverLabel.fontName = "AvenirNext-Bold"
        self.gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        self.gameOverLabel.zPosition = 1

        scoreLabel.text = "Score: \(gameScorePlayer)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1

        loginButton.center = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)

        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)

        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.fontName = "AvenirNext-Bold"
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)

        switch form {
            case "welcome":
                welcomeForm()
            case "gameOver":
                gameOverForm()
            default:
                print("no such form")
                break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func welcomeForm(){
        self.addChild(background)
        self.addChild(gameBy)
        self.addChild(gameName1)
        self.addChild(gameName2)
        self.addChild(startGame)
    }

    func gameOverForm(){
        self.addChild(background)
        self.addChild(gameOverLabel)
        self.addChild(scoreLabel)
        self.addChild(highScoreLabel)
        self.addChild(restartLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = nodes(at: pointOfTouch)
            if(nodeITapped[0].name == "Start Game"){
                let sceneMoveTo = GameScene.GetInstance(InstanceSize: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransion = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneMoveTo, transition: myTransion)
            }
            else if(restartLabel.contains(pointOfTouch)){
                let sceneToMoveTo = GameScene.GetInstance(InstanceSize: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
