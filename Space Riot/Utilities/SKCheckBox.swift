//
//  SKCheckBox.swift
//  Space Riot
//
//  Created by alex on 10.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

class SKCheckBox: SKNode {
    var onSprite: SKSpriteNode
    var offSprite: SKSpriteNode
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
            var scaleOut = SKAction.scale(to: 0, duration: 0.2)
            var scaleIn = SKAction.scale(to: 1, duration: 0.2)
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
