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

    // on device database
    let defaults = UserDefaults()

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
    let SensibilityLabel: SKLabelNode
    let Music: SKCheckBox
    let MusicLabel: SKLabelNode
    let slider: SKSlider


    // purchase view
    let purchaseExitButton: SKLabelNode
    let purchaseWindow: SKSpriteNode
    let purchaseWindowLabel: SKLabelNode


    //    Actions
    let changeScaleUp = SKAction.scale(by: 0.8, duration: 0.1)
    let changeScaleDown = SKAction.scale(by: 1.25, duration: 0.1)
    var ButtonAction = SKAction()
    var changeScaleSequence = SKAction()

    // Custom elements

    class SKCheckBox: SKNode {
        let onSprite: SKSpriteNode
        let offSprite: SKSpriteNode
        var size: CGSize{
            willSet{
                onSprite.size = newValue
                offSprite.size = newValue
            }
        }

        override var zPosition: CGFloat{
            willSet{
                onSprite.zPosition = newValue
                offSprite.zPosition = newValue
            }
        }

        override var name: String?{
            willSet{
                onSprite.name = newValue
                offSprite.name = newValue
            }
        }

        var on: Bool{
            willSet{
                let scaleOut = SKAction.scale(to: 0, duration: 0.2)
                let scaleIn = SKAction.scale(to: 1, duration: 0.2)
                if(newValue){
                    offSprite.run(scaleOut)
                    onSprite.run(scaleIn)
                    GameViewController.instance.backingAudio.play()
                }
                else{
                    onSprite.run(scaleOut)
                    offSprite.run(scaleIn)
                    GameViewController.instance.backingAudio.stop()
                }
            }
        }

        override init() {
            onSprite = SKSpriteNode(imageNamed: "assets/optionView/Ok_BTN")
            offSprite = SKSpriteNode(imageNamed: "assets/optionView/Close_BTN")
            self.size = .zero
            self.on = true
            super.init()
            onSprite.zPosition = self.zPosition
            offSprite.zPosition = self.zPosition
            offSprite.setScale(0)
            self.addChild(onSprite)
            self.addChild(offSprite)
        }

        override var position: CGPoint{
            willSet{
                onSprite.position = newValue
                offSprite.position = newValue
            }
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }


    class SKSlider: SKNode {
        let table: SKSpriteNode        
        let piece: SKSpriteNode
        var size: CGSize{
            willSet{
                table.size.height = newValue.height
                table.size.width = newValue.width
                piece.size.height = newValue.height * 2
            }
        }
        override var zPosition: CGFloat{
            willSet{
                table.zPosition = self.zPosition
                piece.zPosition = self.zPosition + 1
            }
        }
        override var position: CGPoint{
            willSet{
                table.position = newValue
                piece.position = newValue
                piece.position.x = -198
            }
        }
        override init() {
            table = SKSpriteNode(imageNamed: "assets/Table")
            piece = SKSpriteNode(imageNamed: "assets/piece")
            self.size = .zero
            super.init()
            piece.position.x = -370
            table.position = self.position
            piece.position = self.position
            self.addChild(table)
            self.addChild(piece)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    override func didMove(to view: SKView) {
        loadUserOptions()
    }

    init(size: CGSize, form: String) {

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
        optionsWindow = SKSpriteNode(imageNamed: "assets/optionView/optionsWindow")
        exitButton = SKLabelNode()
        optionsWindowLabel = SKLabelNode()
        slider = SKSlider()
        Music = SKCheckBox()
        MusicLabel = SKLabelNode()
        SensibilityLabel = SKLabelNode()

        // purchase view
        purchaseExitButton = SKLabelNode()
        purchaseWindow = SKSpriteNode(imageNamed: "assets/purchaseView/purchaseWindow")
        purchaseWindowLabel = SKLabelNode()

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
        optionsWindow.zPosition = 2
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

        slider.position = CGPoint(x: 50, y: 155)
        slider.table.name = "sliderbar"
        slider.piece.name = "sliderbar piece"
        slider.size.width = 500
        slider.size.height = 40
        slider.zPosition = 2
        slider.setScale(1)

        SensibilityLabel.text = "Touch"
        SensibilityLabel.fontSize = 50
        SensibilityLabel.fontColor = SKColor.white
        SensibilityLabel.fontName = "AvenirNext-Bold"
        SensibilityLabel.zPosition = 2
        SensibilityLabel.position = CGPoint(x: -300, y: 290)

        MusicLabel.text = "Music"
        MusicLabel.fontSize = 50
        MusicLabel.fontColor = SKColor.white
        MusicLabel.fontName = "AvenirNext-Bold"
        MusicLabel.zPosition = 99
        MusicLabel.position = CGPoint(x: -300, y: 150)


        Music.name = "Music checkbox"
        Music.position = CGPoint(x: -60, y: 105)
        Music.zPosition = 2
        Music.setScale(0.5)

        // purchase view
        purchaseWindow.name = "Game options window"
        purchaseWindow.size.height = self.size.height * 0.48
        purchaseWindow.position = CGPoint(x: self.size.width*0.5, y: -self.size.height+purchaseWindow.size.height)
        purchaseWindow.zPosition = 2
        purchaseWindow.setScale(1.5)

        purchaseExitButton.text = "Back"
        purchaseExitButton.name = "purchase back"
        purchaseExitButton.fontSize = 70
        purchaseExitButton.fontColor = SKColor.white
        purchaseExitButton.fontName = "AvenirNext-Bold"
        purchaseExitButton.zPosition = 99
        purchaseExitButton.position = CGPoint(x: 0, y: -self.size.height*0.2)

        purchaseWindowLabel.text = "Purchase"
        purchaseWindowLabel.fontSize = 90
        purchaseWindowLabel.fontColor = SKColor.white
        purchaseWindowLabel.fontName = "AvenirNext-Bold"
        purchaseWindowLabel.zPosition = 99
        purchaseWindowLabel.position = CGPoint(x: 0, y: self.size.height*0.195)

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
        GameViewController.instance.bannerViewBottom.isHidden = false
    }

    func gameOverForm(){
        self.addChild(background)
        self.addChild(gameOverLabel)
        self.addChild(scoreLabel)
        self.addChild(highScoreLabel)
        self.addChild(restartLabel)
        GameViewController.instance.bannerViewBottom.isHidden = false
    }

    func gameOptions(){
        let scale = SKAction.moveTo(y: self.size.height*0.5, duration: 0.2)
        optionsWindow.addChild(optionsWindowLabel)
        optionsWindow.addChild(exitButton)
        optionsWindow.addChild(Music)
        optionsWindow.addChild(MusicLabel)
        optionsWindow.addChild(SensibilityLabel)
        optionsWindow.addChild(slider)
        self.addChild(optionsWindow)
        optionsWindow.run(scale)
    }

    func gamePurchaseWindows(){
        let scale = SKAction.moveTo(y: self.size.height*0.5, duration: 0.2)
        purchaseWindow.addChild(purchaseExitButton)
        purchaseWindow.addChild(purchaseWindowLabel)
        self.addChild(purchaseWindow)
        purchaseWindow.run(scale)
    }

    func convertStringtoDic(input: String) -> [String: String]{
        var array: [String: String] = [String: String]()
        for item in input.split(separator: ";"){
            array[String(item.split(separator: "=")[0])] = String(item.split(separator: "=")[1])
        }
        return array
    }

    func convertDicToString(dic: [String: String]) -> String{
        return dic.map { $0.0 + "=" + $0.1 }.joined(separator: ";")
    }

    func saveOptions(){
        userOptionsList.touchMultiplier = slider.piece.position
        userOptionsList.musicOn = Music.on
        let optionsData = convertDicToString(dic: userOptionsList.info)
        defaults.set(optionsData, forKey: "userOptionData")
        let scale = SKAction.moveTo(y: self.size.height+optionsWindow.size.height, duration: 0.2)
        let delete = SKAction.removeFromParent()
        let deleteChildren = SKAction.run{
            self.optionsWindow.removeAllChildren()
        }
        let deleteSequence = SKAction.sequence([scale, deleteChildren, delete])
        optionsWindow.run(deleteSequence)
    }

    func loadUserOptions(){
        let userOptions = defaults.string(forKey: "userOptionData")
        let userOptionsDic = convertStringtoDic(input: userOptions!)
        userOptionsList.touchMultiplier = NSCoder.cgPoint(for: userOptionsDic["TouchMultiplier"]!)
        userOptionsList.musicOn = Bool(userOptionsDic["MusicOn"]!)!
        slider.piece.position = userOptionsList.touchMultiplier
        Music.on = userOptionsList.musicOn
    }

    func exitPurchaseBack(){
        let scale = SKAction.moveTo(y: -self.size.height+purchaseWindow.size.height, duration: 0.2)
        let delete = SKAction.removeFromParent()
        let deleteChildren = SKAction.run{
            self.purchaseWindow.removeAllChildren()
        }
        let deleteSequence = SKAction.sequence([scale, deleteChildren, delete])
        purchaseWindow.run(deleteSequence)
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
                    GameViewController.instance.bannerViewBottom.isHidden = true
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
                    self.gamePurchaseWindows()
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
            else if(nodeITapped[0].name == "sliderbar"){
                let pointOfTouch = touch.location(in: slider)
                slider.piece.position.x = pointOfTouch.x
            }
            else if(nodeITapped[0].name == "Music checkbox"){
                Music.on = !Music.on
            }
            else if(nodeITapped[0].name == "Option save"){
                ButtonAction = SKAction.run{
                    self.saveOptions()
                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(nodeITapped[0].name == "purchase back"){
                ButtonAction = SKAction.run{
                    self.exitPurchaseBack()
                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(restartLabel.contains(pointOfTouch)){
                GameViewController.instance.bannerViewBottom.isHidden = true
                let sceneToMoveTo = GameScene.getInstance(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches{
            let pointOfTouch = touch.location(in: slider)
            if(slider.table.contains(pointOfTouch)){
                slider.piece.position.x = pointOfTouch.x
            }
        }
    }
}


struct userOptionsList {
    static var info: [String:String] = [String:String]()
    static var touchMultiplier: CGPoint = .zero{
        willSet{
            info["TouchMultiplier"] = NSCoder.string(for: newValue)
        }
    }
    static var musicOn: Bool = true{
        willSet{
            info["MusicOn"] = String(newValue)
        }
    }
}
