//
//  Scene_Gameplay.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 13/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import SpriteKit
import GameController

public class Scene_Gameplay : SKScene
{
    //Objetos de utilidade.
    var entityMat:[[SKSpriteNode]]!
    var map:Map!
    var originX:Int = 400
    var originY:Int = 600
    var tileSize:Int = 64
    var stageTime = 0
    var timeLabel:SKLabelNode!
    var scoreLabel:SKLabelNode!
    var cronometro:SKSpriteNode!
    var background:SKSpriteNode!
    var eggFrequency:CFTimeInterval = 5
    var score = 0
    var protectSpawn = 0
    public var nivel: Int?
    
    //Nem mexe nisso abaixo.
    
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var eggSpawnTime: CFTimeInterval = 0
    var timerCount:CFTimeInterval = 0
    weak var controller:GCController!
    weak public var gameController : GameViewController!
    
    //Personagem.
    var player:Entity_Player!
    
    deinit
    {

        originX = 0
        originY = 0
        tileSize = 0
        eggFrequency = 0
        lastUpdateTimeInterval = 0
        eggSpawnTime = 0
        controller = nil
        timerCount = 0
        player.texture = nil
        player = nil
        cronometro = nil
        background = nil
        gameController = nil
        removeAllActions()
        removeAllChildren()
        entityMat = nil
        map = nil
    }
    
