//
//  Controller_Delegate.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 17/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import GameController

protocol Controller_Delegate
{
    func didDpadChanged(controller:GCController) -> Void
}