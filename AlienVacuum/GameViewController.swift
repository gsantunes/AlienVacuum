//
//  GameViewController.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 13/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import UIKit
import SpriteKit

public class GameViewController: UIViewController
{
    var skscene:Scene_Gameplay!
    var inMenu = false
    
    var stars: Int!
    
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStars: UIImageView!
    @IBOutlet weak var threeStars: UIImageView!
    
    @IBOutlet weak var GameOverView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    public var levelSelected: Int?
    
    deinit
    {
        skscene = nil
    }
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(animated: Bool)
    {
        inMenu = false
        if let scene = Scene_Gameplay(fileNamed: "Scene_Gameplay")
        {
            skscene = scene
            scene.gameController = self
            
            scene.nivel = levelSelected!
            
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "backToMenu")
        {
            self.dismissViewControllerAnimated(false) {
                
            }
            
        }
    }
    
    @IBAction func toMenu(sender: AnyObject)
    {
        skscene.gameOver()
        performSegueWithIdentifier("backToMenu", sender: nil)
    }
    
    public func showGameOver()
    {
        GameOverView.hidden = false
        inMenu = true
        Sound_Manager.sharedInstance.startDefeat()
       // removeGestures()
        self.setNeedsFocusUpdate()
    }
    
//    public func removeGestures()
//    {
//        for i in self.view.gestureRecognizers!
//        {
//            self.view.removeGestureRecognizer(i)
//        }
//    }
    
    
    public func showScore()
    {
        
        scoreView.hidden = false
        inMenu = true
        Sound_Manager.sharedInstance.startVictory()
        
        switch stars {
        case 1:
            oneStar.hidden = false
        case 2:
            twoStars.hidden = false
        case 3:
            threeStars.hidden = false
        default:
            break
        }
        
        let playerHelper = Player_Manager.sharedInstance
        
        //retrieving stars array from user default
        //has to do this because it overrides the old array
        let starData = NSUserDefaults.standardUserDefaults().objectForKey("stars") as? NSData
        
        if starData != nil{
            if let data = starData {
                let starsArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Int]
                playerHelper.starsPerLevel = starsArray!
            }
        }
        
        //saving stars array from user default
        if playerHelper.starsPerLevel[levelSelected!] < stars {
            playerHelper.starsPerLevel[levelSelected!] = stars
            let starsData = NSKeyedArchiver.archivedDataWithRootObject(playerHelper.starsPerLevel)
            NSUserDefaults.standardUserDefaults().setObject(starsData, forKey: "stars")
        }
        //removeGestures()
        self.setNeedsFocusUpdate()
    }
    
    public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    {
        context.nextFocusedView?.layer.frame.size = CGSize(width: 380, height: 350)
        context.nextFocusedView?.layer.position.x -= 50
        context.nextFocusedView?.layer.position.y -= 50
        
        context.previouslyFocusedView?.layer.frame.size = CGSize(width: 280, height: 250)
        context.previouslyFocusedView?.layer.position.x += 50
        context.previouslyFocusedView?.layer.position.y += 50
        
    }
    
    override weak public var preferredFocusedView: UIView?
    {
        if(inMenu)
        {
            return scoreView
        }
        else
        {
            return self.view
        }
    }
    
    override public func viewDidDisappear(animated: Bool)
    {
        skscene = nil
        self.view = nil
        self.navigationController?.popViewControllerAnimated(false)
    }
}
