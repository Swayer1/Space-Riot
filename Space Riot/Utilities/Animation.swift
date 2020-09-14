//
//  Animations.swift
//  Space Riot
//
//  Created by alex on 12.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

struct Animations {
    
    static func ButtonClickAnimation(item: SKNode, action: SKAction){
        var changeScaleUp = SKAction.scale(by: 0.8, duration: 0.1)
        var changeScaleDown = SKAction.scale(by: 1.25, duration: 0.1)
        var ButtonAction = action
        var changeScaleSequence = SKAction.sequence([changeScaleUp, changeScaleDown, ButtonAction])
        item.run(changeScaleSequence)
    }
    
    static func changeSceneAnimationWithDelay(fromScene: SKScene, toScene: SKScene.Type, delay: TimeInterval? = 1){
        var wait = SKAction.wait(forDuration: delay!)
        var changeSence = SKAction.run {
            var sceneMoveTo = toScene.init(size: fromScene.size)
            sceneMoveTo.scaleMode = fromScene.scaleMode
            var myTransion = SKTransition.fade(withDuration: 0.5)
            fromScene.view!.presentScene(sceneMoveTo, transition: myTransion)
        }
        var actionSequence = SKAction.sequence([wait, changeSence])
        fromScene.run(actionSequence)        
    }                
}
