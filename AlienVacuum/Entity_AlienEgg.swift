
//
//  Entity_AlienEgg.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 16/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import SpriteKit

public class Entity_AlienEgg : SKSpriteNode
{
    deinit
    {
        eggEclodeCount = 100
        self.texture = nil
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
    }
    
    var mapX:Int!
    var mapY:Int!
    var eggEclodeCount = 8
    var destroy = false
    var timer:Double = 0
    
    public func updateEgg(delta: CFTimeInterval)
    {
        timer += Double(delta)
        if(timer > 1)
        {
            timer = 0
            addEclode()
        }
    }
    
    func addEclode()
    {
        eggEclodeCount -= 1
        switch (eggEclodeCount)
        {
        case 0:
            eclodeEgg()
            break;
            
        case 2:
            self.color = UIColor.redColor()
            self.colorBlendFactor = 0.45
            break;
            
        case 4:
            self.color = UIColor.orangeColor()
            self.colorBlendFactor = 0.45
            break;
            
        case 6:
            self.color = UIColor.brownColor()
            self.colorBlendFactor = 0.45
            break;
            
        default:
            
            break
        }
    }
    
    func eclodeEgg()
    {
        let alien = Entity_Alien(texture:SKTexture(image: UIImage(named: "Alien")!) , color: UIColor.whiteColor(), size: self.size)
        alien.position = self.position
        alien.mapX = mapX
        alien.mapY = mapY
        alien.zPosition = 3
        alien.startAlien()
        destroy = true
        self.parent?.addChild(alien)
        Sound_Manager.sharedInstance.startAlienSound()

    }
    
}