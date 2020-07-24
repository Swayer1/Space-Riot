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

//    main view
    let background: SKSpriteNode
    let gameName: SKSpriteNode
    let startGame: SKSpriteNode
    let facebookButton: SKSpriteNode
    let ranklistButton: SKSpriteNode
    let shopButton: SKSpriteNode
    let options: SKSpriteNode
    let credits: SKSpriteNode

//    restart view
    let gameOverLabel: SKLabelNode
    let scoreLabel: SKLabelNode
    let highScoreLabel: SKLabelNode
    let restartLabel: SKLabelNode

//    Option view
    let exitButton: SKLabelNode
    let optionsWindow: SKSpriteNode
    let optionsWindowLabel: SKLabelNode
    let slider: SKSlider

//    Actions
    let changeScaleUp = SKAction.scale(by: 0.8, duration: 0.1)
    let changeScaleDown = SKAction.scale(by: 1.25, duration: 0.1)
    var ButtonAction = SKAction()
    var changeScaleSequence = SKAction()

// Custom elements
    class SKSlider: SKNode {        
        override init() {
            let backgoround = SKSpriteNode(imageNamed: "assets/loadinbarempty")
            let backgoroundBorder = SKSpriteNode(imageNamed: "assets/loadinbarborder")
            let backgoroundFill = SKSpriteNode(imageNamed: "assets/loadinbarfinish")
            super.init()
            backgoround.position = self.position
            backgoround.anchorPoint = .zero
            backgoround.zPosition = self.zPosition
            backgoroundBorder.position = self.position
            backgoroundBorder.anchorPoint = .zero
            backgoroundBorder.zPosition = self.zPosition + CGFloat(2)
            backgoroundFill.position = self.position
            backgoroundFill.anchorPoint = .zero
            backgoroundFill.zPosition = self.zPosition + CGFloat(1)
            backgoroundFill.size.width *= 0.5
            self.addChild(backgoround)
            self.addChild(backgoroundBorder)
            self.addChild(backgoroundFill)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    init(size: CGSize, form: String) {

        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")

        if(gameScorePlayer > highScoreNumber){
            highScoreNumber = gameScorePlayer
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }

        //    main view
        background = SKSpriteNode(imageNamed: "Normal/background1")
        gameName = SKSpriteNode(imageNamed: "assets/name")
        startGame = SKSpriteNode(imageNamed: "assets/start")
        options = SKSpriteNode(imageNamed: "assets/settings")
        credits = SKSpriteNode(imageNamed: "assets/credits")
        facebookButton = SKSpriteNode(imageNamed: "assets/facebook")
        ranklistButton = SKSpriteNode(imageNamed: "assets/ranklist")
        shopButton = SKSpriteNode(imageNamed: "assets/shop")

        //    restart view
        gameOverLabel = SKLabelNode()
        scoreLabel = SKLabelNode()
        highScoreLabel = SKLabelNode()
        restartLabel = SKLabelNode()

        //    Option view
        optionsWindow = SKSpriteNode(imageNamed: "assets/optionsWindow")
        exitButton = SKLabelNode()
        optionsWindowLabel = SKLabelNode()
        slider = SKSlider()

        super.init(size: size)


        //    main view
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.setScale(1)
        background.size = self.size

        gameName.name = "Game name"
        gameName.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        gameName.zPosition = 1
        gameName.setScale(0.30)

        options.name = "Game options"
        options.position = CGPoint(x: self.size.width*0.87, y: self.size.height*0.92)
        options.zPosition = 1
        options.setScale(0.35)

        startGame.name = "Start Game"
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        startGame.zPosition = 1
        startGame.setScale(0.25)

        facebookButton.name = "facebook button"
        facebookButton.position = CGPoint(x: self.size.width*0.2, y: self.size.height*0.2)
        facebookButton.zPosition = 1
        facebookButton.setScale(0.35)

        ranklistButton.name = "ranklist button"
        ranklistButton.position = CGPoint(x: self.size.width*0.4, y: self.size.height*0.2)
        ranklistButton.zPosition = 1
        ranklistButton.setScale(0.35)

        shopButton.name = "shop button"
        shopButton.position = CGPoint(x: self.size.width*0.6, y: self.size.height*0.2)
        shopButton.zPosition = 1
        shopButton.setScale(0.35)

        credits.name = "Game credits"
        credits.position = CGPoint(x: self.size.width*0.8, y: self.size.height*0.2)
        credits.zPosition = 1
        credits.setScale(0.35)

        //    Option view
        optionsWindow.name = "Game options window"
        optionsWindow.size.height = self.size.height * 0.48
        optionsWindow.position = CGPoint(x: self.size.width*0.5, y: self.size.height+optionsWindow.size.height)
        optionsWindow.zPosition = 99
        optionsWindow.setScale(1.5)

        exitButton.text = "Save"
        exitButton.name = "Option save"
        exitButton.fontSize = 70
        exitButton.fontColor = SKColor.white
        exitButton.fontName = "AvenirNext-Bold"
        exitButton.zPosition = 99
        exitButton.position = CGPoint(x: 0, y: -self.size.height*0.2)

        optionsWindowLabel.text = "Options"
        optionsWindowLabel.fontSize = 90
        optionsWindowLabel.fontColor = SKColor.white
        optionsWindowLabel.fontName = "AvenirNext-Bold"
        optionsWindowLabel.zPosition = 99
        optionsWindowLabel.position = CGPoint(x: 0, y: self.size.height*0.195)

        slider.position = CGPoint(x: -409, y: 0)
        slider.zPosition = 99
        slider.setScale(0.2)

        //    restart view
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1

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
        self.addChild(facebookButton)
        self.addChild(ranklistButton)
        self.addChild(shopButton)
        self.addChild(credits)
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

    func gameOptions(){
        let scale = SKAction.moveTo(y: self.size.height*0.5, duration: 0.2)
        optionsWindow.addChild(optionsWindowLabel)
        optionsWindow.addChild(exitButton)
        optionsWindow.addChild(slider)
        self.addChild(optionsWindow)
        optionsWindow.run(scale)
    }

    func saveOptions(){
        let scale = SKAction.moveTo(y: self.size.height+optionsWindow.size.height, duration: 0.2)
        let delete = SKAction.removeFromParent()
        let deleteChildren = SKAction.run{
            self.optionsWindow.removeAllChildren()
        }
        let deleteSequence = SKAction.sequence([scale, deleteChildren, delete])
        optionsWindow.run(deleteSequence)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = nodes(at: pointOfTouch)
            if(nodeITapped[0].name == "Start Game"){
                ButtonAction = SKAction.run{
                    let sceneMoveTo = GameScene.getInstance(size: self.size)
                    sceneMoveTo.scaleMode = self.scaleMode
                    let myTransion = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneMoveTo, transition: myTransion)
                    GameViewController.bannerViewBottom.isHidden = true
                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(nodeITapped[0].name == "facebook button"){
                ButtonAction = SKAction.run{

                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(nodeITapped[0].name == "shop button"){
                ButtonAction = SKAction.run{

                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(nodeITapped[0].name == "ranklist button"){
                ButtonAction = SKAction.run{

                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(nodeITapped[0].name == "Game options"){
                ButtonAction = SKAction.run{
                    if(self.optionsWindow.position.y > self.size.height){
                        self.gameOptions()
                    }
                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(nodeITapped[0].name == "Game credits"){
                ButtonAction = SKAction.run{

                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(nodeITapped[0].name == "Option save"){
                ButtonAction = SKAction.run{
                    self.saveOptions()
                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
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
