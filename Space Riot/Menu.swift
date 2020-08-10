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
    
    static var instance: Menu!
    
    // on device database
    var defaults = UserDefaults()
    var userSets = userOptionsList()
    
    // user options
    var UserOps: userOptionsList
    
    //    main view
    var background: SKSpriteNode
    var gameName: SKSpriteNode
    var startGame: SKSpriteNode
    var facebookButton: SKSpriteNode
    var ranklistButton: SKSpriteNode
    var shopButton: SKSpriteNode
    var options: SKSpriteNode
    var credits: SKSpriteNode
    
    //    restart view
    var gameOverLabel: SKLabelNode
    var scoreLabel: SKLabelNode
    var highScoreLabel: SKLabelNode
    var restartLabel: SKLabelNode
    
    //    Option view
    var exitButton: SKLabelNode
    var optionsWindow: SKSpriteNode
    var optionsWindowLabel: SKLabelNode
    var SensibilityLabel: SKLabelNode
    var Music: SKCheckBox
    var MusicLabel: SKLabelNode
    var slider: SKSlider
    
    
    // purchase view
    var purchaseExitButton: SKLabelNode
    var purchaseWindow: SKSpriteNode
    var purchaseWindowLabel: SKLabelNode
    
    
    //    Actions
    var changeScaleUp = SKAction.scale(by: 0.8, duration: 0.1)
    var changeScaleDown = SKAction.scale(by: 1.25, duration: 0.1)
    var ButtonAction = SKAction()
    var changeScaleSequence = SKAction()
    
    override func didMove(to view: SKView) {
        Menu.instance = self
        loadUserSettings()
    }
    
    init(size: CGSize, form: String) {
        
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if(gameScorePlayer > highScoreNumber){
            highScoreNumber = gameScorePlayer
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        // game options object
        
        UserOps = userOptionsList()
        
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
        var scale = SKAction.moveTo(y: self.size.height*0.5, duration: 0.2)
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
        var scale = SKAction.moveTo(y: self.size.height*0.5, duration: 0.2)
        var testItem = SKSpriteNode(imageNamed: "assets/optionView/Close_BTN")
        testItem.name = "testItem"
        testItem.position = CGPoint.zero
        testItem.zPosition = 2
        purchaseWindow.addChild(purchaseExitButton)
        purchaseWindow.addChild(purchaseWindowLabel)
        purchaseWindow.addChild(testItem)
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
    
    func loadUserSettings(){
        if var userData = UserDefaults.standard.data(forKey: "UserSettings"),
            var userLoadedSets = try? JSONDecoder().decode(userOptionsList.self, from: userData) {
            slider.piece.position = userLoadedSets.TouchSensibilityPosition!            
            Music.on = userLoadedSets.Music!
            userSets.TouchSensibilityMultiplier = userLoadedSets.TouchSensibilityMultiplier!
            userSets.Music = Music.on
        }
    }
    
    func saveOptions(){
        userSets.TouchSensibilityPosition = slider.piece.position
        userSets.TouchSensibilityMultiplier = (convert(slider.piece.position, from: slider).x - (slider.piece.size.width + slider.table.size.height))/454
        userSets.Music = Music.on
        if var encoded = try? JSONEncoder().encode(userSets) {
            UserDefaults.standard.set(encoded, forKey: "UserSettings")
        }
        var scale = SKAction.moveTo(y: self.size.height+optionsWindow.size.height, duration: 0.2)
        var delete = SKAction.removeFromParent()
        var deleteChildren = SKAction.run{
            self.optionsWindow.removeAllChildren()
        }
        var deleteSequence = SKAction.sequence([scale, deleteChildren, delete])
        optionsWindow.run(deleteSequence)
    }
    
    func exitPurchaseBack(){
        var scale = SKAction.moveTo(y: -self.size.height+purchaseWindow.size.height, duration: 0.2)
        var delete = SKAction.removeFromParent()
        var deleteChildren = SKAction.run{
            self.purchaseWindow.removeAllChildren()
        }
        var deleteSequence = SKAction.sequence([scale, deleteChildren, delete])
        purchaseWindow.run(deleteSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            var pointOfTouch = touch.location(in: self)
            var nodeITapped = nodes(at: pointOfTouch)
            if(nodeITapped[0].name == "Start Game"){
                ButtonAction = SKAction.run{
                    var sceneMoveTo = GameScene.getInstance(size: self.size)
                    sceneMoveTo.scaleMode = self.scaleMode
                    var myTransion = SKTransition.fade(withDuration: 0.5)
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
                var pointOfTouch = touch.location(in: slider)
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
            else if(nodeITapped[0].name == "testItem"){
                ButtonAction = SKAction.run{
                    //                    self.exitPurchaseBack()
                }
                changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
                nodeITapped[0].run(changeScaleSequence)
            }
            else if(restartLabel.contains(pointOfTouch)){
                GameViewController.instance.bannerViewBottom.isHidden = true
                var sceneToMoveTo = GameScene.getInstance(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                var myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches{
            var pointOfTouch = touch.location(in: slider)
            if(slider.table.contains(pointOfTouch)){
                slider.piece.position.x = pointOfTouch.x
            }
        }
    }
}

class userOptionsList: Codable {
    var TouchSensibilityPosition: CGPoint?
    var TouchSensibilityMultiplier: CGFloat?
    var Music: Bool?
}