    override public func didMoveToView(view: SKView)
    {
        //Iniciar controle
        controller = Controller_Singleton.sharedInstance.controller
        
        //Parar música ao entrar no gameplay
        Sound_Manager.sharedInstance.stopTitleMusic()
        
        //Substituir depois pelo loader de mapas.
        let loader = Map_Loader()
        map = loader.loadMap(nivel!)
        stageTime = map.time
        eggFrequency = CFTimeInterval(map.eggFrequency)
        originX = Int(self.size.width/2) - (((map.rowSize-1)*tileSize) / 2)
        originY = Int(self.size.height/2) + (((map.columnSize-1)*tileSize) / 2)
        
        //Background
        background = SKSpriteNode(imageNamed: "background")
        
        //background.size = CGSizeMake(self.size.width, self.size.height)
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        self.addChild(background)
        
        //Set up timer.
        cronometro = SKSpriteNode(imageNamed: "cronometro")
        cronometro.position = CGPointMake(self.size.width - 145, 235)
        cronometro.size = CGSizeMake(270,200)
        cronometro.zPosition = 1
        self.addChild(cronometro)
        
        timerCount = 0
        
        timeLabel = SKLabelNode(text: "\(stageTime)")
        timeLabel.fontColor = UIColor.blackColor()
        timeLabel.fontSize = 60
        timeLabel.zPosition = 2
        timeLabel.position = CGPointMake(self.size.width - 150, 210)
        self.addChild(timeLabel)
        
        //Set up score
        scoreLabel = SKLabelNode(text: "\(score)")
        scoreLabel.fontSize = 80
        scoreLabel.position = CGPointMake(180,215)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        //Matriz de entidades.
        entityMat = [[SKSpriteNode]](count: map.rowSize, repeatedValue: [SKSpriteNode](count: map.columnSize, repeatedValue: SKSpriteNode()))
        
        //Criar objetos.
        for y in 0...map.rowSize-1
        {
            
            for x in 0...map.columnSize-1
            {
                if(map.matrix[y][x] == 0)
                {
                    let nothing = SKSpriteNode(imageNamed: "Comum_chao")
                    nothing.size = CGSizeMake(CGFloat(tileSize),CGFloat(tileSize))
                    nothing.position = CGPointMake(CGFloat(originX+tileSize*x), CGFloat(originY+tileSize*(-y)))
                    nothing.name = "nothing"
                    nothing.zPosition = 1
                    self.addChild(nothing)
                    entityMat[y][x] = nothing
                }
                else if(map.matrix[y][x] == 1)
                {
                    let wall = SKSpriteNode(imageNamed: "Comum_parede")
                    wall.size = CGSizeMake(CGFloat(tileSize),CGFloat(tileSize))
                    wall.position = CGPointMake(CGFloat(originX+tileSize*x), CGFloat(originY+tileSize*(-y)))
                    wall.name = "wall"
                    wall.zPosition = 1
                    self.addChild(wall)
                    entityMat[y][x] = wall
                }
                else if(map.matrix[y][x] == 2)
                {
                    let hole = SKSpriteNode(imageNamed: "Comum_buraco")
                    hole.size = CGSizeMake(CGFloat(tileSize),CGFloat(tileSize))
                    hole.position = CGPointMake(CGFloat(originX+tileSize*x), CGFloat(originY+tileSize*(-y)))
                    hole.name = "wall"
                    hole.zPosition = 1
                    self.addChild(hole)
                    entityMat[y][x] = hole
                }
                else if(map.matrix[y][x] == 3)
                {
                    let nothing = SKSpriteNode(imageNamed: "Comum_chao")
                    nothing.size = CGSizeMake(CGFloat(tileSize),CGFloat(tileSize))
                    nothing.position = CGPointMake(CGFloat(originX+tileSize*x), CGFloat(originY+tileSize*(-y)))
                    nothing.name = "nothing"
                    nothing.zPosition = 1
                    self.addChild(nothing)
                    player = Entity_Player(imageNamed: "char01")
                    player.size = CGSizeMake(CGFloat(tileSize - 22),CGFloat(tileSize))
                    player.zPosition = 10
                    player.position = CGPointMake(CGFloat(originX+tileSize*x), CGFloat(originY+tileSize*(-y)))
                    player.mapX = x
                    player.mapY = y
                    player.direction = 0
                    self.addChild(player)
                    map.matrix[y][x] = 0
                    entityMat[y][x] = nothing
                }
            }
        }
        
        //Criar gestures para o controle.
        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroUp))
        gestureUp.direction = UISwipeGestureRecognizerDirection.Up
        
        let gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroDown))
        gestureDown.direction = UISwipeGestureRecognizerDirection.Down
        
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroLeft))
        gestureLeft.direction = UISwipeGestureRecognizerDirection.Left
        
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroRight))
        gestureRight.direction = UISwipeGestureRecognizerDirection.Right
        
        let gestureTapUp = UITapGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroUp))
        gestureTapUp.allowedPressTypes = [NSNumber(integer: UIPressType.UpArrow.rawValue)]
        
        let gestureTapDown = UITapGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroDown))
        gestureTapDown.allowedPressTypes = [NSNumber(integer: UIPressType.DownArrow.rawValue)]
        
        let gestureTapLeft = UITapGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroLeft))
        gestureTapLeft.allowedPressTypes = [NSNumber(integer: UIPressType.LeftArrow.rawValue)]
        
        let gestureTapRight = UITapGestureRecognizer(target: self, action: #selector(Scene_Gameplay.moveHeroRight))
        gestureTapRight.allowedPressTypes = [NSNumber(integer: UIPressType.RightArrow.rawValue)]
        
        let gesturePlayPause = UITapGestureRecognizer(target: self, action: #selector(Scene_Gameplay.usePowerUp))
        gesturePlayPause.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)];
        
        self.view?.addGestureRecognizer(gestureTapDown)
        self.view?.addGestureRecognizer(gestureTapLeft)
        self.view?.addGestureRecognizer(gestureTapRight)
        self.view?.addGestureRecognizer(gestureTapUp)
        self.view?.addGestureRecognizer(gestureRight)
        self.view?.addGestureRecognizer(gestureLeft)
        self.view?.addGestureRecognizer(gestureUp)
        self.view?.addGestureRecognizer(gestureDown)
       // self.view?.addGestureRecognizer(gesturePlayPause)
    }
    
    public func moveHero(movX: Int, movY: Int)
    {
        if(player.mapX+movX >= 0 && player.mapX+movX < map.rowSize
            && player.mapY+movY >= 0 && player.mapY+movY < map.columnSize)
        {
            //Se ele tentar empurrar um alien.
            if(map.matrix[player.mapY+movY][player.mapX+movX] == 4)
            {
                moveAlien(player.mapX+movX, movOY: player.mapY+movY, movX: movX, movY: movY)
            }
                //Ciclo de andar comum.
            else if(map.matrix[player.mapY+movY][player.mapX+movX] == 0)
            {
                player.position = CGPointMake(player.position.x+CGFloat(tileSize * movX),player.position.y+CGFloat(tileSize * -movY))
                player.mapX  = player.mapX+movX
                player.mapY  = player.mapY+movY
                Sound_Manager.sharedInstance.startStep()
            }
        }
    }
    
    public func moveAlien(movOX: Int, movOY: Int, movX: Int, movY: Int)
    {
        //Ver se o tile onde o alien vai ser empurrado esta livre.
        if(player.mapX+(movX*2) >= 0 && player.mapX+(movX*2) < map.rowSize
            && player.mapY+(movY*2) >= 0 && player.mapY+(movY*2) < map.columnSize)
        {
            if(map.matrix[player.mapY+(movY*2)][player.mapX+(movX*2)] == 0)
            {
                if let alien = entityMat[movOY][movOX] as? Entity_AlienEgg
                {
                    entityMat[movOY+movY][movOX+movX] = entityMat[movOY][movOX]
                    entityMat[movOY][movOX] = SKSpriteNode()
                    alien.position = CGPointMake(CGFloat(originX+((movOX+movX)*tileSize)), CGFloat(originY-(movOY+movY)*tileSize))
                    alien.mapX = movOX+movX
                    alien.mapY = movOY+movY
                    map.matrix[movOY][movOX] = 0
                    map.matrix[movOY+movY][movOX+movX] = 4
                    moveHero(movX, movY:movY)
                    Sound_Manager.sharedInstance.startEggPushing()
                }
            }
            else if(map.matrix[player.mapY+(movY*2)][player.mapX+(movX*2)] == 2)
            {
                score += 1
                scoreLabel.text = "\(score)"
                let hole = entityMat[player.mapY+(movY*2)][player.mapX+(movX*2)]
                hole.runAction(SKAction.animateWithTextures([SKTexture(imageNamed: "Ovo_Anim1"), SKTexture(imageNamed: "Ovo_Anim2"), SKTexture(imageNamed: "Ovo_Anim3"), SKTexture(imageNamed: "Ovo_Anim4"),SKTexture(imageNamed: "Comum_buraco")], timePerFrame: 0.15))
                
                Sound_Manager.sharedInstance.startEggFalling()
                destroyEggAt(movOX, posY: movOY)
            }
        }
    }
    
    public func pullAlien()
    {
        var movX = 0
        var movY = 0
        switch(player.direction)
        {
        case 0:
            movY = -1
            break;
            
        case 1:
            movY = 1
            break;
            
        case 2:
            movX = -1
            break;
            
        case 3:
            movX = 1
            break;
            
        default:
            break;
        }
        
        if(player.mapX+movX >= 0 && player.mapX+movX < map.rowSize
            && player.mapY+movY >= 0 && player.mapY+movY < map.columnSize
            && map.matrix[player.mapY+movY][player.mapX+movX] == 4)
        {
            //            if(player.mapX+(-movX) >= 0 && player.mapX+(-movX) < map.rowSize
            //                && player.mapY+(-movY) >= 0 && player.mapY+(-movY) < map.columnSize
            //                && map.map[player.mapY+(-movY)][player.mapX+(-movX)] == 0)
            //            {
            if let alien = entityMat[player.mapY+movY][player.mapX+movX] as? Entity_AlienEgg
            {
                entityMat[player.mapY][player.mapX] = entityMat[player.mapY+movY][player.mapX+movX]
                entityMat[player.mapY+movY][player.mapX+movX] = SKSpriteNode()
                alien.position = CGPointMake(CGFloat(player.position.x), CGFloat(player.position.y))
                alien.mapX = player.mapX
                alien.mapY = player.mapY
                map.matrix[player.mapY+movY][player.mapX+movX] = 0
                map.matrix[player.mapY][player.mapX] = 4
                
                player.position = CGPointMake(player.position.x+CGFloat(tileSize * movX),player.position.y+CGFloat(tileSize * -movY))
                player.mapX  = player.mapX+movX
                player.mapY  = player.mapY+movY
            }
            // }
        }
        
    }
    
    public func destroyEggAt(posX:Int,posY:Int)
    {
        let alien = entityMat[posY][posX] as! Entity_AlienEgg
        alien.removeFromParent()
        entityMat[posY][posX] = SKSpriteNode()
        map.matrix[posY][posX] = 0
    }
    
    public func moveHeroUp()
    {
        player.direction = Entity_Player.DIRECTION_UP
        player.texture = SKTexture(imageNamed: "char04")
        moveHero(0,movY: -1)
    }
    
    public func moveHeroDown()
    {
        player.direction = Entity_Player.DIRECTION_DOWN
        player.texture = SKTexture(imageNamed: "char01")
        moveHero(0,movY: 1)
    }
    
    public func moveHeroLeft()
    {
        player.direction = Entity_Player.DIRECTION_LEFT
        player.texture = SKTexture(imageNamed: "char02")
        moveHero(-1,movY: 0)
    }
    
    public func moveHeroRight()
    {
        player.direction = Entity_Player.DIRECTION_RIGHT
        player.texture = SKTexture(imageNamed: "char03")
        moveHero(1,movY: 0)
    }
    
    public func usePowerUp(){


        for i in 0..<self.children.count
        {
            if let alien = self.children[i] as? Entity_Alien
            {
                alien.destroy = true
            }
            else if let egg = self.children[i] as? Entity_AlienEgg
            {
                egg.destroy = true
            }
        }
    }
    
    func spawnAlienEgg()
    {
        let positionX = Int(arc4random_uniform(UInt32(map.rowSize)))
        let positionY = Int(arc4random_uniform(UInt32(map.columnSize)))
        protectSpawn += 1
        if(map.matrix[positionY][positionX] == 0)
        {
            let egg = Entity_AlienEgg(imageNamed: "ovo")
            egg.size = CGSizeMake(CGFloat(tileSize), CGFloat(tileSize))
            egg.position = CGPointMake(CGFloat(originX+tileSize*positionX), CGFloat(originY+tileSize*(-positionY)))
            egg.name = "Egg"
            egg.zPosition = 3
            egg.mapX = positionX
            egg.mapY = positionY
            self.addChild(egg)
            map.matrix[positionY][positionX] = 4
            entityMat[positionY][positionX] = egg
            protectSpawn = 0
        }
        else
        {
            if(protectSpawn <= 20)
            {
                spawnAlienEgg()
            }
        }
    }
    
    public func checkInput()
    {
        if(controller.microGamepad != nil)
        {
            if(controller.microGamepad?.buttonA.pressed == true)
            {
                pullAlien()
            }
        }
    }
    
    func runTime()
    {
        stageTime -= 1
        timeLabel.text = "\(stageTime)"
        if(stageTime <= 0)
        {
            self.paused = true
            self.gameController!.stars = self.calculateStars()
            self.gameController!.showScore()
        }
    }
    
    func calculateStars() -> Int{

        if score >= map.twoStars && score < map.threeStars{
            return 2
        } else if score >= map.threeStars{
            return 3
        } else {
            return 1
        }
        
    }
    
    func gameOver()
    {
        self.paused = true
        self.gameController!.showGameOver()
    }
    
    
    override public func update(currentTime: CFTimeInterval)
    {
        var delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if delta >= 1.0
        {
            delta = 1
        }
        
        timerCount += delta
        eggSpawnTime += delta
        if(eggSpawnTime >= eggFrequency)
        {
            spawnAlienEgg()
            eggSpawnTime = 0
            eggFrequency -= 0.05
        }
        
        if(timerCount > 1)
        {
            runTime()
            timerCount = 0
        }
        
        if(controller == nil)
        {
            controller = Controller_Singleton.sharedInstance.controller
        }
        else
        {
            checkInput()
        }
        
        for i in 0..<self.children.count
        {
            if let alien = self.children[i] as? Entity_Alien
            {
                alien.doPath(delta, playerPathX: player.mapX, playerPathY: player.mapY, map: map, originX: originX, originY: originY, tileSize: tileSize )
                if(alien.destroy)
                {
                    alien.removeFromParent()
                    break
                }
                else
                if(alien.alienTouchedPlayer(player))
                {
                    gameOver()
                    break
                }
            }
            else if let egg = self.children[i] as? Entity_AlienEgg
            {
                egg.updateEgg(delta)
                if(egg.destroy)
                {
                    destroyEggAt(egg.mapX, posY: egg.mapY)
                    break
                }
            }
        }
    }
    
    
}