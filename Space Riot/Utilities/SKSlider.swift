//
//  SKSlider.swift
//  Space Riot
//
//  Created by alex on 10.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import SpriteKit

class SKSlider: SKNode {
    var table: SKSpriteNode
    var piece: SKSpriteNode
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
