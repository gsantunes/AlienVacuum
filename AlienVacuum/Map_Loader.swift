//
//  Map_Loader.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 13/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import Foundation

public class Map_Loader
{

    public func loadMap(number: Int) -> Map
    {
        let m = Map()
        
        let filePath = NSBundle.mainBundle().pathForResource("Level\(number)", ofType:"jvss")
        
        let nsMutData = NSData(contentsOfFile: filePath!)
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData((nsMutData!), options: NSJSONReadingOptions(rawValue: 0)) as! [String:AnyObject]
            
            var mat = Array((json["map"] as! String).characters)
            
            m.time = Int((json["time"] as! NSString).intValue)
            m.type = Int((json["type"] as! NSString).intValue)
            m.twoStars = Int((json["2stars"] as! NSString).intValue)
            m.threeStars = Int((json["3stars"] as! NSString).intValue)
            m.rowSize = Int((json["rowSize"] as! NSString).intValue)
            m.eggFrequency = Int((json["eggFrequency"] as! NSString).intValue)
            m.columnSize = Int((json["columnSize"] as! NSString).intValue)
 
            var primerMatrix = [[Int]](count: m.rowSize, repeatedValue:[Int](count:m.columnSize, repeatedValue: Int()))
            var counter = 0
            
            var nMat = [Int]()
            var size = 0
            for sz in 0..<mat.count
            {
                if(mat[sz] != ",")
                {
                    nMat.append(Int(String(mat[sz]))!)
                    size += 1
                }
            }
            
            for row in 0..<m.rowSize
            {
                for column in 0..<m.columnSize
                {
                    primerMatrix[row][column] = nMat[counter]
                    counter += 1
                }
            }

            m.matrix = primerMatrix
        }
         catch{
            print(error)
        }
        
        return m

}

}