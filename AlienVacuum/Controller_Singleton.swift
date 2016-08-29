//
//  Controller_Singleton.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 13/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import GameController

private let sharedControllerSingleton = Controller_Singleton()

public class Controller_Singleton : NSObject,Controller_Delegate
{
    public var controller:GCController!
    
    class var sharedInstance : Controller_Singleton
    {
        return sharedControllerSingleton
    }
    
    override init()
    {
        super.init()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dpadDelegate = self
    }
    
    func didDpadChanged(controller:GCController)
    {
        self.controller = controller
        if(controller.microGamepad != nil)
        {
            self.controller.microGamepad?.allowsRotation = false
            self.controller.microGamepad?.reportsAbsoluteDpadValues = true
        }
    }
}