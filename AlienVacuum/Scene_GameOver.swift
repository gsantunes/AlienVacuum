//
//  Scene_GameOver.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 23/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import SpriteKit
import GameController

public class Scene_GameOver : SKScene
{
    override public func didMoveToView(view: SKView)
    {
        let label = SKLabelNode(text: "Game Over")
        label.fontSize = 40
        
        label.position.x = CGRectGetMidX(self.frame)
        label.position.y = CGRectGetMidY(self.frame)
        
        addChild(label)
    }
}