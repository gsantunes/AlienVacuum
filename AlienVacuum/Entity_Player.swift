//
//  Entity_Player.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 16/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import SpriteKit

public class Entity_Player : SKSpriteNode
{
    deinit
    {
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
    }
    
    public static let DIRECTION_UP = 0
    public static let DIRECTION_DOWN = 1
    public static let DIRECTION_LEFT = 2
    public static let DIRECTION_RIGHT = 3
    
    var mapX:Int!
    var mapY:Int!
    
    //0-up 1-down 2-left 3-right
    var direction:Int!
}
