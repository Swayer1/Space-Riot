//
//  GameScene.swift
//  Corona shooter
//
//  Created by alex on 9.06.20.
//  Copyright © 2020 alex. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import SKImport

var gameScorePlayer: Int = 0
var roundLabel: Int = 10

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static var instance: GameScene? = nil
    
    var encouragingPhrases: [String] = ["Good job", "O YEAH", "Nice", "Hmm Damnn", "Fire baby"]
    var scoreLabelPlayer = SKLabelNode()
    var player: SKSpriteNode = SKSpriteNode(imageNamed: "Normal/player")
    var timer: TimeInterval = 0
    var updateTimerAction = SKAction()
    var enemyCounterGuessMode: Int = 0
    var bulletSound = SKAction.playSoundFileNamed("torpedo", waitForCompletion: false)
    var enemyBulletSound = SKAction.playSoundFileNamed("torpedo", waitForCompletion: false)
    var enemyExplosionSound = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)
    var tapToStartGame = SKLabelNode()
    var repeatFire = SKAction()
    enum gameState {
        case preGame
        case inGame
        case afterGame
        case pauseGame
    }
    var currentGameState = gameState.preGame
    
    struct PhysicsCatecories {
        static var None: UInt32 = 0 // 0
        static var Player: UInt32 = 0b1 // 1
        static var Bullet: UInt32 = 0b10 // 2
        static var Enemy: UInt32 = 0b100 // 4
        static var ModeChangeItem: UInt32 = 0b0101 //5
        static var CleaningWave: UInt32 = 0b0110 //6
        static var enemyBullet: UInt32 = 0b0111 //7
    }

    static func getInstance(size: CGSize)->GameScene{
        if(instance == nil){
            instance = GameScene(size: size)
        }        
        return instance!
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func random(min: Int, max: Int) -> Int{
        return Int(random()) * (max - min) + min
    }
    
    var GameArea:CGRect
    
    override init(size: CGSize) {
		GameArea = CGRect(x: (player.frame.width * 0.2) / 2, y: 0, width: size.width - (player.frame.width * 0.2), height: size.height)
		super.init(size:size)
		scene?.name = "GameScene"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {                
        
        gameScorePlayer = 0
        updateTimerAction = SKAction.sequence([ 
            SKAction.run(updateTimer),
            SKAction.wait(forDuration: 1.0)
        ])
        
        GameMode.modeChangeLoopCounter = 0
        
        GameMode.mode = "Normal"
        
        var callFunction = SKAction.run({self.fireBullet()})
        var fireWait = SKAction.wait(forDuration: 0.2)
        var fireSequence = SKAction.sequence([callFunction, fireWait])
        repeatFire = SKAction.repeatForever(fireSequence)
        
        self.physicsWorld.contactDelegate = self
        var background1 = SKSpriteNode(imageNamed: "Normal/background1")
        background1.size = self.size
        background1.anchorPoint = CGPoint(x: 0.5, y: 0)
        background1.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(0))
        background1.zPosition = 0
        background1.name = "Background"
        self.addChild(background1)
        var background2 = SKSpriteNode(imageNamed: "Normal/background2")
        background2.size = self.size
        background2.anchorPoint = CGPoint(x: 0.5, y: 0)
        background2.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(1))
        background2.zPosition = 0
        background2.name = "Background"
        self.addChild(background2)
        
        scoreLabelPlayer.text = "Score: 0"
        scoreLabelPlayer.fontSize = 70
        scoreLabelPlayer.fontColor = SKColor.white
        scoreLabelPlayer.fontName = "AvenirNext-Bold"
        scoreLabelPlayer.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabelPlayer.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabelPlayer.frame.size.height)
        scoreLabelPlayer.zPosition = 100
        self.addChild(scoreLabelPlayer)
        var moveOnToTheScreen = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        scoreLabelPlayer.run(moveOnToTheScreen)
        
        player = SKSpriteNode(imageNamed: "Normal/player")
        player.name = "Player"
        player.setScale(5)
        player.position = CGPoint(x: self.size.width/2, y:  self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/player", ofType: "json"))
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCatecories.Player
        player.physicsBody!.collisionBitMask = PhysicsCatecories.None
        player.physicsBody!.contactTestBitMask = PhysicsCatecories.Enemy
        self.addChild(player)
        
        tapToStartGame.text = "Tap to start game"
        tapToStartGame.fontSize = 100
        tapToStartGame.fontColor = SKColor.white
        tapToStartGame.fontName = "AvenirNext-Bold"
        tapToStartGame.zPosition = 1
        tapToStartGame.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartGame.alpha = 0
        self.addChild(tapToStartGame)
        var fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartGame.run(fadeInAction)
        
        startGame()
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = CGFloat(1650.0 / GameMode.gameSpeed)
    
    override func update(_ currentTime: TimeInterval) {
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        var amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if(self.currentGameState == gameState.inGame){
                background.position.y -= amountToMoveBackground
            }
            
            if(background.position.y < -self.size.height){
                background.position.y += self.size.height*2
            }
        }
        if(currentGameState == gameState.inGame){
            for child in self.children{
                child.speed = GameMode.nodeSpeed
            }
            self.action(forKey: "spawningEnemies")?.speed = GameMode.nodeSpeed
            self.action(forKey: "modeTimer")?.speed = GameMode.nodeSpeed
        }
    }
    
    func updateTimer(){
        timer += 1
        if(timer == 10){
            var specialItem = SKSpriteNode(imageNamed: "specialElements/vortex")
            specialItem.name = "SpecialItem"
            specialItem.zPosition = 2
            specialItem.setScale(8)
            specialItem.physicsBody = SKPhysicsBody(circleOfRadius: specialItem.size.width/3)
            specialItem.physicsBody!.affectedByGravity = false
            specialItem.physicsBody!.categoryBitMask = PhysicsCatecories.ModeChangeItem
            specialItem.physicsBody!.collisionBitMask = PhysicsCatecories.None
            specialItem.physicsBody!.contactTestBitMask = PhysicsCatecories.Player
            specialItem.position = CGPoint(x: self.size.width/2, y: self.size.height + specialItem.frame.height)
            self.addChild(specialItem)
            var moveToBottom = SKAction.moveTo(y: -specialItem.frame.height, duration: 5)
            specialItem.run(moveToBottom)
            timer = 0
        }
    }
    
    func startGameModeTimer() {
        timer = 0
        self.run(SKAction.repeatForever(updateTimerAction), withKey: "modeTimer")
    }
    
    func stopGameTimer() {
        removeAction(forKey: "modeTimer")
    }
    
    func startGame(){
        tapToStartGame.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run {self.player.run(SKAction.sequence([
                SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
            ]))},
            SKAction.removeFromParent(),
            SKAction.run {
                self.currentGameState = gameState.inGame
                self.ChouseNewMode()
            }
        ]))
    }
    
    func clearGameScene( _ item: SKNode){
        if(self.action(forKey: "fireBullets") != nil){
            self.removeAction(forKey: "fireBullets")
        }
        GameMode.changeMode = true
        var wave = SKSpriteNode(imageNamed: "specialElements/wave")
        wave.name = "Wave"
        wave.zPosition = 1
        wave.setScale(1)
        wave.position = item.position
        item.removeFromParent()
        wave.physicsBody = SKPhysicsBody(circleOfRadius: wave.size.width * 0.60, center: CGPoint(x: 0, y: -wave.size.height * 0.49))
        wave.physicsBody!.affectedByGravity = false
        wave.physicsBody!.categoryBitMask = PhysicsCatecories.CleaningWave
        wave.physicsBody!.collisionBitMask = PhysicsCatecories.None
        wave.physicsBody!.contactTestBitMask = PhysicsCatecories.Enemy
        self.addChild(wave)
        var moveToScale = SKAction.scale(to: (self.size.width / wave.frame.width) * 1.4, duration: 0.3)
        var movetoY = SKAction.moveTo(y: self.size.height + wave.frame.height, duration: 3)
        var delete = SKAction.removeFromParent()
        var stopSceneActions = SKAction.run(stopGameForeverRepeats)
        var startSceneActions = SKAction.run(ChouseNewMode)
        var specialItemSequence = SKAction.sequence([moveToScale, movetoY, stopSceneActions, delete, startSceneActions])
        wave.run(specialItemSequence)
    }
    
    func ChouseNewMode(){
        if(GameMode.currentLevelNumber == 3){
            GameMode.currentLevelNumber = 0
        }
        else{
            GameMode.currentLevelNumber += 1
        }
        if(self.currentGameState == gameState.inGame){
            switch GameMode.currentLevelNumber{
                case 0:
                    self.normalMode()
                case 1:
                    self.guessMode()
                case 2:
                    self.mirrorMode()
                case 3:
                    self.pandemicMode()
                default:
                    break
            }
        }
    }
    
    
    func pandemicMode(){
        var modeName = SKLabelNode()
        modeName.text = "PANDEMIC MODE"
        modeName.fontSize = 100
        modeName.fontColor = SKColor.white
        modeName.fontName = "AvenirNext-Bold"
        modeName.zPosition = 100
        modeName.setScale(1)
        modeName.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(modeName)
        modeName.run(SKAction.sequence([
            SKAction.scale(to:(self.size.width / modeName.frame.width) * 0.90, duration: 0.3),
            SKAction.wait(forDuration: 1),
            SKAction.scale(to: 0, duration: 0.3)
        ]))
        GameMode.mode = "Pandemic"
        GameMode.modeScore = 2
        GameMode.enemyScale = 4
        GameMode.bulletScale = 1
        GameMode.spawnEnemyDelay = 0.3
        GameMode.BodyCenterPointPercentage = 0
        startNewLevel()
    }
    
    
    func guessMode(){
        var modeName = SKLabelNode()
        modeName.text = "GUESS MODE"
        modeName.fontSize = 100
        modeName.fontColor = SKColor.white
        modeName.fontName = "AvenirNext-Bold"
        modeName.zPosition = 100
        modeName.setScale(1)
        modeName.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(modeName)
        modeName.run(SKAction.sequence([
            SKAction.scale(to:(self.size.width / modeName.frame.width) * 0.90, duration: 0.3),
            SKAction.wait(forDuration: 1),
            SKAction.scale(to: 0, duration: 0.3)
        ]))
        GameMode.modeScore = 0
        GameMode.enemyScale = 5
        GameMode.bulletScale = 3
        GameMode.mode = "Guess"
        GameMode.BodyCenterPointPercentage = 0
        GameMode.spawnEnemyDelay = 0.5
        startNewLevel()
    }
    
    
    func mirrorMode(){
        var modeName = SKLabelNode()
        modeName.text = "MIRROR MODE"
        modeName.fontSize = 100
        modeName.fontColor = SKColor.white
        modeName.fontName = "AvenirNext-Bold"
        modeName.zPosition = 100
        modeName.setScale(1)
        modeName.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(modeName)
        modeName.run(SKAction.sequence([
            SKAction.scale(to:(self.size.width / modeName.frame.width) * 0.90, duration: 0.3),
            SKAction.wait(forDuration: 1),
            SKAction.scale(to: 0, duration: 0.3)
        ]))
        GameMode.modeScore = 0
        GameMode.enemyScale = 5
        GameMode.bulletScale = 2
        GameMode.spawnEnemyDelay = 0.3
        GameMode.mode = "Mirror"
        GameMode.BodyCenterPointPercentage = 0
        startNewLevel()
    }
    
    func normalMode(){
        var modeName = SKLabelNode()
        modeName.text = "NORMAL MODE"
        modeName.fontSize = 100
        modeName.fontColor = SKColor.white
        modeName.fontName = "AvenirNext-Bold"
        modeName.zPosition = 100
        modeName.setScale(1)
        modeName.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(modeName)
        modeName.run(SKAction.sequence([
            SKAction.scale(to:(self.size.width / modeName.frame.width) * 0.90, duration: 0.3),
            SKAction.wait(forDuration: 1),
            SKAction.scale(to: 0, duration: 0.3)
        ]))
        GameMode.modeScore = 1
        GameMode.enemyScale = 5
        GameMode.bulletScale = 3
        GameMode.spawnEnemyDelay = 0.3
        GameMode.mode = "Normal"
        GameMode.BodyCenterPointPercentage = 0
        startNewLevel()
    }
    
    func addScore( _ amount:Int? = GameMode.modeScore){
        gameScorePlayer += amount!
        if(gameScorePlayer % 30 == 0){
            var EncourageLabel = SKLabelNode()
            EncourageLabel.text = encouragingPhrases.randomElement()
            EncourageLabel.fontSize = 100
            EncourageLabel.fontColor = SKColor.white
            EncourageLabel.fontName = "AvenirNext-Bold"
            EncourageLabel.zPosition = 100
            EncourageLabel.setScale(1)
            EncourageLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            self.addChild(EncourageLabel)
            EncourageLabel.run(SKAction.sequence([
                SKAction.scale(to:(self.size.width / EncourageLabel.frame.width) * 0.90, duration: 0.3),
                SKAction.wait(forDuration: 1),
                SKAction.scale(to: 0, duration: 0.3)
            ]))
        }
        scoreLabelPlayer.text = "Score: \(gameScorePlayer)"
    }
    
	func runGameOver(){
        if GameViewController.instance.interstitial.isReady {
            GameViewController.instance.interstitial.present(fromRootViewController: GameViewController.instance)
        } else {
            
        }
        currentGameState = gameState.afterGame
        GameMode.gameSpeed = 2.75
        stopGameForeverRepeats()
        stopGameTimer()
        self.removeAllActions()
        self.removeAllChildren()
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Player"){
            player, stop in
            player.removeAllActions()
        }
        self.enumerateChildNodes(withName: "fireBullets"){
            player, stop in
            player.removeAllActions()
        }
        self.enumerateChildNodes(withName: "modeTimer"){
            player, stop in
            player.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Background"){
            player, stop in
            player.removeAllActions()
        }
		Utilities.determentLogin(self)
        GameViewController.instance.loadAds()		
    }
    
    func stopGameForeverRepeats(){
        if(self.action(forKey: "spawningEnemies") != nil){
            self.removeAction(forKey: "spawningEnemies")
        }
    }
    
    func runGameForeverRepeats(){
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run({self.spawnEnemy()}),
                    SKAction.wait(forDuration: GameMode.spawnEnemyDelay)
                ])
        ), withKey: "spawningEnemies")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if(body1.categoryBitMask == PhysicsCatecories.Player && body2.categoryBitMask == PhysicsCatecories.Enemy){
            if(body1.node != nil){
                playerExplosion(body1.node!.position)
            }
            if(body2.node != nil){
                playerExplosion(body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            roundLabel -= 1
            runGameOver()
        }
        if(body1.categoryBitMask == PhysicsCatecories.Player && body2.categoryBitMask == PhysicsCatecories.enemyBullet){
            if(body1.node != nil){
                playerExplosion(body1.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            roundLabel -= 1
            runGameOver()
        }
        if(body1.node !=  nil && body2.node != nil){
            if(body1.categoryBitMask == PhysicsCatecories.Bullet && body2.categoryBitMask == PhysicsCatecories.Enemy && (body2.node!.position.y + body2.node!.frame.height) < self.size.height){
                if(GameMode.mode == "Guess"){
                    switch body2.node?.name! {
                        case "EnemyBlue":
                            enemyFireGuessMode(body2.node!.position)
                            addScore(1)
                        case "EnemyRed":
                            addScore(-2)
                        case "EnemyGreen":
                            addScore(1)
                        default:
                            addScore(1)
                    }
                }
                else{
                    addScore(1)
                }
                if(body2.node != nil){
                    spawnExplosion(body2.node!)
                }
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
            }
        }
        if(body1.categoryBitMask == PhysicsCatecories.Player && body2.categoryBitMask == PhysicsCatecories.ModeChangeItem){
            clearGameScene(body2.node!)
            GameMode.modeChangeLoopCounter += 1
        }
        if(body1.categoryBitMask == PhysicsCatecories.Enemy && body2.categoryBitMask == PhysicsCatecories.CleaningWave){
            if(body1.node != nil){
                spawnExplosion(body1.node!)
                body1.node!.removeFromParent()
            }
        }
        if(body1.categoryBitMask == PhysicsCatecories.CleaningWave && body2.categoryBitMask == PhysicsCatecories.enemyBullet){
            body2.node!.removeFromParent()
        }
    }
    
    func spawnExplosion(_ Enemy: SKNode){
        Enemy.isPaused = true
        var explosion = SKSpriteNode(imageNamed: "\(GameMode.mode)/enemyDeath")
        explosion.name = "explosion"
        var scaleTo: CGFloat = 0
        var scaleDuration: TimeInterval = 0
        explosion.position = Enemy.position
        explosion.zPosition = 3
        switch GameMode.mode {
            case "Guess":
                explosion.setScale(0)
                scaleTo = 8
                scaleDuration = 0.3
            case "Pandemic":
                explosion.setScale(4)
                scaleTo = 0
                scaleDuration = 1
            case "Mirror":
                explosion.setScale(0)
                scaleTo = 8
                scaleDuration = 0.3
            case "Normal":
                explosion.setScale(0)
                scaleTo = 6
                scaleDuration = 0.3
            default:
                break
        }
        self.addChild(explosion)
        var scaleOut = SKAction.scale(to: scaleTo, duration: scaleDuration)
        var delete = SKAction.removeFromParent()
        var explosionSequence = SKAction.sequence([enemyExplosionSound, scaleOut, delete])
        explosion.run(explosionSequence)
    }
    
    func playerExplosion(_ spawnPosition: CGPoint){
        var explosion = SKSpriteNode(imageNamed: "\(GameMode.mode)/playerDeath")
        explosion.name = "explosion"
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(5)
        self.addChild(explosion)
        var scaleOut = SKAction.scale(to: 0, duration: 1)
        var delete = SKAction.removeFromParent()
        var explosionSequence = SKAction.sequence([enemyExplosionSound, scaleOut, delete])
        explosion.run(explosionSequence)
    }
    
    func startNewLevel(){
        if(GameMode.gameSpeed < 1.5){
            GameMode.gameSpeed = 1.5
        }
        else{
            GameMode.gameSpeed -= 0.25
        }
        GameMode.changeMode = false
        stopGameForeverRepeats()
        runGameForeverRepeats()
        startGameModeTimer()
    }
    
    func fireBullet(){
        var bullet = SKSpriteNode(imageNamed: "\(GameMode.mode)/bullet")
        bullet.name = "Bullet"
        bullet.setScale(GameMode.bulletScale)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/playerbullet", ofType: "json"))
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCatecories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCatecories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCatecories.Enemy
        self.addChild(bullet)
        bullet.position = player.position
        bullet.run(SKAction.sequence([
            bulletSound,
            SKAction.moveTo(y: (self.size.height + bullet.size.height), duration: GameMode.gameSpeed),
            SKAction.removeFromParent(),
            SKAction.wait(forDuration: 0.1)
        ]))
    }
    
    func spawnEnemyGuessMode(){
        switch GameMode.guessModeEnemyTypes[enemyCounterGuessMode] {
            case 0:
                guessEnemyTypeBlue()
            case 1:
                guessEnemyTypeRed()
            case 2:
                guessEnemyTypeGreen()
            default:
                guessEnemyTypeGreen()
        }
        if(enemyCounterGuessMode >= GameMode.guessModeEnemyTypes.count - 1){
            enemyCounterGuessMode = 0
        }
        else{
            enemyCounterGuessMode += 1
        }
    }
    
    func guessEnemyTypeBlue(){
        var randomXStart = random(min: GameArea.minX, max: GameArea.maxX)
        var randomXEnd = random(min: GameArea.minX, max: GameArea.maxX)
        var enemy = SKSpriteNode(imageNamed: "\(GameMode.mode)/enemy")
        enemy.name = "EnemyBlue"
        enemy.setScale(GameMode.enemyScale)        
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/enemy", ofType: "json"))
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCatecories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatecories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCatecories.Player | PhysicsCatecories.Bullet
        var startPoint = CGPoint(x: randomXStart, y: (GameArea.maxY + enemy.size.height))
        var endPoint = CGPoint(x: randomXEnd, y: 0 - enemy.size.height)
        enemy.position = startPoint
        self.addChild(enemy)
        if(currentGameState == gameState.inGame){
            enemy.run(SKAction.sequence([
                SKAction.move(to: endPoint, duration: GameMode.gameSpeed),
                SKAction.removeFromParent()
            ]))
        }
    }
    
    func guessEnemyTypeRed(){
        var randomXStart = random(min: GameArea.minX, max: GameArea.maxX)
        var randomXEnd = random(min: GameArea.minX, max: GameArea.maxX)
        var enemy = SKSpriteNode(imageNamed: "\(GameMode.mode)/enemyRed")
        enemy.name = "EnemyRed"
        enemy.setScale(GameMode.enemyScale)
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/enemy", ofType: "json"))
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCatecories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatecories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCatecories.Player | PhysicsCatecories.Bullet
        var startPoint = CGPoint(x: randomXStart, y: (GameArea.maxY + enemy.size.height))
        var endPoint = CGPoint(x: randomXEnd, y: 0 - enemy.size.height)
        enemy.position = startPoint
        self.addChild(enemy)
        if(currentGameState == gameState.inGame){
            enemy.run(SKAction.sequence([
                SKAction.move(to: endPoint, duration: GameMode.gameSpeed),
                SKAction.removeFromParent()
            ]))
        }
    }
    
    func guessEnemyTypeGreen(){
        var randomXStart = random(min: GameArea.minX, max: GameArea.maxX)
        var randomXEnd = random(min: GameArea.minX, max: GameArea.maxX)
        var enemy = SKSpriteNode(imageNamed: "\(GameMode.mode)/enemyGreen")
        enemy.name = "EnemyGreen"
        enemy.setScale(GameMode.enemyScale)
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/enemy", ofType: "json"))
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCatecories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatecories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCatecories.Player | PhysicsCatecories.Bullet
        var startPoint = CGPoint(x: randomXStart, y: (GameArea.maxY + enemy.size.height))
        var endPoint = CGPoint(x: randomXEnd, y: 0 - enemy.size.height)
        enemy.position = startPoint
        self.addChild(enemy)
        if(currentGameState == gameState.inGame){
            enemy.run(SKAction.sequence([
                SKAction.move(to: endPoint, duration: GameMode.gameSpeed),
                SKAction.removeFromParent()
            ]))
        }
    }
    
    func spawnEnemyNormalMode(){
        var randomXStart = random(min: GameArea.minX, max: GameArea.maxX)
        var randomXEnd = random(min: GameArea.minX, max: GameArea.maxX)
        var enemy = SKSpriteNode(imageNamed: "\(GameMode.mode)/enemy")
        enemy.name = "Enemy"
        enemy.setScale(GameMode.enemyScale)
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/enemy", ofType: "json"))
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCatecories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatecories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCatecories.Player | PhysicsCatecories.Bullet
        var startPoint = CGPoint(x: randomXStart, y: (GameArea.maxY + enemy.size.height))
        var endPoint = CGPoint(x: randomXEnd, y: 0 - enemy.size.height)
        enemy.position = startPoint
        var dx = endPoint.x - startPoint.x
        var dy = endPoint.y - startPoint.y
        var amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate
        self.addChild(enemy)
        if(currentGameState == gameState.inGame){
            enemy.run(SKAction.sequence([
                SKAction.move(to: endPoint, duration: GameMode.gameSpeed),
                SKAction.removeFromParent()
            ]))
        }
    }
    
    func spawnEnemyPandemicMode(){
        var randomXStart = random(min: GameArea.minX, max: GameArea.maxX)
        var randomXEnd = random(min: GameArea.minX, max: GameArea.maxX)
        var enemy = SKSpriteNode(imageNamed: "\(GameMode.mode)/enemy")
        enemy.name = "Enemy"
        enemy.setScale(GameMode.enemyScale)
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/enemy", ofType: "json"))
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCatecories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatecories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCatecories.Player | PhysicsCatecories.Bullet
        var startPoint = CGPoint(x: randomXStart, y: (GameArea.maxY + enemy.size.height))
        var endPoint = CGPoint(x: randomXEnd, y: 0 - enemy.size.height)
        enemy.position = startPoint
        self.addChild(enemy)
        if(currentGameState == gameState.inGame){
            enemy.run(SKAction.sequence([
                SKAction.move(to: endPoint, duration: GameMode.gameSpeed),
                SKAction.removeFromParent()
            ]))
        }
    }
    
    func spawnEnemyMirrorMode(){
        var randomX = random(min: GameArea.minX, max: GameArea.maxX)
        var randomType = Int.random(in: 1 ... 4)
        var randomSize = CGFloat.random(in: 5 ... 8)
        var meteor = SKSpriteNode(imageNamed: "\(GameMode.mode)/meteor\(randomType)")
        meteor.setScale(randomSize)
        meteor.position = CGPoint(x: randomX, y: self.size.height + meteor.frame.height)
        meteor.zPosition = 2
        meteor.name = "Enemy"
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 3.2)
        meteor.physicsBody!.affectedByGravity = false
        meteor.physicsBody!.categoryBitMask = PhysicsCatecories.Enemy
        meteor.physicsBody!.collisionBitMask = PhysicsCatecories.None
        meteor.physicsBody!.contactTestBitMask = PhysicsCatecories.Player | PhysicsCatecories.Bullet
        self.addChild(meteor)
        var moveOnScreen = SKAction.moveTo(y: -meteor.frame.height, duration: GameMode.gameSpeed)
        var addScoreAction = SKAction.run{self.addScore(1)}
        var delete = SKAction.removeFromParent()
        var meteorSequence = SKAction.sequence([moveOnScreen, addScoreAction, delete])
        meteor.run(meteorSequence)
    }
    
    func spawnEnemy(){
        switch GameMode.mode {
            case "Guess":
                spawnEnemyGuessMode()
            case "Pandemic":
                spawnEnemyPandemicMode()
            case "Mirror":
                spawnEnemyMirrorMode()
            case "Normal":
                spawnEnemyNormalMode()
            default:
                spawnEnemyNormalMode()
        }
    }
    
    func enemyFireGuessMode(_ position: CGPoint){
        var bullet = SKSpriteNode(imageNamed: "\(GameMode.mode)/enemyBackFire")
        bullet.name = "Bullet"
        bullet.setScale(GameMode.bulletScale + 2)
        bullet.position = position
        bullet.zPosition = 2
        bullet.physicsBody = SKPhysicsBody(file: Bundle.main.path(forResource: "\(GameMode.mode)/enemybullet", ofType: "json"))
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCatecories.enemyBullet
        bullet.physicsBody!.collisionBitMask = PhysicsCatecories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCatecories.Player
        self.addChild(bullet)
        bullet.run(SKAction.sequence([
            enemyBulletSound,
            SKAction.moveTo(y: -bullet.size.height, duration: 0.363636 * GameMode.gameSpeed),
            SKAction.removeFromParent()
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(GameMode.speedMode && currentGameState == gameState.inGame && !GameMode.adsMode){
            GameMode.nodeSpeed = 1
            GameMode.speedMode = false
        }
        
        if(currentGameState == gameState.inGame && GameMode.mode != "Mirror" && !GameMode.adsMode && !GameMode.changeMode){
            self.run(repeatFire, withKey: "fireBullets")
        }
        for touch: AnyObject in touches{
            var pointOfTouch = touch.location(in: self)
            _ = nodes(at: pointOfTouch)
        }
        if(currentGameState == gameState.preGame){
            startGame()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.action(forKey: "fireBullets") != nil){
            self.removeAction(forKey: "fireBullets")
        }
        if(!GameMode.speedMode && currentGameState == gameState.inGame && !GameMode.adsMode){
            GameMode.nodeSpeed = 0.2
            GameMode.speedMode = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var verticalUpLimit = GameArea.maxY - player.frame.height
        var verticalDownLimit = GameArea.minY + player.frame.height
        
        for touch:AnyObject in touches{
            var pointOfTouch = touch.location(in: self)
            var pointOfPreviousTouch = touch.previousLocation(in: self)
			var amountXDragged = (pointOfTouch.x - pointOfPreviousTouch.x) * (MainMenu.instance!.userSets.TouchSensibilityMultiplier ?? 1)
			var amountYDragged = (pointOfTouch.y - pointOfPreviousTouch.y) * (MainMenu.instance!.userSets.TouchSensibilityMultiplier ?? 1)
            if(currentGameState == gameState.inGame && !GameMode.adsMode){
                switch GameMode.mode {
                    case "Mirror":
                        player.position.x -= amountXDragged
                        player.position.y -= amountYDragged
                    default:
                        player.position.x += amountXDragged
                        player.position.y += amountYDragged
                }
                if(player.position.x > GameArea.maxX){
                    player.position.x = GameArea.maxX
                }
                if(player.position.x < GameArea.minX){
                    player.position.x = GameArea.minX
                }
                if(player.position.y > verticalUpLimit){
                    player.position.y = verticalUpLimit
                }
                if(player.position.y < verticalDownLimit){
                    player.position.y = verticalDownLimit
                }
            }
        }
    }
}

class GameMode{
    static var currentLevelNumber: Int = -1
    static var modeChangeLoopCounter: Int = 0
    static var speedMode: Bool = false
    static var changeMode: Bool = false
    static var adsMode: Bool = false
    static var mode: String = ""
    static var modeScore: Int = 0
    static var enemyScale: CGFloat = 0
    static var bulletScale: CGFloat = 0
    static var BodyCenterPointPercentage: CGFloat = 0
    static var guessModeEnemyTypes: [Int] = [0,2,2,1,0,1,2,0,0,2]
    static var spawnEnemyDelay: TimeInterval = 0.3
    static var gameSpeed: TimeInterval = 2.75
    static var nodeSpeed: CGFloat = 1
    static var showAds: Bool = false
}
