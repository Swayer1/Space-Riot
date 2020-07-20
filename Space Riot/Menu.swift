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

class Menu: SKScene {

    let background: SKSpriteNode
    let gameName: SKSpriteNode
    let startGame: SKSpriteNode
    let options: SKSpriteNode
    let gameOverLabel: SKLabelNode
    let scoreLabel: SKLabelNode
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
        self.gameName = SKSpriteNode(imageNamed: "assets/name")
        self.startGame = SKSpriteNode(imageNamed: "assets/start")
        self.options = SKSpriteNode(imageNamed: "assets/settings")
        gameOverLabel = SKLabelNode()
        scoreLabel = SKLabelNode()
        highScoreLabel = SKLabelNode()
        restartLabel = SKLabelNode()

        super.init(size: size)

        self.background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.background.zPosition = 0
        self.background.setScale(1)
        self.background.size = self.size

        self.gameName.name = "Game name"
        self.gameName.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        self.gameName.zPosition = 1
        self.gameName.setScale(0.30)

        self.options.name = "Game name"
        self.options.position = CGPoint(x: self.size.width*0.87, y: self.size.height*0.92)
        self.options.zPosition = 1
        self.options.setScale(0.30)

        self.startGame.name = "Start Game"
        self.startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        self.startGame.zPosition = 1
        self.startGame.setScale(0.25)

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
        self.addChild(gameName)
        self.addChild(startGame)
        self.addChild(options)
        GameViewController.bannerViewBottom.isHidden = false
    }

    func gameOverForm(){
        self.addChild(background)
        self.addChild(gameOverLabel)
        self.addChild(scoreLabel)
        self.addChild(highScoreLabel)
        self.addChild(restartLabel)
        GameViewController.bannerViewBottom.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = nodes(at: pointOfTouch)
            if(nodeITapped[0].name == "Start Game"){
                GameViewController.bannerViewBottom.isHidden = true
                let sceneMoveTo = GameScene.getInstance(size: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransion = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneMoveTo, transition: myTransion)
            }
            else if(restartLabel.contains(pointOfTouch)){
                GameViewController.bannerViewBottom.isHidden = true
                let sceneToMoveTo = GameScene.getInstance(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
