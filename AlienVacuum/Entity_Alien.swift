//
// Entity_Alien.swift
// AlienVacuum
//
// Created by João Vitor dos Santos Schimmelpfeng on 18/05/16.
// Copyright © 2016 Guilherme. All rights reserved.
//

import SpriteKit

public class Entity_Alien : SKSpriteNode
{
    deinit
    {
        pathEngine = nil
        path = nil
        actualNode = nil
        texture1 = nil
        texture2 = nil
        self.texture = nil
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
    }
    
    var mapX:Int!
    var mapY:Int!
    var path:Queue<Path_Node>!
    var pathEngine:PathFinder!
    var actualNode:Path_Node!
    var updatePathTime: Double = 3
    var pathUpdateFrequency:Double = 2
    var alienSpeed = 1
    var animTime:Double = 0
    var isOnAnim = false
    var destroy = false
    var offset:CGFloat = 32
    var texture1:SKTexture!
    var texture2:SKTexture!
    
    func startAlien()
    {
        pathEngine = PathFinder()
        texture1 = SKTexture(imageNamed: "Alien")
        texture2 = SKTexture(imageNamed: "AlienAnimation")
    }
    
    func changeSprite()
    {
        if(isOnAnim)
        {
            self.texture = texture1
            isOnAnim = false
        }
        else
        {
            self.texture = texture2
            isOnAnim = true
        }
    }
    
    func updatePaths(playerPathX: Int, playerPathY: Int, map: Map)
    {
        path = nil
        path = pathEngine.findPath(mapX, fromY: mapY, toX: playerPathX, toY: playerPathY, map: map)
    }
    
    func alienTouchedPlayer(player: Entity_Player) -> Bool
    {
        if((self.position.x+offset) > player.position.x && (self.position.x-offset) < player.position.x &&
           (self.position.y+offset) > player.position.y && (self.position.y-offset) < player.position.y )
        {
            return true
        }
        
        return false
    }
    
    func doPath(delta: CFTimeInterval,playerPathX: Int, playerPathY: Int, map: Map, originX: Int, originY: Int, tileSize: Int)
    {
        updatePathTime += Double(delta)
        animTime += Double(delta)
        
        if(updatePathTime > pathUpdateFrequency && !self.hasActions())
        {
            updatePaths(playerPathX, playerPathY: playerPathY, map: map)
            actualNode = nil
            if(!path.isEmpty())
            {
                path.dequeue()
            }
            updatePathTime = 0
        }
        
        if(animTime >= 0.5)
        {
            animTime = 0
            changeSprite()
        }
        
        if(actualNode == nil)
        {
            if(path != nil && !path.isEmpty())
            {
                actualNode = path.dequeue()
            }
        }
        else if(!self.hasActions())
        {
            runAction(SKAction.moveToX(CGFloat(originX+tileSize*actualNode.mapX), duration: Double(alienSpeed)))
            runAction(SKAction.moveToY(CGFloat(originY+tileSize*(-actualNode.mapY)), duration: Double(alienSpeed)))
            mapX = actualNode.mapX
            mapY = actualNode.mapY
            actualNode = nil
        }
    }
}