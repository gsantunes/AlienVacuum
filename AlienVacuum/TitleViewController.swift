//
//  TitleViewController.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 13/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import UIKit
import AVFoundation

class TitleViewController: UIViewController {
    
    
    
    deinit
    {
       
    }
    
    override func viewDidLoad() {
        Sound_Manager.sharedInstance.startTitleMusic()
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "toGame")
        {
            self.navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(false) {
                
            }
            
        }
    }
    
}
