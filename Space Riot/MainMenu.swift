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

class LoginWindow: SKScene{
    
    override init(size: CGSize) {
        super.init(size: size)
        print("test init LoginWindow")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("test deinit LoginWindow")
    }
    
    override func didMove(to view: SKView) {
                        
        scene?.name = "LoginWindow"
        
        let background = SKSpriteNode(imageNamed: "Normal/background1")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.setScale(1)
        background.size = self.size
        self.addChild(background)
        
        let gameBy = SKLabelNode()
        gameBy.text = "Alex's production"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.white
        gameBy.fontName = "AvenirNext-Bold"
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        let gameName1 = SKLabelNode()
        gameName1.text = "Solo"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.white
        gameName1.fontName = "AvenirNext-Bold"
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode()
        gameName2.text = "Mission"
        gameName2.fontSize = 200
        gameName2.fontColor = SKColor.white
        gameName2.fontName = "AvenirNext-Bold"
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        let startGame = SKLabelNode()
        startGame.text = "Start Game"
        startGame.name = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = SKColor.white
        startGame.fontName = "AvenirNext-Bold"
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        startGame.zPosition = 1
        self.addChild(startGame)
        
        let loginButton = FBLoginButton()        
        loginButton.center = view.center
        if(GameMode.showAds){
            loginButton.isHidden = false
        }
        else{
            loginButton.isHidden = true
        }
        view.addSubview(loginButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = nodes(at: pointOfTouch)
            if(nodeITapped[0].name == "Start Game"){
//                let sceneMoveTo = GameScene(size: self.size)
                let sceneMoveTo = GameScene.GetInstance(InstanceSize: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransion = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneMoveTo, transition: myTransion)                
            }
        }
    }
}
