//
//  Player_Manager.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 13/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import Foundation

class Player_Manager: NSObject
{
    static let sharedInstance = Player_Manager()
    var currentLevel: Int = 0

    var starsPerLevel: [Int] = [0,0,0,0,0,0,0,0,0,0]
}