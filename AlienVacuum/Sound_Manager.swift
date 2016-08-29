//
//  Sound_Manager.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 13/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import Foundation
import AVFoundation

class Sound_Manager: NSObject {
    
    static let sharedInstance = Sound_Manager()
    
    var titleAudioPlayer = AVAudioPlayer()
    var alienAudioPlayer = AVAudioPlayer()
    var eggFallingAudioPlayer = AVAudioPlayer()
    var eggPushingAudioPlayer = AVAudioPlayer()
    var stepAudioPlayer = AVAudioPlayer()
    var victoryAudioPlayer = AVAudioPlayer()
    var defeatAudioPlayer = AVAudioPlayer()
    
    var titleMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("titleMusic", ofType: "wav")!)
    var alienSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("GrunhidoAlien", ofType: "wav")!)
    var eggFalling = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("OvoCaindo", ofType: "wav")!)
    var eggPushing = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("EmpurrandoOvos", ofType: "wav")!)
    var step = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Passo", ofType: "wav")!)
    var victorySound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("victory", ofType: "m4a")!)
    var defeatSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("defeat", ofType: "wav")!)
    
    func startTitleMusic(){
        titleAudioPlayer = try! AVAudioPlayer(contentsOfURL: titleMusic)
        titleAudioPlayer.prepareToPlay()
        titleAudioPlayer.play()
        titleAudioPlayer.numberOfLoops = -1
    }
    
    func stopTitleMusic(){
        titleAudioPlayer = try! AVAudioPlayer(contentsOfURL: titleMusic)
        titleAudioPlayer.stop()
    }
    
    func checkIfPlayingTitle() -> Bool {
        if titleAudioPlayer.playing {
            return true
        }
        titleAudioPlayer.play()
        titleAudioPlayer.numberOfLoops = -1
        return false
    }
    
    func startAlienSound(){
        alienAudioPlayer = try! AVAudioPlayer(contentsOfURL: alienSound)
        alienAudioPlayer.prepareToPlay()
        alienAudioPlayer.play()
    }
    
    func startEggFalling(){
        eggFallingAudioPlayer = try! AVAudioPlayer(contentsOfURL: eggFalling)
        eggFallingAudioPlayer.prepareToPlay()
        eggFallingAudioPlayer.play()
    }
    
    func startEggPushing(){
        eggPushingAudioPlayer = try! AVAudioPlayer(contentsOfURL: eggPushing)
        eggPushingAudioPlayer.prepareToPlay()
        eggPushingAudioPlayer.play()
    }
    
    func startStep(){
        stepAudioPlayer = try! AVAudioPlayer(contentsOfURL: step)
        stepAudioPlayer.prepareToPlay()
        stepAudioPlayer.play()
    }
    
    func startVictory(){
        victoryAudioPlayer = try! AVAudioPlayer(contentsOfURL: victorySound)
        victoryAudioPlayer.prepareToPlay()
        victoryAudioPlayer.play()
    }
    
    func startDefeat(){
        defeatAudioPlayer = try! AVAudioPlayer(contentsOfURL: defeatSound)
        defeatAudioPlayer.prepareToPlay()
        defeatAudioPlayer.play()
    }
    
}